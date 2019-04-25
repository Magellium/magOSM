import { KeyLabelObject } from './KeyLabelObject'

export class KeyLabelObjectList {
  list:Array<KeyLabelObject>;

  constructor(feature, listOfKeys){
    this.list = Array<KeyLabelObject>();
    if (listOfKeys != null){
      var priority=1; //See below : to find the key which has the highest priority (ie the lowest number) and which is in the list of Keys of the feature
      var keyFound : boolean = false;
      let unimportantList = listOfKeys.filter(x => x.priority === undefined); // Tags with no priority --> importance:"no"
      let importantList = listOfKeys.filter(x => x.priority > 0); //Tags with priority --> importance="high","medium","low"
      while (importantList.length>=priority && !keyFound){ //as long as the list has not been scanned coompletely and the key is not found and  
        let keyLabelPriority = importantList.filter(x => x.priority === priority)[0];
        if (keyLabelPriority != undefined && feature.getKeys().indexOf(keyLabelPriority.osm_key)>=0){
          var keyLabelObject = new KeyLabelObject(keyLabelPriority);
          this.list.push(keyLabelObject);
          keyFound = true; // End the loop
        }
        else {
          priority = priority + 1; //key not found --> try with the next level of priority
        }
      }
      for (let j=0;j<unimportantList.length;j++){
        if (feature.getKeys().indexOf(unimportantList[j].osm_key)>=0){//if the key is in the list of keys of the feature...
          var keyLabelObject = new KeyLabelObject(unimportantList[j]); //...the key is written
          this.list.push(keyLabelObject); 
        }
      }
    }
  }

  public isEmpty() : boolean{
    return (this.list.length == 0);
  }
}
