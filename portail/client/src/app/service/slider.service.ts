import { Injectable } from '@angular/core';
import { LabelType } from 'ng5-slider';
import { Change } from 'app/model/ChangesClasses/Change';

@Injectable({
  providedIn: 'root'
})
export class SliderService {

  constructor() { }

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
    return new Date(value).toLocaleDateString('fr-FR');
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
}
