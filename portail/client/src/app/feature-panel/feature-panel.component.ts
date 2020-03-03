import { Component, OnInit, Input, Output, EventEmitter, ViewChild } from '@angular/core';
import { Layer } from '../model/Layer';
import { MapService } from '../service/map.service';
import { NearbyFeaturesService } from '../service/nearbyFeatures.service';
import { FeatureMainInfoComponent } from 'app/feature-panel-components/feature-main-info/feature-main-info.component';
import { NearbyFeaturesList } from '../model/NearbyFeaturesClasses/NearbyFeaturesList';


declare var $: any;
declare var config: any;
declare var _paq: any;

@Component({
  selector: 'app-feature-panel',
  templateUrl: './feature-panel.component.html',
  styleUrls: ['./feature-panel.component.css']
})
export class FeaturePanelComponent implements OnInit {

  @Output()
  layervariables = config.LAYERS;

  //To use the variable config in the html
  config = config;

  @Input() public selectedFeatures: any;
  @Input() public selectedLayer: Layer;

  @ViewChild(FeatureMainInfoComponent) featureMainInfoComponent: FeatureMainInfoComponent;

  public selectedFeature: any;
  private panelOpen = true;

  keys: Array<String> = [];
  osm_type: String = "node";
  technical_keys: Array<String> = [];
  nearbyFeatures: NearbyFeaturesList;
  constructor(private mapService: MapService, private nearbyFeaturesService : NearbyFeaturesService) { }

  ngOnInit() {
    var self=this;
    $("#featurepanel-close").click(function(e) {
      e.preventDefault();
      $("#featurepanel-wrapper").toggleClass("active");
      self.panelOpen=false;
    });

    this.selectedFeature = this.selectedFeatures[0];
    this.processAttributes();
    this.updateSelectedLayer(this.selectedFeature);
    this.updateNearbyFeaturesList();
  }

  onSelect(feature) {
    this.selectedFeature =feature;
    this.processAttributes();
    this.mapService.cleanSelection();
    this.mapService.addToSelection(feature);
    this.updateSelectedLayer(this.selectedFeature);
    this.updateNearbyFeaturesList();
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
    this.updateSelectedLayer(this.selectedFeature);
    this.updateNearbyFeaturesList();
  }

  ngAfterViewInit() {
  }
  
  //Find the attributes and separate them in to array : keys and technicals_keys ("osm_...")
  processAttributes() {
    let geomType = this.selectedFeature.getGeometry().getType();
    let clefs = this.selectedFeature.getKeys();
    //Determine the osm_type
    // It's NOT easy because : polygon are simplified so the geomType is a Point. Some relations have a positive osm_id and route=*, the other relation have a negative osm_id
    if (clefs.indexOf('osm_type') >= 0) {
      this.osm_type = this.selectedFeature.get('osm_type');
    } else { 
      this.osm_type = "way";
    }
    if ((clefs.indexOf("route") >= 0) || this.selectedFeature.get('osm_id') < 0) {
          this.osm_type = "relation";
    }

    this.technical_keys=[];
    this.keys=[];
    for (let key in clefs) {
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
   
  //Keys are written with "-" instead of a ":" in the DB
  public formatKey(key :string) : string{
    return key.replace(/-/g,':');
  }


  public updateNearbyFeaturesList(){
    if (this.selectedFeatures.length>1){
      this.nearbyFeatures = this.nearbyFeaturesService.getNearbyFeaturesList(this.selectedFeatures, this.selectedFeature);
      console.log(this.nearbyFeatures);
      console.log(this.selectedFeatures);
    }
  }

  //For the list of nearby features, this function is called for each features on the dropdown-menu
  public getLabelToDisplay(feature,layer) :string{
    var featureImportantTagsList = this.featureMainInfoComponent.getKeyAndLabelForAllLevelsOfImportance(feature,layer); 
    var severalLayers : boolean = (this.mapService.getNumberOfVisibleLayers()>1);

    if (!featureImportantTagsList.isEmpty()){ //if the list is not null, return the high important key
    var highImportanceList = featureImportantTagsList.list.filter(x => x.importance=== "high");
      if (highImportanceList.length >0){// If highImportanceList is not empty
        var highImportanceTag = highImportanceList[0].tagList;
        if (!highImportanceTag.isEmpty()){
            return feature.get(highImportanceList[0].tagList.list[0].key);
        }
      }
    }
    //if the list is null (ie there is nothing to display) or there is no high important key to display, return the name of the layer and the osm_id.
    return "Objet n°" + Math.abs(feature.get('osm_id')).toString();
  }
 
  //the selectedLayer changes when the user clicks on a feature which belongs to on another layer
  private updateSelectedLayer(feature):void{
    this.selectedLayer= this.mapService.getLayerOfOneFeature(feature);
  }

  // For the display on the table : if the value is NonRelevant, the logos won't appear on the second row.
  // The function reads the config
  public isValueIrrelevant(tag : string) : boolean{
    let isValueIrrelevant = false;
    config.OSM_KEYS_WITH_IRRELEVANT_VALUE_FOR_EXTERNAL_LINKS.forEach(function(n){
      if (tag.startsWith(n.osm_key)){
        isValueIrrelevant=true;
      }
    })
    return isValueIrrelevant;
  }
    
  //Matomo Events
  tableSelected(table){
    if (!(document.getElementById("collapse"+table).classList.contains('show'))){
      _paq.push(['trackEvent', 'table_selected', table]);
    }
  }
  dropdownMenuSelected(){
    if (!(document.getElementById("features_nearby_list").classList.contains('show'))){
      _paq.push(['trackEvent', 'features_nearby_list_selected', true]);
    }
  }

}