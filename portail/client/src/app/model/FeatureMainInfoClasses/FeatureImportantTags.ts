import { KeyLabelObjectList } from './KeyLabelObjectList'

export class FeatureImportantTags {
  importance:string;
  tagList:KeyLabelObjectList;

  constructor(feature, importantLevelObj){
    this.importance= importantLevelObj.importance;
    this.tagList = new KeyLabelObjectList(feature, importantLevelObj.sub_tags);
  }

  public isEmpty() : boolean{
    return this.tagList.isEmpty();

  }
}