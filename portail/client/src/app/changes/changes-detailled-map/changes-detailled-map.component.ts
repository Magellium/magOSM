import { Input, Component, AfterViewInit } from '@angular/core';
import { UserContext } from '../../model/UserContext';
import { MapService } from '../../service/map.service';
import { Change } from 'app/model/ChangesClasses/Change';

declare var ol: any;
declare var config: any;

@Component({
  selector: 'app-changes-detailled-map',
  templateUrl: './changes-detailled-map.component.html',
  styleUrls: ['./changes-detailled-map.component.css']
})
export class ChangesDetailledMapComponent {

  @Input() public userContext : UserContext;
  @Input() public mainChange : Change;

  constructor(public mapService: MapService) { }

  // map parameters
  private view: any;
  private map: any;

  ngOnInit() {
    console.log("detailled map user context", this.userContext)
    this.initMap();
  }

  initMap(){
    let center = [this.userContext.lon, this.userContext.lat]
    console.log(center);
    this.view = new ol.View({
      projection: 'EPSG:3857',
      center: ol.proj.transform(center, 'EPSG:4326', 'EPSG:3857'),
      zoom: 14,
      minZoom: 3,
    })

    //Map creation
    this.map = new ol.Map({
      controls: ol.control.defaults({
        attributionOptions: /** @type {olx.control.AttributionOptions} */ ({
          collapsible: false
        })
      }),
      target: 'detailled-map',
      view: this.view,
      layers: [
        new ol.layer.Tile({
        source: new ol.source.OSM(),
        projection : 'EPSG:3857',
        opacity:0.5
        })
      ]
    });

    let layers = this.getVectorLayers();
    console.log(layers);
    layers.forEach(layer => {
      var extent = layer.getSource().getExtent();
      console.log(extent);
      this.map.getView().fit(extent, {size : this.map.getSize(), maxZoom : 19});
      this.map.addLayer(layer);
    })
    console.log(this.map.getLayers());

  }

  public getVectorLayers(): Array<any>{
    let self = this;
    let layers = [];
    if (this.mainChange.theGeomOld != null) {
      var oldFeature = (new ol.format.GeoJSON()).readFeature(this.mainChange.theGeomOld);
      var oldLayer = new ol.layer.Vector({
        source: new ol.source.Vector({features : [oldFeature]}),
        title: "Ancien emplacement",
        style : function(feature,resolution){
          return self.mapService.mainStyleFunction(feature, resolution, false, "deleted");}
        });
      layers.push(oldLayer);
    }
    if (this.mainChange.theGeomNew != null) {
      var newFeature = (new ol.format.GeoJSON()).readFeature(this.mainChange.theGeomNew);
      var newLayer = new ol.layer.Vector({
        source: new ol.source.Vector({features : [newFeature]}),
        title: "Nouvel emplacement",
        style : function(feature,resolution){
          return self.mapService.mainStyleFunction(feature, resolution, false, "new");}
        });
      layers.push(newLayer);
    }
    return layers;
  }

}
