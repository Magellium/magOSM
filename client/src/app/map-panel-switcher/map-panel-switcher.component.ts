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

  // As soon we close the panel, we want the startup dialog to hide. But for
  // some reason (side effect of Angular's rerender on Bootstrap's popover?),
  // the DOM element for the dialog is created again when one clicks on the
  // close panel button. Thus we use a local variable that we check every time
  // the popover is "inserted", to force it to hide after a first click to close
  // (see below).
  private showStartDialog: Boolean = true;

  constructor(
    public router: Router, 
    public mapService: MapService,
    public cdr: ChangeDetectorRef
  ) { 
  }

  ngOnInit() {
    var self = this;
    $("#panel-switcher-close").click(function (e) {
      console.log("close");
      self.showStartDialog = false;
     
      $('#panel-switcher-wrapper').popover('hide');
      e.preventDefault();
      self.closePanel();
    });
    $(".btn-panel-switcher").click(function(e) {
      e.preventDefault();
    }); 
    $('#panel-switcher-wrapper').on('inserted.bs.popover', function () {
      if (!self.showStartDialog) {
       $('#panel-switcher-wrapper').popover('hide');
      }
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
