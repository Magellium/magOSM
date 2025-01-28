import { NearbyFeaturesBelongingToOneLayer } from './NearbyFeaturesBelongingToOneLayer'
import { MapService } from '../../service/map.service';

export class NearbyFeaturesList {
  list:Array<NearbyFeaturesBelongingToOneLayer>;
  mapService:MapService; // I think this is not the right way to use MapService

  constructor(){
    this.list = new Array<NearbyFeaturesBelongingToOneLayer>();
  }
}
