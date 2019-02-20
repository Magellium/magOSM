import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { Layer } from '../model/Layer';
import { MapService } from '../service/map.service';

declare var $: any;
declare var config: any;


@Component({
  selector: 'app-feature-panel',
  templateUrl: './feature-panel.component.html',
  styleUrls: ['./feature-panel.component.css']
})
export class FeaturePanelComponent implements OnInit {

  @Output()
  layervariables = config.LAYERS;

  //Pour utiliser la variable config dans le html
  config = config;

  @Input() public selectedFeatures: any;
  @Input() public selectedLayer: Layer;


  public selectedFeature: any;
  private panelOpen = true;

  keys: Array<String> = [];
  osm_type: String;
  technical_keys: Array<String> = [];
  constructor(private mapService: MapService) { }

  ngOnInit() {
    console.log(this.selectedFeatures);
    var self=this;
    $("#featurepanel-close").click(function(e) {
      e.preventDefault();
      $("#featurepanel-wrapper").toggleClass("active");
      self.panelOpen=false;
    });

    this.selectedFeature = this.selectedFeatures[0];
    this.processAttributes();
  }
  
  processAttributes() {
    let geomType = this.selectedFeature.getGeometry().getType();
    let clefs = this.selectedFeature.getKeys();
    if (geomType == "Point") {
      this.osm_type = "node";
    }
    else {
      if ((clefs.indexOf("route") >= 0)) {
        this.osm_type = "relation";
      } else {
        this.osm_type = "way";
      }

    }
    if (clefs.indexOf("osm_type") >= 0) {
        this.osm_type = this.selectedFeature.get("osm_type");
      } 

    this.technical_keys=[];
    this.keys=[];
    for (let key in clefs) {
      console.log(clefs[key]);
      if ('boundedBy' != clefs[key] && 'way' != clefs[key] && 'st_union' != clefs[key] && 'the_geom' != clefs[key]) {
        if ('osm_' == clefs[key].substr(0, 4)) {
          if('osm_uid' != clefs[key] && 'osm_user' != clefs[key] && 'osm_changeset' != clefs[key] && 'osm_original_geom' != clefs[key]){
             this.technical_keys.push(clefs[key]);
          }
        } else {
          this.keys.push(clefs[key]);
        }

      }

    }
  }
  onSelect(feature) {
    this.selectedFeature =feature;
    this.processAttributes();
     this.mapService.cleanSelection();
      this.mapService.addToSelection(feature);
  }

  formatKey(k){
    return k.replace(/-/g,':');
  }
  ngOnChanges(...args: any[]) {//si l'@Input() selectedFeature change, cette fonction est lancée
    console.log('FeaturePanel : ngOnChanges')
    if (!this.panelOpen) { //si le panel est fermé, on l'ouvre
      console.log('onChange fired');
      console.log('changing', args);
      //$("#fpanel").show();
      this.panelOpen = true;
      if(!$("#featurepanel-wrapper").hasClass("active")) {
        $("#featurepanel-wrapper").toggleClass("active");
      }
    }
    this.selectedFeature = this.selectedFeatures[0];
    this.processAttributes();
  }

  ngAfterViewInit() {
  }

}
