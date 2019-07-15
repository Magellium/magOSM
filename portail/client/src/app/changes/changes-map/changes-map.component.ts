import { Input, Component, OnInit} from '@angular/core';
import { UserContext } from '../../model/UserContext';
import { UserContextService } from '../../service/user-context.service';
import { MapService } from '../../service/map.service';
import { ConfigService } from 'app/service/config.service';
import { ApiRequestService } from 'app/service/api-request.service';
import { ChangeType } from 'app/model/ChangesClasses/ChangeType';
import { e } from '@angular/core/src/render3';

declare var ol: any;
declare var $: any;

@Component({
  selector: 'app-changes-map',
  templateUrl: './changes-map.component.html',
  styleUrls: ['./changes-map.component.css']
})
export class ChangesMapComponent implements OnInit {

  @Input() public change : any;
  @Input('userContext') userContext: UserContext;

  constructor(
    public mapService: MapService,
    public userContextService : UserContextService,
    public configService : ConfigService,
    public apiRequestService : ApiRequestService
) { }

  // map parameters
  private view: any;
  public map: any;
  public layersMap : any;
  public layerswitcherdisplay : boolean = true;

  //
  private changeTypesList : Array<ChangeType>;

  ngOnInit() {
    this.initMap();
  }

  initMap(){
    var mousePositionControl = new ol.control.MousePosition({
      coordinateFormat: function (coords) {
        return ol.coordinate.format(coords, 'Lat : {y}° Lon : {x}° (WGS84)', 4)
      },
      projection: 'EPSG:4326',
      className: 'custom-mouse-position',
      target: document.getElementById('mouse-position'),
      undefinedHTML: '&nbsp;'
    });
    let center: number[]
    if(this.userContext){  
      center = [this.userContext.lon, this.userContext.lat];
    }
    this.view = new ol.View({
      projection: 'EPSG:3857',
      center: center?ol.proj.transform(center, 'EPSG:4326', 'EPSG:3857'):null,
      zoom: this.userContext.z,
      //minZoom: 6,
    })
    
    //Map creation
    this.map = new ol.Map({
      controls: ol.control.defaults({
        attributionOptions: /** @type {olx.control.AttributionOptions} */ ({
          collapsible: false
        })
      }).extend([
        mousePositionControl,
        new ol.control.ScaleLine(),
      ]),
      target: 'map',
      view: this.view,
    });

    this.mapService.setMap(this.map, this.userContext);

    this.apiRequestService.searchChangeTypes().subscribe(data => {
      this.changeTypesList = JSON.parse(data['_body']);
      this.changeTypesList.sort((a,b) => a.id - b.id);
      console.log(this.changeTypesList);
      this.mapService.initLayers(this.changeTypesList);
      this.mapService.initStyles();
      console.log(this.mapService.changesStyles);
      console.log(this.mapService.changesPointStyles);
      this.layersMap = this.mapService.changesLayer;
      console.log(this.layersMap);
    });


    //// Pour ajouter de la surbrillance au passage de la souris. Ralentit beaucoup lorsqu'il y a beaucoup d'objets. 

    // var highlightStyle = new ol.style.Style({
    //   stroke: new ol.style.Stroke({
    //     color: [0,0,0,0.6],
    //     width: 15
    //   }),
    //   fill: new ol.style.Fill({
    //     color: [0,0,0,0.2]
    //   }),
    //   zIndex: 1
    // });
    // var selectPointerMove = new ol.interaction.Select({
    //   condition: ol.events.condition.pointerMove,
    //   style : highlightStyle,
    //   hitTolerance : 2
    // });
    // this.map.addInteraction(selectPointerMove);

    var self = this;
    this.map.on('pointermove', function(e) {
      var layerfilter = function(layer){
        return layer.get('title')!="heatMap"
      };
      if (e.dragging) return; // si il y a déplacement de la carte, on arrête
       
      var pixel = self.map.getEventPixel(e.originalEvent);
      var hit = self.map.hasFeatureAtPixel(pixel, {hitTolerance:2, layerFilter: layerfilter}); // on vérifie si il y a un objet à l'endroit de l'événement
       
      self.map.getTargetElement().style.cursor = hit ? 'pointer' : ''; // si besoin, on change le curseur
    });

    // this.map.on('click', function(event){
    //   if (event.dragging) return;

    //   var pixel = self.map.getEventPixel(event.originalEvent);
    //   var hit = self.map.hasFeatureAtPixel(pixel, {hitTolerance:2})
    //     })
  }

  onSelect($event,changeType : ChangeType){
    var layer = this.mapService.changesLayer.get(changeType);
    var isVisible = layer.getVisible();
    layer.setVisible(!isVisible);
  }

}
