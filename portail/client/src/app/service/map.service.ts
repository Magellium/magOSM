import { Injectable, Output, EventEmitter } from '@angular/core';
import { UserContext } from '../model/UserContext';

import * as shapefile from 'shapefile'
import { Change } from 'app/model/ChangesClasses/Change';
import { ChangeType } from 'app/model/ChangesClasses/ChangeType';
import { ConfigService } from './config.service';

declare var ol: any;
declare var _paq: any;
declare var window: any;
//declare var config: any;
declare var fetch: any;

@Injectable()
export class MapService {

  public config: any;

  public map: any;
  public ol: any;
  public layers: Object = {};

  private selectedFeatureSource: any;
  private selectedFeatureStyle: any;

  private INCHES_PER_UNIT = { 'm': 39.37, 'dd': 4374754 };
  private DOTS_PER_INCH = 90;

  loadingCounter = 0;
  //fonds de carte
  private OSMLayer: any;
  private baseLayer: any;
  private baseLayerName: string;
  private opacityRange = 30;

  //Suivi de changements
  public changesStyles = new Map();
  public changesPointStyles = new Map();
  private hover : any;
  //public pointStyles;

  @Output() announceOpacityChangeEvent: EventEmitter<any> = new EventEmitter();
  //legende
  public legendUrls: string[];//au niveau infra-communal il y a autant d'urls de légendes que de couches visibles
  public legendSubTitles: string[];
  public legendTitle: string;
  public currentScale: any;

  wmtsResult: any;


  constructor(
    private configService: ConfigService
  ) { 
    this.configService.getConfig().subscribe(config => {
      this.config=config;
    })
  }

  setMap(map, userContext: UserContext) {
    this.map = map;
    this.setBaseLayers();
    this.changeOpacity(userContext.tr);
  }

  setWMTSResult(wmtsResult) {
    this.wmtsResult = wmtsResult
  }

  setBaseLayers() {
    //initialisation des sources et des layers de fond de carte OSM
    this.OSMLayer = new ol.layer.Tile({
      title: 'OSM',
      source: new ol.source.OSM(),
      visible: true,
      zIndex: 0
    });
    this.baseLayer = this.OSMLayer;
    this.map.addLayer(this.OSMLayer);
  };

  changeOpacity(value: number) {//défini l'opacité des layers

    if (this.baseLayer) {
      this.opacityRange = value;
      this.baseLayer.setOpacity(this.opacityRange / 100);

    }

    this.emitOpacityChangeEvent(this.opacityRange);
  }

  emitOpacityChangeEvent(newOpacityRange) {
    this.announceOpacityChangeEvent.emit(newOpacityRange);
  }

  getAnnounceOpacityChangeEventEmitter() {
    return this.announceOpacityChangeEvent;
  }

  changeBaseLayer(baseLayerName) {
    this.baseLayerName = baseLayerName;
    this.baseLayer.setVisible(false);
    if (baseLayerName === 'OSM') {
      this.baseLayer = this.OSMLayer;
    }
    else {
      this.baseLayer = this.getLayersById(baseLayerName)
    }
    this.baseLayer.setOpacity(this.opacityRange / 100);
    this.baseLayer.setVisible(true);
    this.baseLayer.setVisible(true);
  }

  setLegendAttributes(key, value) {
    if (key = "legendUrls") {
      this.legendUrls = value;
    }
  }

  getLayersById(id: string): any {

    return this.layers[id];
  }
  cleanSelection() {
    this.selectedFeatureSource.clear();
  }
  addToSelection(feature) {
    this.selectedFeatureSource.addFeature(feature);
    let piwikFeatureSelectedLayer = feature.getId().substring(0, feature.getId().indexOf('.fid'))
    _paq.push(['trackEvent', 'feature_selected', piwikFeatureSelectedLayer])
  }
  addSelectionLayer() {
    //initialisation de selectedFeatureSource et selectedFeatureStyle
    this.selectedFeatureSource = new ol.source.Vector({});

    var fill = new ol.style.Fill({
      color: 'rgba(150, 6, 6, 0)'
    });
    var stroke = new ol.style.Stroke({
      color: 'rgb(150, 6, 6)',
      width: 2
    });
    this.selectedFeatureStyle = [
      new ol.style.Style({
        image: new ol.style.Circle({
          fill: fill,
          stroke: stroke,
          radius: 10
        }),
        fill: fill,
        stroke: stroke
      })
    ];


    let selectionLayer = new ol.layer.Vector({ //initialisation d'un layer vide, on y a ajouté le feature sélectionné par l'utilisateur
      source: this.selectedFeatureSource,
      style: this.selectedFeatureStyle,
      zIndex: 4
    });
    this.map.addLayer(selectionLayer);

  }
  addVectorTileLayer(layerconfig: any, show: boolean = false) {
    let self = this;
    let layername = layerconfig.layername;
    let id = layerconfig.layername;
    let lshow = show;
    let lconfig = layerconfig;
    let matrixSet = "EPSG:3857";

    if (this.layers[id] == null) {
      var options = ol.source.WMTS.optionsFromCapabilities(this.wmtsResult, {
        layer: layername,
        matrixSet: matrixSet,
        format: 'application/x-protobuf;type=mapbox-vector'
      });
      options.attributions = [new ol.Attribution({
        html: '' +
          '<a href="http://magosm.magellium.com/aide.html#ogc-services-tos">© Magellium pour les flux WMS/WFS</a>'
      })
      ];
      var wmts = new ol.source.WMTS(options);
      console.log(wmts.getTileUrlFunction());

      self.layers[id] = new ol.layer.VectorTile({
        opacity: 1,
        source: new ol.source.VectorTile({
          format: new ol.format.MVT(),
          tileUrlFunction: wmts.getTileUrlFunction(),
          tileGrid: wmts.getTileGrid()
        })
      });
      self.layers[id].customConfig = lconfig;
      lconfig.ol_Layer = self.layers[id];
      self.map.addLayer(self.layers[id]);
      self.layers[id].setVisible(lshow);
    }
    else {
      this.layers[id].setVisible(show);
    }
  }
  addLoading(e) {
    this.loadingCounter++;
    if (!e.target.loadingCounter) {
      e.target.loadingCounter = 0;
    }
    e.target.loadingCounter++;
  }
  addLoaded(e) {
    this.loadingCounter--;
    e.target.loadingCounter--;
  }
  addLoadError(e) {
    this.loadingCounter--;
    e.target.loadingCounter--;
  }
  addWMSLayer(layerconfig: any, show: boolean = false) {
    let id = layerconfig.layername;
    //console.log(id);
    let layername = layerconfig.layername;
    if (this.layers[id] == null) {

      var layerSource = new ol.source.TileWMS(({
        url: this.config.PARAMS[0].geoserver_baseurl + '/wms?',
        crossOrigin: 'anonymous',
        params: { 'LAYERS': layername },
        attributions: [new ol.Attribution({
          html: '' +
            '<a href="http://magosm.magellium.com/aide.html#ogc-services-tos">© Magellium pour les flux WMS/WFS</a>'
        })
        ]
      }));

      this.addLoadingListener(layerSource);
      var maxResolution = undefined;
      if (layerconfig.maxScaleDenominator) {

        maxResolution = this.getResolutionFromScale(layerconfig.maxScaleDenominator, this.map.getView().getProjection().getUnits());
      }
      this.layers[id] = new ol.layer.Tile({
        source: layerSource,
        zIndex: 1,
        maxResolution: maxResolution

      });
      this.layers[id].setVisible(show);

      this.map.addLayer(this.layers[id]);
    }
    else {
      this.layers[id].setVisible(show);
    }
  }

  addLoadingListener(layerSource) {
    layerSource.on('tileloadstart',
      this.addLoading.bind(this)
    );

    layerSource.on('tileloadend',
      this.addLoaded.bind(this)
    );
    layerSource.on('tileloaderror',
      this.addLoadError.bind(this)
    );
  }
  addWMTSLayer(layerconfig: any, show: boolean = false) {


    let self = this;
    let layername = layerconfig.layername;
    let id = layerconfig.layername;
    let lshow = show;
    let lconfig = layerconfig;
    let matrixSet = "EPSG:3857";

    if (this.layers[id] == null) {
      var options = ol.source.WMTS.optionsFromCapabilities(this.wmtsResult, {
        layer: layername,
        matrixSet: matrixSet
      });
      options.attributions = [new ol.Attribution({
        html: '' +
          '<a href="http://magosm.magellium.com/aide.html#ogc-services-tos">© Magellium pour les flux WMS/WFS</a>'
      })
      ];

      var layerSource = new ol.source.WMTS(/** @type {!olx.source.WMTSOptions} */(options));
      this.addLoadingListener(layerSource);

      var maxResolution = undefined;
      if (layerconfig.maxScaleDenominator) {

        maxResolution = this.getResolutionFromScale(layerconfig.maxScaleDenominator, this.map.getView().getProjection().getUnits());
      }


      self.layers[id] = new ol.layer.Tile({
        opacity: 1,
        source: layerSource,
        maxResolution: maxResolution
      });
      self.layers[id].customConfig = lconfig;
      lconfig.ol_Layer = self.layers[id];
      self.map.addLayer(self.layers[id]);
      self.layers[id].setVisible(lshow);
    }
    else {
      this.layers[id].setVisible(show);
    }
  }



  kmlExport(layer) {
    var size = /** @type {ol.Size} */ (this.map.getSize());
    var extent = this.map.getView().calculateExtent(size);

    var targetDPI = 150;
    var siszeFactor = targetDPI / 90;
    console.log(extent);
    let bbox = extent[0] + "," + extent[1] + "," + extent[2] + "," + extent[3];

    let currentScale = this.getScaleFromResolution(this.map.getView().getResolution(), this.map.getView().getProjection().getUnits(), true);
    //alert("L'export concerne uniquement la zone visualisée");
    /*if (currentScale > 500000) {
      alert("l'export n'est possible qu'a partir du de l'échelle 1/500 000")
      return;
    }*/

    let url = this.config.PARAMS[0].geoserver_baseurl + "/wms?service=wms&request=GetMap&version=1.1.1&format=application/vnd.google-earth.kml+xml&layers=" + layer.layername /*+ "&styles=" + layer.selectedStyle.style*/ + "&height=2048&width=2048&transparent=false&srs=EPSG:3857&format_options=AUTOFIT:true;KMATTR:true;KMPLACEMARK:false;KMSCORE:40;MODE:download;SUPEROVERLAY:false&bbox=" + bbox;
    //let url = config.PARAMS[0].geoserver_baseurl + "/wfs?request=GetFeature&version=2.0.0&count=50000&outputFormat=application%2Fvnd.google-earth.kml%2Bxml&typeName="+layer.layername;
    //let url = config.PARAMS[0].geoserver_baseurl + "/wms/kml?layers="+layer.layername;

    //piwik
    _paq.push(['trackEvent', 'KML_download', layer.layername])

    window.open(url, "_blank");
  }
  getScale() {

    return this.getScaleFromResolution(this.map.getView().getResolution(), this.map.getView().getProjection().getUnits(), true);
  }
  shpExport(layer) {
    var size = /** @type {ol.Size} */ (this.map.getSize());
    var extent = this.map.getView().calculateExtent(size);

    var targetDPI = 150;
    var siszeFactor = targetDPI / 90;
    console.log(extent);
    let bbox = extent[0] + "," + extent[1] + "," + extent[2] + "," + extent[3];
    //alert("L'export concerne uniquement la zone visualisée");
    let currentScale = this.getScaleFromResolution(this.map.getView().getResolution(), this.map.getView().getProjection().getUnits(), true);
    /*if (currentScale > 500000) {
      alert("l'export n'est possible qu'a partir du de l'échelle 1/500 000")
      return;
    }*/

    //let url = config.PARAMS[0].geoserver_baseurl + "/wms?service=wms&request=GetMap&version=1.1.1&format=application/vnd.google-earth.kml+xml&layers=" + layer.layername /*+ "&styles=" + layer.selectedStyle.style*/ + "&height=2048&width=2048&transparent=false&srs=EPSG:3857&format_options=AUTOFIT:true;KMATTR:true;KMPLACEMARK:false;KMSCORE:40;MODE:download;SUPEROVERLAY:false&bbox=" + bbox;
    let url = this.config.PARAMS[0].geoserver_baseurl + "/wfs?request=GetFeature&version=2.0.0&count=500000&outputFormat=shape-zip&typeName=" + layer.layername + "&srsName=EPSG:3857&bbox=" + bbox;
    //let url = config.PARAMS[0].geoserver_baseurl + "/wms/kml?layers="+layer.layername;

    //piwik
    _paq.push(['trackEvent', 'SHP_download', layer.layername])

    window.open(url, "_blank");
  }

  getBoundingBox() {
    let format = new ol.format.WKT();
    let extent = ol.geom.Polygon.fromExtent(this.map.getView().calculateExtent());
    var wkt = format.writeGeometry(extent);
    return wkt;
  }


  getResolutionFromScale(scale, units) {
    var resolution = scale / (this.INCHES_PER_UNIT[units] * this.DOTS_PER_INCH);
    return resolution;
  };

  getScaleFromResolution(resolution, units, opt_round) {
    var scale = this.INCHES_PER_UNIT[units] * this.DOTS_PER_INCH * resolution;
    console.log("scale : " + scale + " / resolution : " + resolution)
    if (opt_round) {
      scale = Math.round(scale);
    }
    return scale;
  };

  getVisibleLayersIdList() {
    let id_layers = "";
    let separator = "";
    let layers = this.map.getLayers().getArray();

    for (var i = 0; i < layers.length; i++) {
      var layer = layers[i];
      if (layer instanceof ol.layer.Tile && layer.getSource() instanceof ol.source.TileWMS && layer.getVisible()) {

        id_layers += separator + (layer.getSource()).getParams()['LAYERS'] + '';//<ol.source.TileWMS>
        separator = ",";
      } else if (layer instanceof ol.layer.Tile && layer.getSource() instanceof ol.source.WMTS && layer.getVisible()) {
        id_layers += separator + (layer.getSource()).getLayer() + '';//<ol.source.WMTS>
        separator = ",";
      }

    }
    console.log(id_layers);
    return id_layers;
  }

  getVisibleLayersIdArrayList() {
    let id_layers = [];
    let layers = this.map.getLayers().getArray();

    for (var i = 0; i < layers.length; i++) {
      var layer = layers[i];
      if (layer instanceof ol.layer.Tile && layer.getSource() instanceof ol.source.TileWMS && layer.getVisible()) {
        id_layers.push((layer.getSource()).getParams()['LAYERS']);//<ol.source.TileWMS>
      } else if (layer instanceof ol.layer.Tile && layer.getSource() instanceof ol.source.WMTS && layer.getVisible()) {
        id_layers.push((layer.getSource()).getLayer());
      }
    }
    return id_layers;
  }

  getNumberOfVisibleLayers(){
    return this.getVisibleLayersIdArrayList().length;
  }

  getZoomFromScale(scale) {
    var resolution = this.getResolutionFromScale(scale, this.map.getView().getProjection().getUnits());
    var zoom = Math.ceil(this.map.getView().getZoomForResolution(resolution)); // Zoom level rounded up
    return zoom;
  }

  //Find the Layer of one object (useful for the list of nearby features, and for the style of main_info)
  getLayerOfOneFeature(feature){
    for (let i in this.config.LAYERS){
      for (let j in this.config.LAYERS[i].features){
        if (feature.getId().startsWith(this.config.LAYERS[i].features[j].layername.replace('magosm:',""))){
          return this.config.LAYERS[i].features[j];
        }
      }
    }
  }

  isInRange(id){
    if (this.layers[id]) {
      var maxResolution=this.layers[id].getMaxResolution();
      var minResolution=this.layers[id].getMinResolution();
      var currentResol=this.map.getView().getResolution();
      if(maxResolution && this.map.getView().getResolution()>maxResolution){
        return false;
      }
      if(minResolution && this.map.getView().getResolution()<minResolution){
        return false;
      }
      return true;
    }
    return false;

  }
  isVisible(id) {
    if (this.layers[id]) {
      return this.layers[id].getVisible();
    }
    return false;

  }
  addLayer(id: string, url: string, show: boolean = false) {
    if (this.layers[id] == null) {
      var vectorSource = new ol.source.Vector({
        //projection : 'EPSG:3857',
        //overlaps:false,
        format: new ol.format.GeoJSON({
          //defaultDataProjection: 'EPSG:4326'
          //defaultDataProjection: 'EPSG:2154'
        }),
        url: url
      });
      this.layers[id] = new ol.layer.Vector({
        source: vectorSource
      });

      var listenerKey = vectorSource.on('change', (function (e) {
        if (vectorSource.getState() == 'ready') {
          ol.Observable.unByKey(listenerKey);
          this.layers[id].setVisible(show);
        }
      }).bind(this));


      this.map.addLayer(this.layers[id]);
    }
    else {
      this.layers[id].setVisible(show);
    }

  }

  addShapefileLayer(id: string, bufferOrUrl: ArrayBuffer | string, show: boolean = true) {
    if (this.layers[id] == null) {
      return shapefile.read(bufferOrUrl).then(collection => {
        const vectorSource = new ol.source.Vector({
          features: (new ol.format.GeoJSON()).readFeatures(collection)
        });
        this.layers[id] = new ol.layer.Vector({
          source: vectorSource
        });

        const listenerKey = vectorSource.on('change', (function (e) {
          if (vectorSource.getState() == 'ready') {
            ol.Observable.unByKey(listenerKey);
            this.layers[id].setVisible(show);
          }
        }).bind(this));
        this.map.addLayer(this.layers[id]);
      })
    } else {
      this.layers[id].setVisible(show);
      return Promise.resolve();
    }
  }

  public getBaseLayerName() {
    return this.baseLayerName;
  }

  public getOpacityRange() {
    return this.opacityRange;
  }

  ///// Partie dédiée au suivi de changement ///////
  public addChanges(changesList : Array<Change>, changeTypesList : Array<ChangeType>): any{
    console.log("Ajout des éléménts")
    let featureLayers = new Array();
    for (var i=0;i<8;i++) {
      featureLayers[i] = new Array();
    }
    changesList.forEach(element => {
      let newFeature = this.setFeature(element);
      if (element.change_type<8){
      featureLayers[element.change_type-1].push(newFeature); 
      }
      else{
        featureLayers[7].push(newFeature);
      }     
    });
    // On a complété un tableau de 8 tableaux qui contient les objets pour chaque type de changement.

    var heatMapFeatures = new Array();
    featureLayers.forEach(val => {
      heatMapFeatures = heatMapFeatures.concat(val);
    })
    // Rafraîchir les layers avec nos nouvelles données
    this.map.getLayers().forEach(layer => {
      if (layer.type == "VECTOR"){
        if (layer.get('title') != 'heatMap'){
          layer.getSource().clear();
          var title = layer.get('title');
          var val = Number(title);
          console.log(title)
          layer.getSource().addFeatures(featureLayers[title]);
        }
        else {
          layer.getSource().clear();
          layer.getSource().addFeatures(heatMapFeatures);
        }
      }
    });
    
  };

  public setFeature(change : Change){
    let changeType:number = change.change_type;
    //Choix de la géométrie. On prend the_geom_new sauf s'il est vide, auquel cas the_geom_old ne l'est pas, donc on le sélectionne
    let the_geom = change.the_geom_new;
    if (the_geom == null){
      the_geom = change.the_geom_old;
    }

    var newFeature = (new ol.format.GeoJSON()).readFeature(the_geom);
    newFeature.set('change_type', changeType);

    return newFeature;
  }


  initLayers(){
    var list = [1,2,3,4,5,6,7,8];

    var styleFunction = function(feature, resolution){
      var self = this;
      let style : any;
      var change_type = feature.get('change_type');
      let type = self.config.CHANGES_TYPES.filter(x => x.id=== change_type)[0].type;
      if (feature.getGeometry().getType() == 'Point'){
        style = self.changesPointStyles.get(type);
      } else {
        style = self.changesStyles.get(type);
      }
      return [style];
    }.bind(this);

    for (var i in list){ 
      var newVector = new ol.layer.Vector({
        source: new ol.source.Vector({}),
        zIndex: 10+i,
        title : i,
        style : styleFunction
      });
      this.map.addLayer(newVector);
    }

    /// Initialisation de la HeatMap : basé sur https://stackoverflow.com/questions/56780705/creating-heatmap-in-openlayers-with-vector-source-containing-linestrings
    var vectorHeatMap = new ol.layer.Heatmap({
      source : new ol.source.Vector({}),
      zIndex: 1000,
      title : 'heatMap',
      //minResolution : 100,
      radius : 2,
      blur : 10,
    });
  
  var defaultStyleFunction = vectorHeatMap.getStyleFunction();
  vectorHeatMap.setStyle(function(feature, resolution){
    var style = defaultStyleFunction(feature, resolution);
    var geom = feature.getGeometry();
    var geomType = geom.getType();
    switch(geomType){
      case "Polygon":
        style[0].setGeometry(geom.getInteriorPoint());
        break;
      case "MultiPolygon":
        style[0].setGeometry(geom.getInteriorPoints()[0]);
        break;
      case "LineString":
        style[0].setGeometry(new ol.geom.Point(geom.getCoordinateAt(0.5)));
        break;
      case "MultiLineString":
        let middlePointNumber =  Math.round((geom.getCoordinates().length)/2);
        style[0].setGeometry(new ol.geom.Point(geom.getCoordinates()[middlePointNumber]));
        break;
      case "Point":
        style[0].setGeometry(geom);
        break;   
    }
    return style;
  })
    this.map.addLayer(vectorHeatMap);
  }

  initStyles(){
    for (var type of ["new","modified","deleted","other"]){
      let style=new ol.style.Style();
      let pointstyle = new ol.style.Style(); //because Point styles are differents from other styles... We need an image : a circle here.

      var conf = this.config.STYLE.filter(x => x.type=== type)[0];
      var fill = new ol.style.Fill({color: conf.fillcolor});
      var stroke = new ol.style.Stroke({color: conf.strokecolor, width : 5});
      var pointStroke = new ol.style.Stroke({color: conf.strokecolor, width : 3});

      style.setFill(fill);
      style.setStroke(stroke);
      style.setZIndex(1);
      let circle=new ol.style.Circle({radius:1, stroke: pointStroke, fill:fill});
      pointstyle.setImage(circle);
      this.changesStyles.set(type, style);
      this.changesPointStyles.set(type, pointstyle);
    };
  }

  getLayerByTitle(title){
    var layers = this.map.getLayers().getArray();
    for (var layer of layers) {
      console.log(layer.get('title'));
      if (layer.get('title') == title){
        return layer;
      }
    }
    return null;
  }

}