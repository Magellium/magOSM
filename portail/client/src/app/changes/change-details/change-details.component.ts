import { Component, OnInit, Input, OnChanges } from '@angular/core';
import { ApiRequestService } from 'app/service/api-request.service';
import { FeatureChangesRequest } from 'app/model/ChangesClasses/FeatureChangesRequest';
import { RequestOptions, RequestMethod, Headers} from '@angular/http';
import { Change } from 'app/model/ChangesClasses/Change';
import { MapService } from 'app/service/map.service';
import { ChangeType } from 'app/model/ChangesClasses/ChangeType';
import { Tag } from 'app/model/ChangesClasses/Tag';
import { UserContext } from 'app/model/UserContext';

declare var $: any;

@Component({
  selector: 'app-change-details',
  templateUrl: './change-details.component.html',
  styleUrls: ['./change-details.component.css']
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

  constructor(
    public apiRequestService : ApiRequestService,
    public mapService : MapService
  ) { }

  ngOnInit() {
    var self=this;

    $("#detailspanel-close").click(function(e) {
      console.log("Au clic sur la croix !")
      e.preventDefault();
      $("#detailspanel").toggleClass("active");
      self.panelOpen=false;
    });
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
          //this.mainChange = this.featureChangesList[0];
          this.mainChange = this.mapService.getChangesMergeForOneFeature(this.featureChangesList);
          this.changeType = this.changeTypesList.filter(x => x.id === this.mainChange.changeType)[0];
          this.timestampDate = new Date(this.mainChange.timestamp);
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
    console.log("clés", keys);
    keys.forEach(key => {
      if (['osm_changeset','osm_uid', 'osm_user'].indexOf(key) <0 && usedKeys.indexOf(key) < 0){
        this.tagsList.push(new Tag(key, this.mainChange.tagsNew === null ? null : this.mainChange.tagsNew[key], this.mainChange.tagsOld === null ? null : this.mainChange.tagsOld[key]))
        usedKeys.push(key);
      }  
    });
    console.log(this.tagsList);
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

  public loadMap(){
    this.mapLoader = true;
  }
}
