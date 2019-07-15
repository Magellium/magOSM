import { Component, OnInit} from '@angular/core';

import { MapService } from 'app/service/map.service';
import { ApiRequestService } from 'app/service/api-request.service';
import { ConfigService } from 'app/service/config.service';
import { UserContext } from 'app/model/UserContext';
import { UserContextService } from 'app/service/user-context.service';

@Component({
  selector: 'app-changes-main',
  templateUrl: './changes-main.component.html',
  styleUrls: ['./changes-main.component.css']
})
export class ChangesMainComponent implements OnInit {

  public jsonContextLoaded : boolean = false;
  config : any;
  private userContext : UserContext;

  loadConfigAndUserContext() {
    this.configService.getConfig()
      .subscribe(resp => {
        window["config"]=resp;
        // on charge le  contexte utilisateur
        this.userContext = this.userContextService.loadUserContextFromPermalink();
        this.jsonContextLoaded=true;
      });
  }

  constructor(
    public mapService : MapService, 
    public apiRequestService : ApiRequestService,
    public configService : ConfigService,
    public userContextService : UserContextService
    ) {
      this.loadConfigAndUserContext();
     }

  ngOnInit() {
  }
}
