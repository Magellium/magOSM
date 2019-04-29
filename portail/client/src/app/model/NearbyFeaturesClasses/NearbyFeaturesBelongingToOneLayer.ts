import { Layer } from "../Layer"

export class NearbyFeaturesBelongingToOneLayer {
  public layer:Layer;
  public featuresList;

  constructor(layer, feature){
    this.featuresList = new Array();
    this.layer = layer;
    this.featuresList.push(feature);
  }

  public isEmpty() : boolean{
    return this.featuresList.length==0;
  }

}
