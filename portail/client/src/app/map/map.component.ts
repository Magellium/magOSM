import { Component, OnInit, Input, Output, EventEmitter, ViewChild } from '@angular/core';
import { Layer } from '../model/Layer';
import { HttpClient,HttpParams } from '@angular/common/http';
import { LegendComponent } from '../map-panel-switcher-components/legend/legend.component';
import { ApiAdresseComponent } from '../apiadresse/apiadresse.component';
import { Router } from '@angular/router';
import { MapService } from '../service/map.service';
import { LayerChangeService } from '../service/layer-change.service';
import { UserContext } from '../model/UserContext';
import { environment } from '../../environments/environment';
import { LayerAndCategory } from 'app/model/LayerAndCategory';

declare var proj4: any;
declare var $: any;
declare var ol: any;
declare var config: any;
declare var _paq: any;

const isUrl = function (str: string) {
    // If str is not a valid URL, "new URL(str)" throw an exception.
    try {
    const url = new URL(str);
    return true;
  } catch (error){
    return false;
  } 
}

const getUrlFromDataTransfer = function (dataTransfer: DataTransfer) {
  if (dataTransfer.types.indexOf('text/uri-list') !== -1) {
    return dataTransfer.getData('URL');
  } else if (
    dataTransfer.types.indexOf('text/plain') !== -1
    && isUrl(dataTransfer.getData('text/plain'))
  ) {
    return dataTransfer.getData('text/plain');
  } else {
    return undefined;
  } 
} 

@Component({
  selector: 'app-map',
  templateUrl: './map.component.html',
  styleUrls: ['./map.component.css'],
})

export class MapComponent implements OnInit {

  //Pour utiliser la variable config dans le html
  config = config;

  @Input('userContext') userContext: UserContext;

  //commenter les bonnes lignes dans le fichier de config selon qu'on est en local ou en intégration
  private geoserver_baseurl = environment.geoserver_baseurl;

  //paramètres map
  private map: any;
  private closeResult: string;
  private currentLayer: any;
  private view: any;
  //layers et sources à l'échelle infra-communale

  //liste des layers visibles au niveau infra-communal
  private visibleLayers: any
  private id_layers: string;
  private id_legends: string[];
  //variable qui va récupérer l'indicateur sélectionné via le Menu
  selectedLayer: Layer;
  //variables utilisées pour afficher en surcouche le feature sélectionné par l'utilisateur
  public selectedFeature: any;
  //Constantes utiles pour calculer l'échelle à partir de la résolution
  private gridset = config.GRIDSET;
  private INCHES_PER_UNIT = { 'm': 39.37, 'dd': 4374754 };
  private DOTS_PER_INCH = 72;
  //Variables utiles au chargement de la légende selon le niveau de zoom
  private currentResolution: any;
  private currentScale: any;
  private updatedScale: any;

  //Variables utiles au composant de géolocalisation
  @ViewChild(ApiAdresseComponent) public apiadresse: ApiAdresseComponent;

  constructor(
    public mapService: MapService,
    private http: HttpClient,
    public router: Router,
    public layerChangeService: LayerChangeService
  ) {
    this.layerChangeService.getAnnounceLayerChangeEventEmitter().subscribe(
      newSelectedLayer => {
        //console.log(newSelectedLayer)
        this.selectedLayer = newSelectedLayer;
      }
    );
  }

  ngOnInit() {
    this.initMap();
  }

  ngAfterViewInit() {
  }

  initMap() {
    //proj4.defs(MainmapComponent.PROJECTION_CODE, "+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m   +no_defs");


    var mousePositionControl = new ol.control.MousePosition({
      coordinateFormat: function (coords) {
        return ol.coordinate.format(coords, 'Lat : {y}° Lon : {x}° (WGS84)', 4)
      },
      projection: 'EPSG:4326',
      className: 'custom-mouse-position',
      target: document.getElementById('mouse-position'),
      undefinedHTML: '&nbsp;'
    });

    let center: number[] = [this.userContext.lon, this.userContext.lat];
    this.view = new ol.View({
      projection: config.PROJECTION_CODE,
      center: ol.proj.transform(center, 'EPSG:4326', config.PROJECTION_CODE),
      zoom: this.userContext.z,
      minZoom: 3//,
      //maxZoom: 18
    })

    //création de la map
    this.map = new ol.Map({
      controls: ol.control.defaults({
        attributionOptions: /** @type {olx.control.AttributionOptions} */ ({
          collapsible: false
        })
      }).extend([
        mousePositionControl,
        new ol.control.ScaleLine()
      ]),
      target: 'map',
      view: this.view
    });
    this.mapService.setMap(this.map, this.userContext);

    this.mapService.addSelectionLayer();

    this.map.on('click', this.onClick.bind(this));
    this.map.on('moveend', this.onZoom.bind(this)); 


    this.mapService.addLayer('world', 'assets/data/countries_ecem.geojson');
    var parser = new ol.format.WMTSCapabilities();
    let self = this;
    this.http.get(environment.geoserver_baseurl + '/gwc/service/wmts?REQUEST=GetCapabilities', {responseType: 'text'})
    .subscribe(
      
      data => {
        console.log(data);
        self.mapService.setWMTSResult(parser.read(data));
        self.initLayersFromConfig();
      },
      error => {
        console.log(error);
      });



    this.currentResolution = this.view.getResolution();
    this.currentScale = this.mapService.getScaleFromResolution(this.view.getResolution(), this.map.getView().getProjection().getUnits(), true);
    this.updateScale();
    this.updateZoomLevel();
  }

  initLayersFromConfig() {
    let layers = config.LAYERS;
    for (var i = layers.length - 1; i >= 0; i--) {
      var categorie = layers[i];
      for (var j = categorie.features.length - 1; j >= 0; j--) {
        //console.log(categorie.features[j]);
        categorie.features[j].opacity = 100;
        if (categorie.features[j].type == "WMS") {
          this.mapService.addWMSLayer(categorie.features[j], false);
        }
        else if (categorie.features[j].type == "WMTS") {
          this.mapService.addWMTSLayer(categorie.features[j], false);
        }
        else if (categorie.features[j].type == "VectorTile") {
          this.mapService.addVectorTileLayer(categorie.features[j], false);
        }
      }
    }
    
  }

  onZoom(event) {
    this.currentScale = this.mapService.getScaleFromResolution(this.view.getResolution(), this.map.getView().getProjection().getUnits(), true);
    this.updateScale();
    this.updateZoomLevel();
    this.computeSingleLegend();
  }

  updateScale() {
    let scale = parseInt(this.currentScale);
    let strScale = scale.toString().replace(/\B(?=(\d{3})+(?!\d))/g, " ");
    document.getElementById('map-scale').innerHTML = 'Echelle : 1/' + strScale + '    ';
  }

  updateZoomLevel(){
    let zoom = this.map.getView().getZoom();
    //console.log(zoom)
    document.getElementById('map-zoom-level').innerHTML = '<center>' + Math.round(zoom) +'</center>';
  }


  updateState(newSelectedLayer) {//fonction appelée lorsque l'utilisateur choisi un nouvel indicateur

    try { //on ajoute l'aggrégation de couche correspondant à l'indicateur
      this.selectedLayer = newSelectedLayer;
      console.log("this.selectedLayer : " + this.selectedLayer);
      var layer = this.mapService.getLayersById(this.selectedLayer.layername);
      this.currentLayer = layer;
      if (newSelectedLayer.maxScaleDenominator) {
        if (this.mapService.getScale() > newSelectedLayer.maxScaleDenominator && !layer.getVisible()) {
          var minZoom = this.mapService.getZoomFromScale(newSelectedLayer.maxScaleDenominator);
          alert("Impossible d'afficher la couche à ce niveau.\nZoomez jusqu'au niveau " + minZoom + " (échelle du 1/" + newSelectedLayer.maxScaleDenominator +"ème) pour voir la couche.")
        }
      }
      layer.setVisible(!layer.getVisible());

      if (this.selectedFeature) { //on réinitialise selectedFeature
        console.log("this.selectedFeature")
        this.mapService.cleanSelection();

        this.selectedFeature = null;
      }
    } catch (e) {
      console.log(e);
    }



    try {
      this.mapService.legendTitle = newSelectedLayer.nom_court;

      this.computeSingleLegend();

    } catch (e) {
      console.log(e);
    }
  }

  onClick(event) {
    var viewResolution = /** @type {number} */ (this.view.getResolution());

    if (this.selectedLayer) {
      this.visibleLayers = [this.currentLayer];
      this.id_layers = this.selectedLayer.layername;
      this.printSelectedFeatureOnMap(
        this.visibleLayers, this.id_layers, viewResolution, event
      );
    }
  }

  setVisibleLayersAndLegends(): boolean { //tient à jour les infos sur les layers visibles et les légendes à afficher
    console.log("setVisibleLayersAndLegends");
    this.visibleLayers = [];
    this.id_layers = '';
    this.id_legends = [];
    this.mapService.legendSubTitles = [];
    let array_id_layers = [];

    this.id_layers = array_id_layers.join(',');
    console.log(this.id_legends);
    return true;
  };

  printSelectedFeatureOnMap(visibleLayers, id_layers, viewResolution, event) {
    id_layers = this.mapService.getVisibleLayersIdList();
    var url = new ol.source.TileWMS(({
      url: this.geoserver_baseurl + "/wms?",
      crossOrigin: 'anonymous',
      params: ({ 'LAYERS': id_layers })
    })).getGetFeatureInfoUrl(
      event.coordinate, viewResolution, 'EPSG:3857',
      { 'INFO_FORMAT': 'text/xml', 'QUERY_LAYERS': id_layers, 'BUFFER': '10', 'FEATURE_COUNT': '10' }
      );

    if (this.currentScale) {
      this.http.get(url, {responseType: 'text'})
        .subscribe((function (response) { // this is the standard way to read the features
          var allFeatures = new ol.format.WMSGetFeatureInfo().readFeatures(response);
          if (this.selectedFeature) { //on réinitialise vectorSource
            this.mapService.cleanSelection();
            this.selectedFeature = null;
          }
          if (allFeatures.length >= 1) { //si on clique sur 1 seul objet
            this.selectFeatures(allFeatures);
          }

        }).bind(this));
    }
  }



  selectFeatures(allFeatures) { //récupère un feature dans une liste de features
    this.selectedFeature = allFeatures; //ajoute le feature en surcouche à la carte
    this.mapService.addToSelection(this.selectedFeature[0]);


    if (this.selectedFeature[0].getKeys().indexOf("osm_original_geom") >= 0) {
      let wkt_geom = this.selectedFeature[0].get("osm_original_geom");

        var format = new ol.format.WKT();
        
        var feature = format.readFeature(wkt_geom.split(';')[1], {
          dataProjection: 'EPSG:3857',
          featureProjection: 'EPSG:3857'
        });
        this.mapService.addToSelection(feature);
    }


    console.log(this.selectedFeature);
  }

  zoomTo(location, zoomlevel) {
    this.map.getView().setCenter(ol.proj.transform(location, 'EPSG:4326', config.PROJECTION_CODE), 16);
    this.map.getView().setZoom(zoomlevel);
  }



  hideLayer(layer, layerName) {
    if ((<HTMLInputElement>document.getElementById(layerName)).checked) {
      layer.setVisible(true);
    }
    else {
      layer.setVisible(false);
    }
  }

  computeSingleLegend() {
    let ids = this.mapService.getVisibleLayersIdArrayList();
    this.mapService.legendUrls = [];
    this.mapService.legendSubTitles = [];
    for (var i = 0; i < ids.length; i++) {
     
      if(this.mapService.isInRange(ids[i])){
        let _layerAndCategory: LayerAndCategory = this.mapService.getCategorieAndLayerByStringAttribute("layername", ids[i]);
        this.mapService.legendSubTitles.push(_layerAndCategory.layer.nom_court);
        this.mapService.legendUrls.push(this.geoserver_baseurl + '/wms?LAYER=' + ids[i] + '&SERVICE=WMS&VERSION=1.3.0&STRICT=false&REQUEST=GetLegendGraphic&FORMAT=image%2Fpng&TRANSPARENT=true&SCALE=' + this.currentScale);
      }
       }
    // this.legendUrls = [];
    console.log(this.mapService.legendUrls);
  }



  onCitySelected(city) {

    if (city.geometry) {
      // on calcule le zoom pour l'adapter au résultat de la recherche en fonction du type d'objet trouvé :
      // type : (housenumber | street  | locality | municipality)
      var zoomlevel = 14;
      var type = city.properties.type;
      if (type == 'housenumber') {
        zoomlevel = 19;
      } else if (type == 'street') {
        zoomlevel = 16;
      } else if (type == 'locality') {
        zoomlevel = 16;
      } else if (type == 'municipality') {
        zoomlevel = 14;
      };
      // On fait le zoom
      this.zoomTo(city.geometry.coordinates, zoomlevel);
    }
  }

  addShapefileLayerInConfig({layername, nom_court, type}) {
    const layer = {
      layername,
      nom_court,
      type,
      'download_kml': false,
      'download_shp': false
    };
    const idForCustomSourcesCategory = 4;
    const customSourcesCategory = config.LAYERS.find(
      category => (category.id_categorie === idForCustomSourcesCategory)
    );
    customSourcesCategory.features.push(layer);
  }

  onDrop(event) {
    event.preventDefault();
    const url = getUrlFromDataTransfer(event.dataTransfer)
    if (url !== undefined) {
      const id = `shapefile:url:[${url}]`;
      this.mapService.addShapefileLayer(id, url)
      .then(() => {
        this.addShapefileLayerInConfig({
          'layername': id,
          'nom_court': url,
          'type': 'ShapeFileUrl'
        });
        _paq.push(['trackEvent', `layer_list`, 'add_shapefile_url'])
      }).catch(error => {
        alert("Le fichier ne semble pas être au format ShapeFile.");
      });
    } else if (event.dataTransfer.files.length > 0) {
      const file: File = event.dataTransfer.files[0];
      const reader = new FileReader();
      reader.onload = e => {
        const buffer = e.target.result as ArrayBuffer;
        // TODO id collision if several shapefiles have the same name. Use a hash
        // on the arraybuffer? For now, only use a random number to mitigeate
        // collision.
        const pseudoUniqueId = Math.floor(Math.random()*1000000000000);
        const id = `shapefile:buffer:${file.name}:${pseudoUniqueId}`;
        this.mapService.addShapefileLayer(id, buffer)
        .then(() => {
          this.addShapefileLayerInConfig({
              'layername': id,
              'nom_court': file.name,
              'type': 'ShapeFileBuffer'
          });
          _paq.push(['trackEvent', `layer_list`, 'add_local_shapefile', file.size])
        }).catch(error => {
          alert("Le fichier ne semble pas être au format ShapeFile.");
        });
      }
      reader.readAsArrayBuffer(file);  
    }
  }

  onDragOver(event) {
    event.stopPropagation();
    event.preventDefault();
  }

}
