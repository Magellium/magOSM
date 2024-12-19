import { Component, OnInit, Input, OnChanges, EventEmitter } from '@angular/core';
import { ApiRequestService } from 'app/service/api-request.service';
import { MapService } from 'app/service/map.service';
import { SliderService } from 'app/service/slider.service';
import { FeatureChangesRequest } from 'app/model/ChangesClasses/FeatureChangesRequest';
import { RequestOptions, RequestMethod, Headers} from '@angular/http';
import { Change } from 'app/model/ChangesClasses/Change';
import { ChangeType } from 'app/model/ChangesClasses/ChangeType';
import { Tag } from 'app/model/ChangesClasses/Tag';
import { UserContext } from 'app/model/UserContext';
import { Options, LabelType } from 'ng5-slider';
import { DomSanitizer, SafeStyle } from '@angular/platform-browser';

declare var $: any;
declare var _paq : any;

@Component({
  selector: 'app-change-details',
  templateUrl: './change-details.component.html',
  styleUrls: ['./change-details.component.css']
})
export class ChangeDetailsComponent implements OnInit, OnChanges {

  @Input() selectedFeatures : any;
  @Input() changeTypesList : Array<ChangeType>;
  @Input() userContext : UserContext;

  private panelOpen = true;
  public displayLoadSpinner: boolean = false;

  public selectedFeature;
  public featureChangesRequest : FeatureChangesRequest = new FeatureChangesRequest();
  public featureChangesList : Array<Change>;
  public mainChange : Change;
  public changeType : ChangeType;
  public timestampDate : Date;
  public tagsList : Array<Tag>;
  public mapLoader : boolean = false;
  public osmType : string;
  public lastUser : string;
  public lastChangeset : string;
  public osmId : number;
  private numberOfChangesToDisplay : number;
  public transitionalChangesetMap : Map<number,number>; //<version, changesetNumber>
  public noChangeInInterval : boolean = false;
  // To replace double apostrophes in hstore by only one.
  public deleteDoubleApostrophe : RegExp = new RegExp("''");
  
  //slider
  public displaySlider : boolean = false;
  public minValue: number;
  public maxValue: number;
  public options: Options;
  public manualRefresh: EventEmitter<void> = new EventEmitter<void>();
  public background : SafeStyle = this.sanitizer.bypassSecurityTrustStyle('rgba(100,100,100)');

  constructor(
    public apiRequestService : ApiRequestService,
    public mapService : MapService,
    public sliderService : SliderService,
    private sanitizer : DomSanitizer
  ) { }

  ngOnInit() {
    this.selectedFeature = this.selectedFeatures[0];
    var self=this;
    $("#detailspanel-close").click(function(e) {
      console.log("Au clic sur la croix !")
      self.mapService.clearSelection();
      e.preventDefault();
      $("#detailspanel").toggleClass("active");
      self.panelOpen=false;
    });
  }

  ngOnChanges(...args: any[]){
    this.selectedFeature = this.selectedFeatures[0];
    this.mapService.addFeatureToSelection(this.selectedFeature);
    this.setFeatureChangesRequest();
    this.getFeatureChanges();
    if (!this.panelOpen) { //si le panel est fermé, on l'ouvre
      console.log('onChange fired');
      console.log('changing', args);
      this.panelOpen = true;
      if(!$("#detailspanel").hasClass("active")) {
        $("#detailspanel").toggleClass("active");
      }
    }
     //// Matomo
     _paq.push(['trackEvent', 'change-feature_selected', true])
  }

  onSelect(feature){
    this.selectedFeature = feature;
    this.mapService.clearSelection();
    this.mapService.addFeatureToSelection(this.selectedFeature);

    this.setFeatureChangesRequest();
    this.getFeatureChanges();
  }

  public setFeatureChangesRequest(){
    this.featureChangesRequest.osm_id = this.selectedFeature.get('osmId');
    this.featureChangesRequest.type = this.selectedFeature.get('geom_type');
    this.featureChangesRequest.beginDate = this.apiRequestService.beginDate;
    this.featureChangesRequest.endDate = this.apiRequestService.endDate;
    this.featureChangesRequest.thematic = this.apiRequestService.thematic.id;
  }

  public getFeatureChanges(){
    this.displayLoadSpinner=true;
    var headers = new Headers();
    headers.append('Content-Type', 'application/json');
    headers.append('Accept', 'application/json');
    let options = new RequestOptions({
      method: RequestMethod.Post,
      headers : headers
    });
    var data = JSON.stringify(this.featureChangesRequest);
    console.log(data);
    this.apiRequestService.searchFeatureChanges(data, options)
      .subscribe(
        (res) => {
          this.featureChangesList = JSON.parse(res['_body']);
          console.log(this.featureChangesList);
          this.numberOfChangesToDisplay = this.featureChangesList.length;
          this.mainChange = this.mapService.getChangesMergeForOneFeature(JSON.parse(JSON.stringify(this.featureChangesList)));
          this.setDataToDisplay();
          this.initSlider();
          this.displayLoadSpinner=false;
        });
  }

  public setDataToDisplay(){
    this.osmId = Math.abs(this.mainChange.osmId);
    this.osmType = this.mapService.getOsmTypeOfFeature(this.mainChange.osmId, this.mainChange.type);
    this.changeType = this.changeTypesList.filter(x => x.id === this.mainChange.changeType)[0];
    this.timestampDate = new Date(this.mainChange.timestamp);
    this.lastUser = this.mainChange.tagsNew ? this.mainChange.tagsNew.osm_user : undefined;
   
    if(this.mainChange.tagsNew && this.mainChange.tagsNew.osm_changeset !== 0 && this.mainChange.tagsNew.osm_changeset !== "0"){
      this.lastChangeset = this.mainChange.tagsNew.osm_changeset;
    }

    this.getTagsList();
    if (this.mainChange.changeType == 6){
      var xmlhttp= new XMLHttpRequest();
      xmlhttp.onreadystatechange = function() {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
          var xmlDoc = xmlhttp.responseXML;
          let x = xmlDoc.getElementsByTagName(this.osmType);
          for (let i = 0; i< x.length; i++){
            if (x[i].attributes.getNamedItem("visible").value == "false" || i == x.length - 1){
              this.timestampDate = new Date(x[i].attributes.getNamedItem("timestamp").value);
              this.lastUser = x[i].attributes.getNamedItem("user").value;
              this.lastChangeset=x[i].attributes.getNamedItem("changeset").value;
              this.mainChange.versionNew = x[i].attributes.getNamedItem("version").value;
            }
          }
          this.getTransitionalChangesets(); 
        } 
      }.bind(this);
      xmlhttp.open("GET", "https://www.openstreetmap.org/api/0.6/"+this.osmType+"/"+this.osmId+"/history", true);
      xmlhttp.send();
    } else {
    this.getTransitionalChangesets();
    }
  }

  public getTransitionalChangesets(){
    let transitionalVersionArray = [];
    this.transitionalChangesetMap = new Map<number, number>();
    // (If creation and more than 2 changes) OR (if deletion and more than 2 changes) OR (if versionOld and versionNew exists and more than 2 changes)
    if ((this.mainChange.changeType==1 || this.mainChange.versionNew > 1) || (this.mainChange.changeType == 6 || this.mainChange.versionNew || this.mainChange.versionNew > this.mainChange.versionOld + 1 ) || (this.mainChange.versionNew && this.mainChange.versionOld && this.mainChange.versionNew - 1 > this.mainChange.versionOld)){
      
      for (var i = (this.mainChange.versionOld ? this.mainChange.versionOld : 0) + 1; i < (this.mainChange.versionNew); i++){
        transitionalVersionArray.push(i); //We have all the versions numbers we have to find !
      }

      var xmlhttp= new XMLHttpRequest();
      xmlhttp.onreadystatechange = function() {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
          var xmlDoc = xmlhttp.responseXML;
          let x = xmlDoc.getElementsByTagName(this.osmType);
          for (let i = 0; i< x.length; i++){
            if (transitionalVersionArray.indexOf(Number(x[i].attributes.getNamedItem("version").value))>-1){
              this.transitionalChangesetMap.set(Number(x[i].attributes.getNamedItem("version").value), x[i].attributes.getNamedItem("changeset").value);
            }
          } 
        } 
      }.bind(this);
    xmlhttp.open("GET", "https://www.openstreetmap.org/api/0.6/"+this.osmType+"/"+this.osmId+"/history", true);
    xmlhttp.send();

    }
  }


  public getTagsList(){
    this.tagsList = [];
    let keys = new Array<string>();
    let usedKeys = new Array<string>();
    if (this.mainChange.tagsNew != null){
      keys = keys.concat(Object.keys(this.mainChange.tagsNew));
    }
    if (this.mainChange.tagsOld != null){
      keys = keys.concat(Object.keys(this.mainChange.tagsOld));
    }
    keys.forEach(key => {
      if (['osm_changeset','osm_uid', 'osm_user'].indexOf(key) <0 && usedKeys.indexOf(key) < 0){
        this.tagsList.push(new Tag(key, this.mainChange.tagsNew === null ? null : this.mainChange.tagsNew[key], this.mainChange.tagsOld === null ? null : this.mainChange.tagsOld[key]))
        usedKeys.push(key);
      }  
    });
  }

  public getHTMLTableClass(tag : Tag){
    if (tag.valueNew == null){
      return 'table-danger'
    }
    if (tag.valueOld == null){
      return 'table-success'
    }
    if (tag.valueNew != tag.valueOld){
      return 'table-warning'
    }
  }

  // Slider part //
  public initSlider(){
    this.sliderService.initSlider(this.featureChangesRequest.beginDate, this.featureChangesRequest.endDate, this.featureChangesList, this.changeType);

    this.minValue = this.sliderService.getMinValue();
    this.maxValue = this.sliderService.getMaxValue();
    this.options = this.sliderService.getOptions();
    this.options.getSelectionBarColor = (minValue : number, maxValue : number): string => {
      return this.changeType.relatedColor.getRGBA();
    }
    this.displaySlider = true;
  
  }

  public onUserChangeEnd(event){

    let changesList = [];
    var numberofChangesOld = this.numberOfChangesToDisplay;
    this.featureChangesList.forEach(change => {
      let changeTime = new Date(change.timestamp).getTime();
      if (changeTime > event.value && changeTime < event.highValue/*+1000*60*60*24*/){
        changesList.push(change);
      }
    })
    this.numberOfChangesToDisplay = changesList.length;
    if (numberofChangesOld != this.numberOfChangesToDisplay){
      console.log(changesList);
      if (changesList.length>0){
        this.noChangeInInterval = false;
        this.mainChange = this.mapService.getChangesMergeForOneFeature(JSON.parse(JSON.stringify(changesList)));
        this.setDataToDisplay();
        //refresh the slider to change the color of the bar
        this.manualRefresh.emit();
      } else {
        this.noChangeInInterval = true;
      }
    }
  }

  public getColor(changeTypeId : number){
    var changeType : ChangeType = this.changeTypesList.filter(x => x.id === changeTypeId)[0];
    return changeType.relatedColor.getRGBA();
  }

  public onExternalOSMToolSelected(tool_name: string){
    _paq.push(['trackEvent', 'change-ext_osmtool_selected', tool_name])
  }
}
