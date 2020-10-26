import { Component, OnInit, Input, Output, EventEmitter, ViewChild, ElementRef } from '@angular/core';
import { MapComponent } from '../../map/map.component';
import { Layer } from '../../model/Layer';
import { MapService } from '../../service/map.service';
import { LayerChangeService } from '../../service/layer-change.service';
import { UserContext } from '../../model/UserContext';
import { environment } from '../../../environments/environment';
import { LayerAndCategory } from 'app/model/LayerAndCategory';
import { FeatureAttributeTableComponent } from 'app/feature-attribute-table/feature-attribute-table.component';

declare var config: any;
declare var $: any;
declare var _paq: any;

const average = arr => arr.reduce((p, c) => p + c, 0) / arr.length;

@Component({
  selector: 'app-layer-tree',
  templateUrl: './layer-tree.component.html',
  styleUrls: ['./layer-tree.component.css']
})

export class LayerTreeComponent implements OnInit {

  public selectedLayer: Layer;

  layervariables = config.LAYERS;

  @ViewChild('featureAttributeTableComponent') featureAttributeTableComponent: FeatureAttributeTableComponent;

  @Input('userContext')
  public userContext: UserContext;

  //Pour utiliser la variable config dans le html
  config = config;

  public myRegex = new RegExp('magosm:', 'g');

  constructor(
    private mapService: MapService,
    public layerChangeService: LayerChangeService) {
  }

  ngOnInit() {
    let self= this;
    this.layervariables.forEach(categorie => {
      categorie.features.forEach(feature => {
        feature.nom_court_trim = feature.nom_court.replaceAll(' ', '');
      }); 
    }); 
   
  }

  ngAfterViewInit() {
    $("#collapse1").collapse('show');
    //On laisse un timeout le temps que les layers soit chargé dans la carte
    setTimeout(() => this.loadVisibleLayersFromUserContext(), 1000);
    //this.loadVisibleLayersFromUserContext();
    $('[data-toggle="popover"]').popover();
  }


  loadVisibleLayersFromUserContext() {
    if (this.userContext.vLay.indexOf("none") < 0) {
      let vLay: string[] = this.userContext.vLay.split(",");
      for (var i = 0; i < vLay.length; i++) {
        let _layername: string = vLay[i];
        const _layerAndCategory = this.mapService.getCategorieAndLayerByStringAttribute("layername", _layername);
        document.getElementById("collapse" + _layerAndCategory.category).className = "collapse show";
        this.onSelect(null, _layerAndCategory.layer);

      }
    }
  }

  onKmlDownload(event, variable: Layer): void {
    event.stopPropagation();
    this.mapService.kmlExport(variable);
  }

  onShpDownload(event, variable: Layer): void {
    event.stopPropagation();
    this.mapService.shpExport(variable);
  }

  onSldDownload(event, variable: Layer): void {
    event.stopPropagation();
    window.open(environment.geoserver_baseurl+variable.sld_path, "_blank");

  }
  getState(feature){
   
    var lay=this.mapService.getLayersById(feature.layername);
    if(lay && lay.getSource())
      return lay.getSource().loadingCounter;
    return 0;
  }
  //Selection d'une couche
  onSelect(event, variable: Layer): void {
    console.log(variable.layername);

    if ($('.popover.fade.show.bs-popover-left')){
      $('.popover.fade.show.bs-popover-left').remove();
    }
    if (event) {
      event.stopPropagation();
    }
    this.selectedLayer = variable;

    this.layerChangeService.emitAnnounceLayerChangeEvent(this.selectedLayer);
    console.log(variable);
    if(this.mapService.getLayersById(variable.layername).getVisible()){
      _paq.push(['trackEvent', 'layer_visu', variable.layername]);
    }
      
    
    
  };

  changeOpacity(event, variable: Layer, value) {
    event.stopPropagation();
    this.mapService.getLayersById(variable.layername).setOpacity(value / 100);
    console.log(event);

    event.stopImmediatePropagation();
    event.preventDefault();
    return false;
  }
  onInfo(variable: Layer) {
    if (variable.md_url) {
      window.open(variable.md_url, "blank")
      _paq.push(['trackEvent', 'layer_info', variable.layername])
    }
  }

  clicktitle(): void {
    let menu = document.getElementById("menuContainer");
    let accordion = document.getElementById("menuaccordion");

    if (menu.style.left && menu.style.left != "") {
      menu.style.left = "";
      accordion.style.visibility = "visible";
    } else {
      menu.style.left = 'calc(100% - 65px)';
      accordion.style.visibility = "hidden";
    }

  }
  
  // Evènement levé lors d'un click sur le bouton "grille" en face du nom d'une couche
  // Cela provoque l'ouverture d'une fenêtre modale contenant les valeurs attributaires de la couche
  openAttributeTable($event : any, feature):void{
    this.featureAttributeTableComponent.setFeature(feature);
    _paq.push(['trackEvent', 'layer_attribut', feature.layername])
  }

  
}
