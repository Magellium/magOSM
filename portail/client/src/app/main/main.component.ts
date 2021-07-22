import { Component, ViewChild, Output } from '@angular/core';
import { MapComponent } from '../map/map.component';
import { HostListener } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { LayerChangeService} from '../service/layer-change.service';
import { UserContextService } from '../service/user-context.service';
import { UserContext } from '../model/UserContext';
import { HttpClient } from '@angular/common/http';
import { ConfigService } from 'app/service/config.service';

declare var $: any;
declare var ol: any;
declare var config: any;

@Component({
  selector: 'app-main',
  templateUrl: './main.component.html',
  styleUrls: ['./main.component.css']
})

export class MainComponent {

  //config=config;
  
  @ViewChild(MapComponent)
  public map: MapComponent;
  
  private selectedFeature;

  
  public userContext: UserContext;
  configUrl="./assets/maps/";
  jsonContextLoaded=false;


  /*getConfig() {
    // now returns an Observable of Config
    var conf=this.route.snapshot.queryParams['config'];
    if(conf==undefined){
      conf="default.json"
    }
    return this.http.get<any>(this.configUrl+conf);
  }*/

  config: any;

  constructor(
    private route: ActivatedRoute,
    private http: HttpClient,
    public layerChangeService: LayerChangeService,
    public userContextService: UserContextService,
    public configService: ConfigService
) {
    this.loadConfigAndUserContext();
    this.layerChangeService.getAnnounceLayerChangeEventEmitter().subscribe(
      newSelectedLayer=>{
        this.onMenuLayerChange(newSelectedLayer);
      }
    )
  }

  onMenuLayerChange(newSelectedLayer) {
    this.selectedFeature = undefined
    this.map.updateState(newSelectedLayer)
  }

  loadConfigAndUserContext() {
    this.configService.getConfig()
      .subscribe(resp => {
        let self=this;
        window["config"]=resp;
        // on charge le  contexte utilisateur
        // this.userContext = this.userContextService.loadUserContextFromPermalink();
        this.userContextService.setContext().subscribe({ 
          next(val) {
            self.userContext = val;
            console.log(self.userContext)
            self.jsonContextLoaded=true;
            console.log(resp);
            self.showPopovers();
          }
        })
      });
  }

  ngOnInit() {
    ol.Feature.prototype.getDisplayLabel= function(){
      //console.log('getDisplayLabel')
      if(this.getKeys().indexOf('name')>0)
        return this.get('name');
      else
        return Math.abs(this.get('osm_id'));
    }
  }

  ngAfterViewInit() {
    
  }

  showPopovers(){
    $(function () {
      $('#panel-switcher-wrapper').popover({
        html: true,
        trigger: 'manual'
      }).on("hide.bs.popover", function(e){
        $('#panel-switcher-wrapper').popover('dispose');
      });
      $('[data-toggle="popover"]').popover();
      $('#panel-switcher-wrapper').popover('show');
    })
  }
  onFeatureInfo(featureInfo){
    this.selectedFeature=featureInfo;
  }  
}

  

