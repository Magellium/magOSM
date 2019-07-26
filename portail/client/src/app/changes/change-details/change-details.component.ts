import { Component, OnInit, Input, OnChanges } from '@angular/core';
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
import { stringify } from '@angular/core/src/render3/util';

declare var $: any;

@Component({
  selector: 'app-change-details',
  templateUrl: './change-details.component.html',
  styleUrls: ['./change-details.component.scss']
})
export class ChangeDetailsComponent implements OnInit, OnChanges {

  @Input() selectedFeature : any;
  @Input() changeTypesList : Array<ChangeType>;
  @Input() userContext : UserContext;

  private panelOpen = true;

  public featureChangesRequest : FeatureChangesRequest = new FeatureChangesRequest();
  public featureChangesList : Array<Change>;
  public mainChange : Change;
  public changeType : ChangeType;
  public timestampDate : Date;
  public tagsList : Array<Tag>;
  public mapLoader : boolean = false;
  public osmType : string;

  //slider
  public displaySlider : boolean = false;
  public minValue: number;
  public maxValue: number;
  public options: Options;

  constructor(
    public apiRequestService : ApiRequestService,
    public mapService : MapService,
    public sliderService : SliderService
  ) { }

  ngOnInit() {
    var self=this;
    //this.initSlider();
    $("#detailspanel-close").click(function(e) {
      console.log("Au clic sur la croix !")
      e.preventDefault();
      $("#detailspanel").toggleClass("active");
      self.panelOpen=false;
    });
  }

  ngOnChanges(...args: any[]){
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
  }

  public setFeatureChangesRequest(){
    this.featureChangesRequest.osm_id = this.selectedFeature.get('osmId');
    this.featureChangesRequest.type = this.selectedFeature.get('geom_type');
    this.featureChangesRequest.beginDate = this.apiRequestService.beginDate;
    this.featureChangesRequest.endDate = this.apiRequestService.endDate;
    this.featureChangesRequest.thematic = this.apiRequestService.thematic;
  }

  public getFeatureChanges(){
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
          this.mainChange = this.mapService.getChangesMergeForOneFeature(JSON.parse(JSON.stringify(this.featureChangesList)));
          this.osmType = this.mapService.getOsmTypeOfFeature(this.mainChange);
          this.changeType = this.changeTypesList.filter(x => x.id === this.mainChange.changeType)[0];
          this.timestampDate = new Date(this.mainChange.timestamp);
          this.initSlider();
          this.getTagsList();
        });
  }

  public getTagsList(){ //Distinguer les cas où new/old est nul
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
    console.log(this.tagsList);
  }

  public loadMap(){
    this.mapLoader = true;
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


  public initSlider(){
    var stepsArray = this.sliderService.getStepsArray(this.featureChangesRequest.beginDate, this.featureChangesRequest.endDate);
    var ticksArray = this.sliderService.getTicksArray(this.featureChangesList, stepsArray);

    this.minValue = this.featureChangesRequest.beginDate.getTime();
    this.maxValue = this.featureChangesRequest.endDate.getTime();
    this.options = {
      stepsArray : stepsArray.map((date : number) => {return {value : date, legend : new Date(date).toLocaleDateString('fr-FR')}}),
      translate: this.sliderService.translate,
      noSwitching: true,
      // showOuterSelectionBars:true
      showTicks: true,
      ticksArray : ticksArray,
      ticksTooltip : (value : number): string => {
        return new Date(stepsArray[value]).toLocaleDateString('fr-FR');
      },
      //readOnly : ticksArray.length<2,
      showSelectionBar:false,

      //showTicksValues: true,
      getTickColor: (value: number): string => {
        if (value == 6) {
          return 'blue';
        }
        if (value == 2){
          return 'red'
        }
        return '#2AE02A';
      },
      getSelectionBarColor: (minValue : number, maxValue : number): string => {
        return this.changeType.color;
      }
    };
    // var elements = document.getElementsByClassName('ng5-slider-selected');
    // for (let i =0; i<elements.length;i++){
    //   elements[i].classList.remove('ng5-slider-selected');
    // }
    // console.log(elements);

    this.displaySlider = true;
  }

  public onUserChangeEnd(event){

    let changesList = [];
    this.featureChangesList.forEach(change => {
      let changeTime = new Date(change.timestamp).getTime();
      if (changeTime > event.value && changeTime < event.highValue+1000*60*60*24){
        changesList.push(change);
      }
    })
    console.log(changesList);
    if (changesList.length>0){
      this.mainChange = this.mapService.getChangesMergeForOneFeature(JSON.parse(JSON.stringify(changesList)));
      this.osmType = this.mapService.getOsmTypeOfFeature(this.mainChange);
      this.changeType = this.changeTypesList.filter(x => x.id === this.mainChange.changeType)[0];
      this.timestampDate = new Date(this.mainChange.timestamp);
      this.getTagsList();
      console.log(this.changeType.color);
      this.options.getSelectionBarColor = (minValue : number, maxValue : number): string => {
        return this.changeType.color;
      }
    } else {
      alert("Pas de changement dans l'intervalle");
    }
  }
}
