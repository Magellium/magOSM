import { Component, ViewChild, OnInit, Input, Output, ChangeDetectorRef, OnDestroy} from '@angular/core';
import { MapService } from '../service/map.service';
import { Router } from '@angular/router';
import { LayerTreeComponent } from '../map-panel-switcher-components/layer-tree/layer-tree.component';
import { UserContext } from '../model/UserContext';

declare var $: any;
declare var _paq: any;

@Component({
  selector: 'app-map-panel-switcher',
  templateUrl: './map-panel-switcher.component.html',
  styleUrls: ['./map-panel-switcher.component.css']
})
export class MapPanelSwitcherComponent implements OnInit {

  public panelToShow = 'layerTree';                       //par défaut on charge le panel Menu

  @Input('userContext') 
  public userContext: UserContext;


  constructor(
    public router: Router, 
    public mapService: MapService,
    public cdr: ChangeDetectorRef
  ) { 
  }

  ngOnInit() {
    var self = this;
    $("#panel-switcher-close").click(function(e) {
      console.log("close");
      $('#panel-switcher-wrapper').popover('hide');
      e.preventDefault();
      self.closePanel();
    });
    $(".btn-panel-switcher").click(function(e) {
      e.preventDefault();
    }); 
   
    this.setPanelToShow('layerTree');
  }


  setPanelToShow(newPanelToShow){

   
      let oldPanel = this.panelToShow;
      let newPanel = newPanelToShow;
      this.panelToShow = newPanelToShow;//mise à jour du panelToShow

      //gestion de l'ouverture/fermeture du panneau sur le bon composant
      if(!$(".panel-switcher-opts").hasClass("active")){//si le panneau est fermé, on l'ouvre
        $("#panel-switcher-wrapper").toggleClass("active");
        $(".panel-switcher-opts").toggleClass("active");
        //console.log('this.panelToShow : '+panelToShow)
        _paq.push(['trackEvent', 'panel_open' , newPanelToShow])
      } else {//si le panneau est déjà ouvert
        if((oldPanel == newPanel)){//si on clique sur l'option actuellement visible : on ferme le panneau
          this.closePanel();
        }
      }
    

  
  }

  closePanel(){
    $(".panel-switcher-opts").toggleClass("active");
    $("#panel-switcher-wrapper").toggleClass("active");
  }
}
