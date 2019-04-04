import { Injectable, Output, EventEmitter } from '@angular/core';
import { UserContext } from '../model/UserContext';

import * as shapefile from 'shapefile'

declare var ol: any;
declare var _paq: any;
declare var window: any;
declare var config: any;
declare var fetch: any;

@Injectable()
export class MapService {

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
  @Output() announceOpacityChangeEvent: EventEmitter<any> = new EventEmitter();
  //legende
  public legendUrls: string[];//au niveau infra-communal il y a autant d'urls de légendes que de couches visibles
  public legendSubTitles: string[];
  public legendTitle: string;
  public currentScale: any;

  wmtsResult: any;


  constructor() { }

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
    console.log(id);
    let layername = layerconfig.layername;
    if (this.layers[id] == null) {

      var layerSource = new ol.source.TileWMS(({
        url: config.PARAMS[0].geoserver_baseurl + '/wms?',
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

    let url = config.PARAMS[0].geoserver_baseurl + "/wms?service=wms&request=GetMap&version=1.1.1&format=application/vnd.google-earth.kml+xml&layers=" + layer.layername /*+ "&styles=" + layer.selectedStyle.style*/ + "&height=2048&width=2048&transparent=false&srs=EPSG:3857&format_options=AUTOFIT:true;KMATTR:true;KMPLACEMARK:false;KMSCORE:40;MODE:download;SUPEROVERLAY:false&bbox=" + bbox;
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
    let url = config.PARAMS[0].geoserver_baseurl + "/wfs?request=GetFeature&version=2.0.0&count=500000&outputFormat=shape-zip&typeName=" + layer.layername + "&srsName=EPSG:3857&bbox=" + bbox;
    //let url = config.PARAMS[0].geoserver_baseurl + "/wms/kml?layers="+layer.layername;

    //piwik
    _paq.push(['trackEvent', 'SHP_download', layer.layername])

    window.open(url, "_blank");
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

  getZoomFromScale(scale) {
    var resolution = this.getResolutionFromScale(scale, this.map.getView().getProjection().getUnits());
    var zoom = Math.ceil(this.map.getView().getZoomForResolution(resolution)); // Zoom level rounded up
    return zoom;
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

}
