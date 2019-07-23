import { Component, OnInit, Input, AfterViewInit } from '@angular/core';
import { Http, RequestOptions, RequestMethod, Headers} from '@angular/http';
import { Thematic } from '../../model/ChangesClasses/Thematic'
import { ChangesRequest } from 'app/model/ChangesClasses/ChangesRequest';
import { MapService } from '../../service/map.service';
import { ApiRequestService } from '../../service/api-request.service';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { Change } from 'app/model/ChangesClasses/Change';
import { IMyDrpOptions, IMyDateRange, IMyDate } from 'mydaterangepicker';
import { ChangeType } from 'app/model/ChangesClasses/ChangeType';


declare var $: any;
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
  public changesRequest : ChangesRequest = new ChangesRequest();
  public selectedThematic : Thematic;
  public changesList : Array<Change>;
  public displayReport : boolean = false;

  //report
  public reportInfos : Map<ChangeType, number> = new Map();


  constructor(public http: Http, public mapService: MapService, public apiRequestService : ApiRequestService) { 
    
  }

  ngOnInit() {
    this.apiRequestService.searchThematics().subscribe(data => {
      this.thematicsList = JSON.parse(data['_body']);
      console.log(this.thematicsList);
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
          console.log(this.changesList);
          this.mapService.addChanges(this.changesList);
          this.initReport();
        })
  }

  public getChangesRequestValues(){
    this.changesRequest.thematic=this.changesFilterForm.controls.thematic.value;
    console.log(this.changesFilterForm.controls.dates.value);
    this.changesRequest.beginDate=this.changesFilterForm.controls.dates.value.beginJsDate;
    this.changesRequest.endDate=this.changesFilterForm.controls.dates.value.endJsDate;
  }

  initForm() {
    this.changesFilterForm = new FormGroup({
      'thematic': new FormControl(16,[Validators.required]),
      'dates': new FormControl(this.model,[]),
    });
  }

  get thematic(){return this.changesFilterForm.get('thematic'); }

  initDateForm(date: Date) {
    this.myDateRangePickerOptions = {
      // options du composant pour les deux dates
      dayLabels: { su: "Dim", mo: "Lun", tu: "Mar", we: "Mer", th: "Jeu", fr: "Ven", sa: "Sam" },
      monthLabels: { 1: "Jan", 2: "Fév", 3: "Mar", 4: "Avr", 5: "Mai", 6: "Juin", 7: "Juil", 8: "Aoû", 9: "Sep", 10: "Oct", 11: "Nov", 12: "Déc" },
      disableSince:{ 
        year: date.getFullYear(),
        month: date.getMonth()+1,
        day: date.getDate()+1
      },
      disableUntil: { //Pour ne garder que 30 jours pour l'intervalle
        year: date.getFullYear(),
        month: date.getMonth(),
        day: date.getDate()
      },
      dateFormat:"dd/mm/yyyy",
      selectBeginDateTxt:"Choisir la date de début",
      selectEndDateTxt:"Choisir la date de fin",
      editableDateRangeField: false,
      openSelectorOnInputClick : true,
    };
    var today = {
      year: date.getFullYear(),
      month: date.getMonth()+1,
      day: date.getDate()
    };

    var oneMonthBefore = {
    year: date.getFullYear(),
    month: date.getMonth()+1,
    day: date.getDate()-7
  }

    this.model = {endDate: today, beginDate : oneMonthBefore};
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
