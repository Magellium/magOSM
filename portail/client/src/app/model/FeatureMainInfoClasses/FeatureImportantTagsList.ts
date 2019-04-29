import { FeatureImportantTags } from './FeatureImportantTags'

export class FeatureImportantTagsList {
  list: Array<FeatureImportantTags>;

  constructor(feature, layer){ //Construction of the object with the feature-main-info of the layer
    this.list= Array<FeatureImportantTags>();
    if (layer.feature_main_info != undefined){
      for (var i=0;i<layer.feature_main_info.length;i++){ //For each level of importance of the feature-main-info
        var featureImportantTags = new FeatureImportantTags(feature, layer.feature_main_info[i]);
        this.list.push(featureImportantTags);
      }
    }
  }

  public isEmpty() : boolean{
    var isEmptyBool : boolean = true;
    for (let i in this.list){
      isEmptyBool = isEmptyBool && this.list[i].isEmpty();
    }
    return isEmptyBool;
  }

  public getAddrTagsList() : Array<string>{ //For a special display (Addr_tags are written like an adress)
    let used_addr= Array<string>();
    let addrTags= Array<string>();
    let noImportance = this.list.filter(x => x.importance === 'no')[0];
    if (noImportance != undefined){
      noImportance.tagList.list.filter(x => x.key.startsWith('addr')).forEach(function(x){
        addrTags.push(x.key);
      });
      //group housenumber and street
      if (addrTags.indexOf('addr-housenumber')>=0 && addrTags.indexOf('addr-street')>=0){
        used_addr.push('addr-housenumber');
        used_addr.push('addr-street');
      }
      //group postcode and city
      if (addrTags.indexOf('addr-postcode')>=0 && addrTags.indexOf('addr-city')>=0){
        used_addr.push('addr-postcode');
        used_addr.push('addr-city');
      }
      for (let addr in addrTags){
        if(used_addr.indexOf(addrTags[addr])<0){
          // add others addr tags if they exist
          used_addr.push(addrTags[addr]);
        }
      }
    }
    return used_addr;
  }
}