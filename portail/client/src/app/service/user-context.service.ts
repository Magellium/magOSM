import { Injectable } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { Location } from '@angular/common';
import { MapService } from './map.service';
import { UserContext } from '../model/UserContext';

declare var ol;
declare var config;
declare var _paq: any;

@Injectable()
export class UserContextService {

  public context: UserContext;
  private defaultUserContext: UserContext = config.DEFAULTUSERCONTEXT[0];

  constructor(
    private mapService: MapService,
    private location: Location,
    private route: ActivatedRoute
  ) {
    this.context = new UserContext();
    this.context.initFromRoute(this.route);
    if(!this.context.isValid()){
      this.context = this.defaultUserContext;
      //this.location.go('/carte');
    }
  }

  setPermalink(){
    console.log("setPermalink")
    this.context = new UserContext();
    this.context.initFromCurrentView(this.mapService);
    let pLnk: string = this.context.getContextAsPermalink();
    this.location.go(pLnk);
    let piwikVlay = pLnk.substring(pLnk.indexOf("vLay=")+5);
    _paq.push(['trackEvent', 'permalien' , piwikVlay])
  }

  loadUserContextFromPermalink(): UserContext{
    console.log(this.context)
    return this.context;
  }

}
