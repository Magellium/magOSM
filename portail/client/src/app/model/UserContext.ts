import { ActivatedRoute } from '@angular/router';
import { MapService } from '../service/map.service';
import { MapComponent } from '../map/map.component';

declare var ol: any;
declare var config: any;

export class UserContext{
  // zoom
  z:number;
  // longitude
  lon:number;
  // latitude
  lat:number;
  // base layer name
  bLay:string;
  // visible layer name
  vLay:string;
  // opacity range
  tr:number;
  
  constructor(){};

  initFromRoute(route: ActivatedRoute){
      this.z=route.snapshot.queryParams['z'],
      this.lon=parseFloat(route.snapshot.queryParams['lon']),
      this.lat=parseFloat(route.snapshot.queryParams['lat']),
      this.bLay=route.snapshot.queryParams['bLay'],
      this.vLay=route.snapshot.queryParams['vLay'],
      (!this.vLay || this.vLay ==="")?  this.vLay = "none":"",
      this.tr=route.snapshot.queryParams['tr'] 
  }

  initFromCurrentView(mapService: MapService){
      let center = ol.proj.transform(mapService.map.getView().getCenter(), config.PROJECTION_CODE, 'EPSG:4326');
      this.z=mapService.map.getView().getZoom();
      this.lon=center[0].toFixed(4);
      this.lat=center[1].toFixed(4);//TODO MapComponent.PROJECTION_CODE
      this.bLay=null;//mapService.getBaseLayerName();
      this.vLay=mapService.getVisibleLayersIdList();
      this.tr=mapService.getOpacityRange();
  }

  getContextAsPermalink(): string{
      return '/carte?'
      +'z='+this.z
      +'&lon='+this.lon
      +'&lat='+this.lat
      //+'&bLay='+this.bLay
      +'&tr='+this.tr
      +'&vLay='+this.vLay.replace(new RegExp('magosm:', 'g'), '');
  }

  isValid(): Boolean{
    if(!this.z || !this.lon || !this.lat || !this.tr){
      return false;
    } else {
      return true;
    }
  }


}