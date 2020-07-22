import { Injectable, Output, EventEmitter } from '@angular/core';
import { UserContext } from '../model/UserContext';

import * as shapefile from 'shapefile'
import { Change } from 'app/model/ChangesClasses/Change';
import { ChangeType } from 'app/model/ChangesClasses/ChangeType';
import { ConfigService } from './config.service';
import { a } from '@angular/core/src/render3';
import { Color } from 'app/model/ChangesClasses/Color';
import { environment } from '../../environments/environment';
import { LayerAndCategory } from 'app/model/LayerAndCategory';
import { Layer } from 'app/model/Layer';

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
  public changesLayer = new Map();
  public numberOfChangeByType = new Map<ChangeType,number>();
  public legendDisplay : boolean = false;
  public changesLayersArray : Array<any> = [];
  public changesLayersCollection ;
  public changesLayersGroup = new ol.layer.Group({});
  public heatMapLayer = new ol.layer.Heatmap({});
  public changeTypeArrayList : Array<ChangeType>;
  private mapFeatureSelectedInteractionOnClick : any;
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

  getCategorieAndLayerByStringAttribute(attributeName: string, attributeValue: String):LayerAndCategory {
    let _layer: Layer;
    let _categorie: string;
    this.config.LAYERS.forEach(function (categorie) {
      if (categorie.features.filter(y => y[attributeName].indexOf(attributeValue) >= 0)[0]) {
        _categorie = categorie.id_categorie;
        _layer = categorie.features.filter(y => y[attributeName].indexOf(attributeValue) >= 0)[0];
      }
    })
    const _result = new LayerAndCategory(_categorie, _layer);
    console.log('getCategorieAndLayerByStringAttribute')
    console.log(_result)
    return _result;
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
        url: environment.geoserver_baseurl + '/wms?',
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
      // first, set WMTS options from capabilities
      var options = ol.source.WMTS.optionsFromCapabilities(this.wmtsResult, {
        layer: layername,
        matrixSet: matrixSet
      });
      // then rewrite some opts
      options.urls[0] = environment.geoserver_baseurl + "/gwc/service/wmts?'";
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

    let url = environment.geoserver_baseurl + "/wms?service=wms&request=GetMap&version=1.1.1&format=application/vnd.google-earth.kml+xml&layers=" + layer.layername /*+ "&styles=" + layer.selectedStyle.style*/ + "&height=2048&width=2048&transparent=false&srs=EPSG:3857&format_options=AUTOFIT:true;KMATTR:true;KMPLACEMARK:false;KMSCORE:40;MODE:download;SUPEROVERLAY:false&bbox=" + bbox;
    //let url = environment.geoserver_baseurl + "/wfs?request=GetFeature&version=2.0.0&count=50000&outputFormat=application%2Fvnd.google-earth.kml%2Bxml&typeName="+layer.layername;
    //let url = environment.geoserver_baseurl + "/wms/kml?layers="+layer.layername;

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

    //let url = environment.geoserver_baseurl + "/wms?service=wms&request=GetMap&version=1.1.1&format=application/vnd.google-earth.kml+xml&layers=" + layer.layername /*+ "&styles=" + layer.selectedStyle.style*/ + "&height=2048&width=2048&transparent=false&srs=EPSG:3857&format_options=AUTOFIT:true;KMATTR:true;KMPLACEMARK:false;KMSCORE:40;MODE:download;SUPEROVERLAY:false&bbox=" + bbox;
    let url = environment.geoserver_baseurl + "/wfs?request=GetFeature&version=2.0.0&count=500000&outputFormat=shape-zip&typeName=" + layer.layername + "&srsName=EPSG:3857&bbox=" + bbox;
    //let url = environment.geoserver_baseurl + "/wms/kml?layers="+layer.layername;

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

  ////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  ///// Partie dédiée au suivi de changement /////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////

  public addChanges(changesList : Array<Change>): any{
    let featureLayers = new Map();
    let alreadyTested = new Array<number>();
    this.changesLayersArray.forEach(layer => {
        featureLayers.set(layer.get('id'), []);
    });
    changesList.forEach(element => {
      let osmId = element.osmId;
      if (alreadyTested.indexOf(osmId) < 0){
        let featuresWithSameOsmId = changesList.filter(x => x.osmId === osmId);
        if (featuresWithSameOsmId.length > 1){
          element = this.getChangesMergeForOneFeature(featuresWithSameOsmId);
        }
        let newFeature = this.setFeature(element);
        let changeListByType=featureLayers.get(element.changeType);
        if(!changeListByType){
          console.error(element.changeType+ " not found in list.voir element suivant:");
          console.log(element);
        }else{
          changeListByType.push(newFeature);
        }
        
        alreadyTested.push(osmId); 
      } 
    });
    // On a complété un Map de 8 tableaux qui contiennent chacun les objets pour chaque type de changement.
    this.numberOfChangeByType = new Map<ChangeType,number>();
    this.changesLayersArray.forEach(layer => {
        let id = layer.get('id');
        layer.getSource().clear();
        layer.getSource().addFeatures(featureLayers.get(id));
        this.numberOfChangeByType.set(layer.get('changetype'), featureLayers.get(id).length);
    });
    this.refreshHeatMap();
  };

  public refreshHeatMap(){
    let features : Array<any> = new Array<any>();
    this.changesLayersArray.forEach(layer => {
      if (layer.getVisible()){
        features = features.concat(layer.getSource().getFeatures());
      }
    });
    this.heatMapLayer.getSource().clear();
    this.heatMapLayer.getSource().refresh();
    this.heatMapLayer.getSource().addFeatures(features);
    if (features.length < 50){
      this.changesLayersGroup.setMaxResolution(10000);
    }
    else{
      this.changesLayersGroup.setMaxResolution(this.map.getView().getResolutionForZoom(10));
    }
  }

  public setFeature(change : Change){
    let changeType:number = change.changeType;
    //Choix de la géométrie. On prend theGeomNew sauf s'il est vide, auquel cas theGeomOld ne l'est pas, donc on le sélectionne
    let the_geom = change.theGeomNew;
    if (the_geom == null){
      the_geom = change.theGeomOld;
    }

    var newFeature = (new ol.format.GeoJSON()).readFeature(the_geom);
    // var geom =newFeature.getGeometry()
    // newFeature.setGeometry(geom.simplify(5));
    newFeature.set('changeType', changeType);
    newFeature.set('osmId', change.osmId);
    newFeature.set('geom_type', change.type);

    return newFeature;
  }


  initLayers(changeTypesList : Array<ChangeType>){
    this.changesLayersArray = new Array<any>();
    this.changeTypeArrayList = changeTypesList;
      //On crée un Array contenant les layers que l'on place dans un LayerGroup que l'on associe à la map.
    changeTypesList.forEach(element => {
      var newVector = new ol.layer.Vector({
        source: new ol.source.Vector({attributions: [
          new ol.Attribution({
            html: '' +
                '<a href="http://magosm.magellium.com/">© Magellium pour les changements</a>'
          })
        ]
        }),
        zIndex: 10+element.id,
        id : element.id,
        title : element.name,
        changetype : element,
        style : this.mainStyleFunction.bind(this),
      });
      this.changesLayersArray.push(newVector);
    })
    this.changesLayersGroup = new ol.layer.Group({
      layers:this.changesLayersArray,
      maxResolution : this.map.getView().getResolutionForZoom(10)
    });
    this.map.addLayer(this.changesLayersGroup);
  }

  initHeatMap(){
    /// Initialisation de la HeatMap : basé sur https://stackoverflow.com/questions/56780705/creating-heatmap-in-openlayers-with-vector-source-containing-linestrings
    this.heatMapLayer = new ol.layer.Heatmap({
      source : new ol.source.Vector({attributions: [
        new ol.Attribution({
          html: '' +
              '<a href="http://magosm.magellium.com/">© Magellium pour les changements</a>'
          })
        ]
      }),
      zIndex: 2,
      title : 'Carte de chaleur',
      minResolution : this.map.getView().getResolutionForZoom(12),
      radius : 2,
      blur : 10,
    });

  var defaultStyleFunction = this.heatMapLayer.getStyleFunction();
  this.heatMapLayer.setStyle(function(feature, resolution){
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
        style[0].setGeometry(new ol.geom.Point(geom.getCoordinates()[middlePointNumber][0]));
        break;
      case "Point":
        style[0].setGeometry(geom);
        break;   
    }
    return style;
  })
    //this.changesLayer.set("Carte de chaleur", this.heatMapLayer);
    this.map.addLayer(this.heatMapLayer);
  }

  public initInteractions(){
    var self = this;
    this.mapFeatureSelectedInteractionOnClick = new ol.interaction.Select({
      condition: ol.events.condition.click,
      style : function(feature,resolution){
        return self.mainStyleFunction(feature, resolution, true);},
      hitTolerance : 2,
      filter: function(feature, layer){return self.heatMapFilter (layer);},
    })
    this.map.addInteraction(this.mapFeatureSelectedInteractionOnClick);
  }

  public clearSelection(){
    this.mapFeatureSelectedInteractionOnClick.getFeatures().clear();
  }

  public addFeatureToSelection(feature){
    this.clearSelection();
    this.mapFeatureSelectedInteractionOnClick.getFeatures().push(feature);
  }

  public getChangesMergeForOneFeature(changes : Array<Change>): Change{
    let changesOrderByTimestamp = changes.sort(function(a,b){ return a.timestamp == b.timestamp ? 0 : +(a.timestamp > b.timestamp) || -1; })
    while (changesOrderByTimestamp.length > 1){
      let change1 = changesOrderByTimestamp.pop();
      let change2 = changesOrderByTimestamp.pop();
      changesOrderByTimestamp.push(this.mergeTwoChanges(change1, change2));
    }
    return changesOrderByTimestamp[0];

  }

  public mergeTwoChanges(change1 : Change, change2 : Change): Change{
    let firstChange : Change;
    let secondChange : Change;
    let newChange : Change = new Change();
    if (change1.timestamp < change2.timestamp){
      firstChange = change1;
      secondChange = change2;
    } else {
      firstChange = change2;
      secondChange = change1;
    }
    newChange.timestamp = secondChange.timestamp;
    newChange.osmId=firstChange.osmId;
    newChange.type= firstChange.type;
    newChange.versionOld = firstChange.versionOld;
    newChange.versionNew = secondChange.versionNew;
    newChange.tagsOld = firstChange.tagsOld;
    newChange.tagsNew = secondChange.tagsNew;
    newChange.theGeomOld = firstChange.theGeomOld;
    newChange.theGeomNew = secondChange.theGeomNew; // Attention, dans ce cas, si on a une Création puis une Suppression, on n'a aucune géométrie !
    switch(firstChange.changeType){
      case 1:
        if ([5,6].indexOf(secondChange.changeType)> -1 ){
          newChange.changeType = 7;
          newChange.theGeomNew = secondChange.theGeomOld; // C'est pourquoi on rattrape le tout ici
          newChange.tagsNew = secondChange.tagsOld;
          newChange.versionNew = secondChange.versionOld;
        } else {
          newChange.changeType = 1;
        }
        break;
      case 2: 
        if ([5,6].indexOf(secondChange.changeType)> -1 ){
          newChange.changeType = 7;
        } else {
          newChange.changeType = 2;
        } 
        break;
      case 3:
        newChange.changeType = 3;
        if ([34,5,6].indexOf(secondChange.changeType)> -1){
          newChange.changeType = secondChange.changeType;
        }
        if (secondChange.changeType == 4){
          newChange.changeType = 34;
        }
        break;
      case 4:
        newChange.changeType = 34;
        if ([4,5,6].indexOf(secondChange.changeType)> -1){
          newChange.changeType = secondChange.changeType;
        }
        break;
      case 34:
        newChange.changeType=34;
        if ([5,6].indexOf(secondChange.changeType)>-1){
          newChange.changeType = secondChange.changeType;
        }
        break;
      case 5:
        newChange.changeType = 7;
        break;
      case 6:
        break;
      case 7:
        newChange.changeType = secondChange.changeType;   
    }
    // if (newChange.theGeomNew == null && newChange.theGeomOld == null){
    //   console.log(newChange.osmId);
    // }
    return newChange;
  }

  //Cela permet de réutiliser l'affichage lors du passage de la souris ou de la sélection :
  //Voir : https://stackoverflow.com/questions/35184546/openlayers3-same-style-for-selected-features-only-one-changed-property
  public mainStyleFunction(feature, resolution : number, selected : boolean, changeTypeId? : number, small? : boolean ){
    let maxResol = this.map.getView().getResolutionForZoom(10);
    let style = new ol.style.Style({});

    //Récupérer la conf pour les couleurs
    var changeType = changeTypeId ? changeTypeId : feature.get('changeType');
    let color : Color = this.changeTypeArrayList.filter(x => x.id === changeType)[0].color;
    let fillcolor = [color.R, color.G, color.B, 0.2];
    let strokecolor = [color.R, color.G, color.B, 1];


    var fill = new ol.style.Fill({color: fillcolor});
    style.setZIndex(1);
    if (small || resolution < this.changesLayersGroup.getMaxResolution()){    
      if (feature.getGeometry().getType() == 'Point'){
        var pointStroke = new ol.style.Stroke({color: strokecolor, width : selected ? 10 : 3});
        let circle=new ol.style.Circle({radius:1, stroke: pointStroke, fill:fill});
        style.setImage(circle);

        if (resolution<10){
          style.getImage().setRadius(small ? 2*(1+1/resolution) : 4*(1+1/resolution));
        }
        else{
          style.getImage().setRadius(1);
        }
      } 
      else {
        var stroke = new ol.style.Stroke({color: strokecolor, width : selected ? 10 : 5});
        style.setFill(fill);
        style.setStroke(stroke);
    }
      // if (selected){
      //   style.setMaxResolution(this.map.getView().getResolutionForZoom(10));
      // }
    }
    return [style];
  }

  public heatMapFilter(layer){
    return layer.get('title')!="Carte de chaleur";
  }

  public getOsmTypeOfFeature(osmId : number, geometryType : string){
    switch(geometryType){
      case 'Point':
        return 'node';
        break;
      case 'Line':
      case 'Polygon':
        if (osmId>0){
          return 'way';
        } else {
          return 'relation'
        }
        break;
    }
  }

}