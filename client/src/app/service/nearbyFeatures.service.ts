import { Injectable } from '@angular/core';
import { MapService } from 'app/service/map.service';
import { NearbyFeaturesList } from 'app/model/NearbyFeaturesClasses/NearbyFeaturesList';
import { NearbyFeaturesBelongingToOneLayer } from 'app/model/NearbyFeaturesClasses/NearbyFeaturesBelongingToOneLayer'

@Injectable({
  providedIn: 'root'
})
export class NearbyFeaturesService {
  constructor(private mapService: MapService) { }
  getNearbyFeaturesList(features,selectedFeature){
    var nearbyFeaturesList = new NearbyFeaturesList;
    for (let j=0;j<features.length;j++){
      if (features[j]!=selectedFeature){ // Don't display the selectedFeature.
        this.addOneFeature(features[j],nearbyFeaturesList);
      }
    }
    return nearbyFeaturesList;
  }

  addOneFeature(feature,nearbyFeaturesList){
    var layer = this.mapService.getLayerOfOneFeature(feature);
    var nearbyFeaturesListFromThisLayer = nearbyFeaturesList.list.filter(x => x.layer === layer);
    if (nearbyFeaturesListFromThisLayer.length == 0){ // If the object NearbyFeaturesBelongingToOneLayer for this layer doesn't exist yet, create it
      nearbyFeaturesList.list.push(new NearbyFeaturesBelongingToOneLayer(layer, feature))
    }
    else{
      nearbyFeaturesListFromThisLayer[0].featuresList.push(feature); //If the object already exists, add push the feature in it.
    }
  }

}
