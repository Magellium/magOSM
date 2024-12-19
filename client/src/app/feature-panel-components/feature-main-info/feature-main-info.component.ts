import { Component, OnInit, Input, OnChanges } from '@angular/core';
import { FeatureImportantTagsList } from '../../model/FeatureMainInfoClasses/FeatureImportantTagsList';

@Component({
  selector: 'app-feature-main-info',
  templateUrl: './feature-main-info.component.html',
  styleUrls: ['./feature-main-info.component.css']
})
export class FeatureMainInfoComponent implements OnInit, OnChanges {

  @Input() public selectedLayer: any;
  @Input() public keys: any;
  @Input() public selectedFeature: any;
  @Input() public osm_type: any;

  public featureImportantTagsList : FeatureImportantTagsList;
  public addrString : Array<string>; //For a special display of the adresses
  
  constructor() {}

  ngOnInit() {
  }

  ngOnChanges(...args: any[]){
    this.updateKeysAndLabels(this.selectedFeature, this.selectedLayer);  
  }

  //Couple key/label for each level of importance, one feature, and one layer
  public getKeyAndLabelForAllLevelsOfImportance(feature, layer) : FeatureImportantTagsList{
    return new FeatureImportantTagsList(feature, layer);
  }

  public updateKeysAndLabels(feature, layer) : void{
    this.featureImportantTagsList=this.getKeyAndLabelForAllLevelsOfImportance(feature, layer); 
    this.addrString=this.featureImportantTagsList.getAddrTagsList();
    console.log(this.selectedLayer);
  }
}
