import { Injectable } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { Location } from '@angular/common';
import { MapService } from './map.service';
import { UserContext } from '../model/UserContext';
import { ConfigService } from './config.service';
import { Observable } from 'rxjs';
import { nextTick } from 'q';

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
    this.setContext();

  }

  setPermalink(){
    console.log("setPermalink")
    this.context = new UserContext();
    this.context.initFromCurrentView(this.mapService);
    let pLnk: string = this.context.getContextAsPermalink();
    this.location.go(pLnk);
    let piwikVlay = pLnk.substring(pLnk.indexOf("vLay=")+5);
    (!piwikVlay || piwikVlay ==="")?  piwikVlay = "none":"",
    _paq.push(['trackEvent', 'permalien' , piwikVlay])
  }

  loadUserContextFromPermalink(): UserContext{
      return this.context;
  }

  public setContext():Observable<UserContext>{
    var obs = new Observable<UserContext>(resolve => {
      this.configService.getConfig().subscribe(config => {
        this.defaultUserContext=config.DEFAULTUSERCONTEXT[0];

        this.context = new UserContext();
        this.context.initFromRoute(this.route);
        if(!this.context.isValid()){
          this.context = this.defaultUserContext;
        }
        resolve.next(this.context);
      });
    })
    return obs;
  }

}
