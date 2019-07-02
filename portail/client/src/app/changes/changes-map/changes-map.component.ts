import { Input, Component, AfterViewInit } from '@angular/core';
import { UserContext } from '../../model/UserContext';
import { UserContextService } from '../../service/user-context.service';
import { MapService } from '../../service/map.service';

declare var ol: any;
declare var config: any;

@Component({
  selector: 'app-changes-map',
  templateUrl: './changes-map.component.html',
  styleUrls: ['./changes-map.component.css']
})
export class ChangesMapComponent implements AfterViewInit {

  @Input() public change : any;

  constructor(public mapService: MapService) { }

  // map parameters
  private view: any;
  private userContextService : UserContextService;
  private userContext : UserContext;
  private map: any;

  ngOnInit() {
  }

  ngAfterViewInit(){
    console.log(this.change);
    this.initMap();
  }

  initMap(){

    console.log(this.change);

    var mousePositionControl = new ol.control.MousePosition({
      coordinateFormat: function (coords) {
        return ol.coordinate.format(coords, 'Lat : {y}° Lon : {x}° (WGS84)', 4)
      },
      projection: 'EPSG:3857',
      className: 'custom-mouse-position',
      target: document.getElementById('mouse-position'),
      undefinedHTML: '&nbsp;'
    });

    let center: number[] = this.getMapCenter();
    this.view = new ol.View({
      projection: 'EPSG:3857',
      center: center,
      zoom: 14,
      minZoom: 3,
      //maxZoom: 18
    })

    var overviewMapControl = new ol.control.OverviewMap({
      view: new ol.View({
        maxZoom: 6,
        minZoom: 6,
        zoom: 6,
      }),
      collapsed: false,
      collapsible: false,
      target : "overview-position"
    });  

    //Map creation
    this.map = new ol.Map({
      controls: ol.control.defaults({
        attributionOptions: /** @type {olx.control.AttributionOptions} */ ({
          collapsible: false
        })
      }).extend([
        mousePositionControl,
        //new ol.control.ScaleLine(),
        overviewMapControl,
      ]),
      target: 'map',
      view: this.view,
      layers: [
        new ol.layer.Tile({
        source: new ol.source.OSM(),
        projection : 'EPSG:3857',
        opacity:0.5
        })
      ]
    });

    this.map.addLayer(this.getVectorPoint());
    //this.mapService.setMap(this.map, this.userContext);

    //this.map.on('click', this.onClick.bind(this));
    //this.map.on('moveend', this.onZoom.bind(this)); 
  }
  

  public getMapCenter(){
    if (this.change.the_geom_old == null) {
      return [this.change.the_geom_new.coordinates[0], this.change.the_geom_new.coordinates[1]]
    } else {
      if (this.change.the_geom_new == null){
        return [this.change.the_geom_old.coordinates[0], this.change.the_geom_old.coordinates[1]]
      }
      else {
        return [(this.change.the_geom_new.coordinates[0]+this.change.the_geom_old.coordinates[0])/2, (this.change.the_geom_new.coordinates[1]+this.change.the_geom_old.coordinates[1])/2]
      }
    }
  }

  public getVectorPoint(){
    //Point with the_geom_new
    let redColor = this.getStyledCircle([180,0,0,1])
    let greenColor = this.getStyledCircle([0,180,0,1])
    //let yellowColor = this.getStyledCircle([255,255,0,1])
    let features=[];
    if (this.change.the_geom_new != null) {
      var newPoint = new ol.Feature({
        geometry: new ol.geom.Point(this.change.the_geom_new.coordinates),
        name: "Nouvel emplacement",
      });
    newPoint.setStyle(greenColor);
    features.push(newPoint);
    }
    if (this.change.the_geom_old != null && this.change.change_type != 3) {
      var oldPoint = new ol.Feature({
        geometry: new ol.geom.Point(this.change.the_geom_old.coordinates),
        name: "Ancien emplacement",
      });
    oldPoint.setStyle(redColor);
    features.push(oldPoint);
    }
    console.log(oldPoint);
    var vectorSource = new ol.source.Vector({
      features: features,
    });

    var vectorPoint = new ol.layer.Vector({
      source: vectorSource,
    });
    return vectorPoint;
  }

  public getStyledCircle(colortab){
    let colorStyle = new ol.style.Style({   
      image: new ol.style.Circle({
        radius: 4,
        stroke: new ol.style.Stroke({
            color: colortab
        }),
        fill: new ol.style.Fill({
            color: colortab
        })
      })
    });
    return colorStyle;
  }
}
