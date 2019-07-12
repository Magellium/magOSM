import { Injectable } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { Location } from '@angular/common';
import { MapService } from './map.service';
import { UserContext } from '../model/UserContext';
import { ConfigService } from './config.service';

declare var ol;
declare var _paq: any;

@Injectable()
export class UserContextService {

  public context: UserContext;
  private defaultUserContext: UserContext;

  constructor(
    private configService: ConfigService,
    private mapService: MapService,
    private location: Location,
    private route: ActivatedRoute
  ) {
    this.configService.getConfig().subscribe(config => {
      this.defaultUserContext=config.DEFAULTUSERCONTEXT[0];
      console.log(this.defaultUserContext)

      this.context = new UserContext();
      this.context.initFromRoute(this.route);
      if(!this.context.isValid()){
        this.context = this.defaultUserContext;
        //this.location.go('/carte');
      }
      console.log(this.context)
  
    })

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
