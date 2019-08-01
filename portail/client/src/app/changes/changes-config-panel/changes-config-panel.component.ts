import { Component, OnInit, Input, AfterViewInit } from '@angular/core';
import { Http, RequestOptions, RequestMethod, Headers} from '@angular/http';
import { Thematic } from '../../model/ChangesClasses/Thematic'
import { ChangesRequest } from 'app/model/ChangesClasses/ChangesRequest';
import { MapService } from '../../service/map.service';
import { ApiRequestService } from '../../service/api-request.service';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { Change } from 'app/model/ChangesClasses/Change';
import { IMyDrpOptions, IMyDateRange } from 'mydaterangepicker';
import { ChangeType } from 'app/model/ChangesClasses/ChangeType';

declare var $: any;
declare var config: any;

@Component({
  selector: 'app-changes-config-panel',
  templateUrl: './changes-config-panel.component.html',
  styleUrls: ['./changes-config-panel.component.css']
})
export class ChangesConfigPanelComponent implements OnInit, AfterViewInit {

  @Input() changeTypesList: Array<ChangeType>;

  //date
  public myDateRangePickerOptions : IMyDrpOptions;
  public model : IMyDateRange;

  //form
  public changesFilterForm : FormGroup;
  public criteriaFilter: any = {};

  //data
  private thematicsList : Array<Thematic>;
  public categoryMap : Map<string,Array<Thematic>> = new Map<string,Array<Thematic>>();
  public changesRequest : ChangesRequest = new ChangesRequest();
  public selectedThematic : Thematic;
  public changesList : Array<Change>;
  public displayReport : boolean = false;
  public nothingToDisplay : boolean = false;

  //report
  public reportInfos : Map<ChangeType, number> = new Map();


  constructor(public http: Http, public mapService: MapService, public apiRequestService : ApiRequestService) { 
    
  }

  ngOnInit() {
    this.apiRequestService.searchThematics().subscribe(data => {
      this.thematicsList = JSON.parse(data['_body']);
      // Group thematics by category to display them
      this.thematicsList.forEach(thematic => {
        let value = this.categoryMap.has(thematic.category.name);
        if (value){
          this.categoryMap.get(thematic.category.name).push(thematic);
        }
        else {
          this.categoryMap.set(thematic.category.name, [thematic]);
        }
      })
      console.log(this.categoryMap);
    })
    let date = new Date();
    this.initDateForm(date);
    this.initForm();
  }

  ngAfterViewInit(){
     let dropdownMenu = $('#mydatepicker');
    //   // detach it and append it to the body
       $('body').append(dropdownMenu.detach());
  }

  onSubmit(){
    this.nothingToDisplay = false;
    if (this.formValidation()){
      this.getChangesRequestValues();
      this.changesRequest.bbox = this.mapService.getBoundingBox();
      console.log(this.changesRequest);
      this.emitChanges(this.changesRequest);
    }
  }

  public emitChanges(changesRequest : ChangesRequest){
    var headers = new Headers();
    headers.append('Content-Type', 'application/json');
    headers.append('Accept', 'application/json');
    let options = new RequestOptions({
      method: RequestMethod.Post,
      headers : headers
    });
    var data = JSON.stringify(changesRequest);
    console.log(data);
    this.apiRequestService.beginDate = this.changesRequest.beginDate;
    this.apiRequestService.endDate = this.changesRequest.endDate;
    this.apiRequestService.thematic = this.changesRequest.thematic;
    this.apiRequestService.searchChanges(data, options)
      .subscribe(
        (res) => {
          this.changesList = JSON.parse(res['_body']);
          if (this.changesList.length < 1){
            this.nothingToDisplay = true;
            //alert('Aucun changement à afficher, veuillez modifier votre requête');
          }
          console.log(this.changesList);
          this.mapService.addChanges(this.changesList);
          this.initReport();
        })
  }

  public getChangesRequestValues(){
    this.changesRequest.thematic=this.changesFilterForm.controls.thematic.value;

    //To have the time in UTC and not with the local timezone.
    let iMyBeginDate = this.changesFilterForm.controls.dates.value.beginDate;
    let beginDate : Date = new Date(Date.UTC(iMyBeginDate.year, iMyBeginDate.month-1, iMyBeginDate.day));
    let iMyEndDate = this.changesFilterForm.controls.dates.value.endDate;
    let endDate : Date = new Date(Date.UTC(iMyEndDate.year, iMyEndDate.month-1, iMyEndDate.day));
    endDate.setUTCSeconds(endDate.getUTCSeconds()-1);
    this.changesRequest.beginDate=beginDate;
    this.changesRequest.endDate=endDate;
  }

  initForm() {
    this.changesFilterForm = new FormGroup({
      'thematic': new FormControl(16,[Validators.required]),
      'dates': new FormControl(this.model,[]),
    });
  }

  get thematic(){return this.changesFilterForm.get('thematic'); }
  
  initDateForm(today: Date) {
    var disableUntil : Date = new Date(new Date().setDate(today.getDate()-1-config.DAYS_INTERVAL_FOR_CHANGES_MONITORING));
    var twoWeeksBefore : Date = new Date(new Date().setDate(today.getDate()-14));
    this.myDateRangePickerOptions = {
      // options du composant pour les deux dates
      dayLabels: { su: "Dim", mo: "Lun", tu: "Mar", we: "Mer", th: "Jeu", fr: "Ven", sa: "Sam" },
      monthLabels: { 1: "Jan", 2: "Fév", 3: "Mar", 4: "Avr", 5: "Mai", 6: "Juin", 7: "Juil", 8: "Aoû", 9: "Sep", 10: "Oct", 11: "Nov", 12: "Déc" },
      disableSince:{ 
        year: today.getFullYear(),
        month: today.getMonth()+1,
        day: today.getDate()+1
      },
      disableUntil: { //On conserve un intervalle de temps donné par la variable DAYS_INTERVALL
        year: disableUntil.getFullYear(),
        month: disableUntil.getMonth()+1,
        day: disableUntil.getDate()
      },
      dateFormat:"dd/mm/yyyy",
      selectBeginDateTxt:"Choisir la date de début",
      selectEndDateTxt:"Choisir la date de fin",
      editableDateRangeField: false,
      openSelectorOnInputClick : true,
      width: '100%',
    };
    var td = {
      year: today.getFullYear(),
      month: today.getMonth()+1,
      day: today.getDate(),
    };

    var twoWksBefore = {
    year: twoWeeksBefore.getFullYear(),
    month: twoWeeksBefore.getMonth()+1,
    day: twoWeeksBefore.getDate(),
    };
    this.model = {endDate: td, beginDate : twoWksBefore};
  }

  initReport(){
    this.reportInfos = this.mapService.numberOfChangeByType;
    this.displayReport = true;
  }

  public formValidation(){
    if (this.changesFilterForm.controls.thematic.value == null){
      alert('Renseignez une thématique !')
      return false;
    }
    return true;

  }


}
