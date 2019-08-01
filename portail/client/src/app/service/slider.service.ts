import { Injectable } from '@angular/core';
import { LabelType, Options } from 'ng5-slider';
import { Change } from 'app/model/ChangesClasses/Change';
import { ChangeType } from 'app/model/ChangesClasses/ChangeType';

@Injectable({
  providedIn: 'root'
})
export class SliderService {

  public options : Options;
  public stepsArray;
  public ticksArray;
  public minValue;
  public maxValue;

  public getMinValue(){
    return this.minValue;
  }
  public getMaxValue(){
    return this.maxValue;
  }
  public getOptions(){
    return this.options;
  }
  constructor() { }

  public initSlider(beginDate, endDate, featureChangesList, changeType){
    this.stepsArray = this.getStepsArray(beginDate, endDate);
    this.ticksArray = this.getTicksArray(featureChangesList, this.stepsArray);
    this.minValue = beginDate.getTime();
    this.maxValue = endDate.getTime();
    this.setOptions(this.stepsArray, this.ticksArray, changeType);

  }
  public setOptions(stepsArray, ticksArray, changeType){
    var dateOptions = { month: 'numeric', day: 'numeric' };
    this.options = {
      stepsArray : stepsArray.map((date : number) => {return {value : date, legend : "<b>"+new Date(date).toLocaleDateString('fr-FR', dateOptions)+"</b>"}}),
      translate: this.translate,
      noSwitching: true,
      showTicks: true,
      ticksArray : ticksArray,
      showSelectionBar:false,
      getTickColor: (value: number): string => {
        if (value == 6) {
          return 'blue';
        }
        if (value == 2){
          return 'red'
        }
        return '#2AE02A';
      },
      // getSelectionBarColor: (minValue : number, maxValue : number): string => {
      //   console.log(changeType);
      //   return this.getRGBA(changeType);
      // }
    };
  }

  public getStepsArray(beginDate :Date, endDate :Date) : any[]{
    if (endDate.getTime() < beginDate.getTime()){
      return [];
    }
    else {
      var stepsArray = [];
      var date = beginDate;
      while (date.getTime() <= endDate.getTime()){
       stepsArray.push(date.getTime());
       date = new Date(date.getTime() + 1000*60*60*24);
      }
      return stepsArray;
    }
  }

  public translate(value: number, label: LabelType) : string{
    var dateOptions = { month: 'numeric', day: 'numeric' };
    return new Date(value).toLocaleDateString('fr-FR', dateOptions);
  }

  public getTicksArray(changesList : Array<Change>, stepsArray : any[]) : Array<number>{
    var ticksArray = [];
    changesList.forEach((change : Change) => {
      var timestamp = new Date(change.timestamp);
      timestamp.setUTCHours(0);
      timestamp.setUTCMinutes(0);
      timestamp.setUTCSeconds(0);
      ticksArray.push(stepsArray.indexOf(timestamp.getTime()));
    });
    return ticksArray;
  }

  public getRGBA(changeType : ChangeType){
    return "rgba("+changeType.color.R+","+changeType.color.G+","+changeType.color.B+")"
  }
}
