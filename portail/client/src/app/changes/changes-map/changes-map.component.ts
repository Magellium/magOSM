import { Input, Component, OnInit} from '@angular/core';
import { UserContext } from '../../model/UserContext';
import { UserContextService } from '../../service/user-context.service';
import { MapService } from '../../service/map.service';
import { ConfigService } from 'app/service/config.service';

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
    public configService : ConfigService
) { }

  // map parameters
  private view: any;
  public map: any;
  public layerNamesList: Array<string> = ["1","2","3","4","5","6","7","8"];

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
    
    let center: number[] = [this.userContext.lon, this.userContext.lat];
    this.view = new ol.View({
      projection: 'EPSG:3857',
      center: ol.proj.transform(center, 'EPSG:4326', 'EPSG:3857'),
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

    $('.ol-zoom-in, .ol-zoom-out').tooltip({
      placement: 'right'
    });


    this.mapService.setMap(this.map, this.userContext);
    this.mapService.initLayers();
    this.mapService.initStyles();
    console.log(this.mapService.changesStyles);
    console.log(this.mapService.changesPointStyles);

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
      if (e.dragging) return; // si il y a déplacement de la carte, on arrête
       
      var pixel = self.map.getEventPixel(e.originalEvent);
      var hit = self.map.hasFeatureAtPixel(pixel, {hitTolerance:2}); // on vérifie si il y a un objet à l'endroit de l'événement
       
      self.map.getTargetElement().style.cursor = hit ? 'pointer' : ''; // si besoin, on change le curseur
    });
  }

  onSelect($event,layername){
    console.log($event);
    var layer = this.mapService.getLayerByTitle(layername-1);
    var isVisible = layer.getVisible()
    layer.setVisible(!isVisible);
  }

}
