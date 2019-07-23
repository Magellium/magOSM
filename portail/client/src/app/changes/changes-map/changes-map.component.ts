import { Input, Component, OnInit} from '@angular/core';
import { UserContext } from '../../model/UserContext';
import { UserContextService } from '../../service/user-context.service';
import { MapService } from '../../service/map.service';
import { ConfigService } from 'app/service/config.service';
import { ApiRequestService } from 'app/service/api-request.service';
import { ChangeType } from 'app/model/ChangesClasses/ChangeType';

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
) {   
  $("#selectAll").click(function(){
    console.log("coucou");
    $("input[type=checkbox]").prop('checked', $(this).prop('checked'));
  }); 
}

  // map parameters
  private view: any;
  public map: any;
  public layersArray : any;
  public layerswitcherdisplay : boolean = true;

  //
  private changeTypesList : Array<ChangeType>;
  public selectedFeature : any;

  ngOnInit() {
    this.initMap();
  }

  initMap(){
    var mousePositionControl = new ol.control.MousePosition({
      coordinateFormat: function (coords) {
        return ol.coordinate.format(coords, 'Lat : {y}° Lon : {x}° (WGS84)', 4)
      },
      projection: 'EPSG:4326',
      className: 'custom-mouse-position-2',
      target: document.getElementById('mouse-position-2'),
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
      this.mapService.initHeatMap();
      this.layersArray = this.mapService.changesLayersArray;
      console.log(this.layersArray);
    });


    //// Pour ajouter de la surbrillance au passage de la souris et au clic sur un objet

    var self = this;
    // var selectPointerMove = new ol.interaction.Select({
    //   condition: ol.events.condition.pointerMove,
    //   style : function(feature,resolution){
    //     return self.mapService.mainStyleFunction(feature, resolution, true);},
    //   hitTolerance : 2,
    //   filter: function(feature, layer){return self.heatMapFilter (layer);}
    // })
    // this.map.addInteraction(selectPointerMove);
    
    var selectFeatureClick = new ol.interaction.Select({
      condition: ol.events.condition.click,
      style : function(feature,resolution){
        return self.mapService.mainStyleFunction(feature, resolution, true);},
      hitTolerance : 2,
      filter: function(feature, layer){return self.heatMapFilter (layer);}
    })
    this.map.addInteraction(selectFeatureClick);

    // Au passage de la souris, change le curseur
    this.map.on('pointermove', this.onPointerMove.bind(this));
    // Au clic sur un objet
    this.map.on('click', this.onClick.bind(this));
      
  }


  public onPointerMove(e){
    if (e.dragging) return; // si il y a déplacement de la carte, on arrête
       
      var pixel = this.map.getEventPixel(e.originalEvent);
      var hit = this.map.hasFeatureAtPixel(pixel, {hitTolerance:2, layerFilter: this.heatMapFilter}); // on vérifie si il y a un objet à l'endroit de l'événement
       
      this.map.getTargetElement().style.cursor = hit ? 'pointer' : ''; // si besoin, on change le curseur

  }

  public onClick(event){
      this.selectedFeature = null;
      var pixel = this.map.getEventPixel(event.originalEvent);
      var hit = this.map.hasFeatureAtPixel(pixel, {hitTolerance:2, layerFilter : this.heatMapFilter});
      if (hit){
        this.selectedFeature = this.map.getFeaturesAtPixel(pixel, {hitTolerance:2})[0];
      }
  }

  public heatMapFilter(layer){
    return layer.get('title')!="Carte de chaleur";
  }

  public onSelect($event, id){
    if (id != "heatMap"){
    var layer = this.mapService.changesLayersArray.filter(x => x.get('id') === id)[0];
    var isVisible = layer.getVisible();
    layer.setVisible(!isVisible);
    this.mapService.refreshHeatMap();
    } else {
      var isVisible = this.mapService.heatMapLayer.getVisible();
      this.mapService.heatMapLayer.setVisible(!isVisible);
    }
  }

  // public onSelectAll(source){
  //   console.log(source.checked);
  //   let checkboxes = document.getElementsByName("layer") as NodeListOf<HTMLInputElement>;
  //   checkboxes.forEach(checkbox => {
  //     checkbox.checked = source.checked;
  //   })
  // }

}
