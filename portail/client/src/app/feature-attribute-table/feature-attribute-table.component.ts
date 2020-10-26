import { Component, OnInit, Input, ViewChild, ElementRef } from '@angular/core';
import { HttpClient } from '@angular/common/http';

import { Layer } from 'app/model/Layer';
import { MapService } from 'app/service/map.service';
import { PaginationService } from 'app/service/pagination.service';

import { WFSRequest } from 'app/model/WFSRequest';
import { bind } from '@angular/core/src/render3/instructions';



declare var $: any;
@Component({
  selector: 'app-feature-attribute-table',
  templateUrl: './feature-attribute-table.component.html',
  styleUrls: ['./feature-attribute-table.component.css']
})
export class FeatureAttributeTableComponent implements OnInit {

  @Input() selectedFeature : any;

  @ViewChild('pageItem1') pageItem1: ElementRef;
  @ViewChild('pageItem2') pageItem2: ElementRef;
  @ViewChild('pageItem3') pageItem3: ElementRef;
  @ViewChild('previousPage') previousPage: ElementRef;
  @ViewChild('nextPage') nextPage: ElementRef;
  @ViewChild('pageSize') pageSize: ElementRef;
  @ViewChild('pageSizeInput') pageSizeInput: ElementRef;
  @ViewChild('rangePage') rangePage: ElementRef;
  @ViewChild('featureAttributeTableModal')  modal: ElementRef;
  
  public currentFeature : Layer;

  private static bboxKey : string = 'bbox';
  // champs geoserver WFS à ne pas afficher 
  private static osmOriginalGeomKey : string = 'osm_original_geom';

  public featureAttributeKeyTable : Array<string> = [];
  public featureAttributeValuesTable : Array<any> = [];
  public loadingWFS : boolean;

  public isInitializedSorter : boolean = false;
  public wfsRequest : WFSRequest;
  public currentZoomMap : number; 
  
  
  constructor(
    public mapService: MapService,
    private http: HttpClient, 
    private paginationService : PaginationService) { 
      this.wfsRequest = new WFSRequest(this.mapService);
      this.mapService = mapService;
     
    }
  
  ngOnInit() {    
    // initialise la barre de navigation après l'affichage IHM
    $(this.modal.nativeElement).on('shown.bs.modal',  () => {
      setTimeout(() => {
        this.paginationService.initializeElementRef(this.previousPage, this.pageItem1, this.pageItem2, this.pageItem3, this.nextPage, this.pageSize, this.rangePage);    
        this.paginationService.actualizePagination();     
      });
    });

    // initialise la barre de navigation après la suppression de l'affichage à l'IHM
    $(this.modal.nativeElement).on('hidden.bs.modal',  () => {
      setTimeout(() => {
        this.paginationService.resetPagination();    
        this.isInitializedSorter = false;
      });
    });
  }

  initFeatureAttribute(feature){
    this.featureAttributeValuesTable = [];  
    if (this.mapService){
      this.currentZoomMap = this.mapService.getMap().getView().getZoom();
    }
    if (feature){
      this.wfsRequest.setFeature(feature);
    }
    this.requestWFS();    
  }

  // Appel du setter depuis le composant "LayerTreeComponent"
  // mais aussi lors du clic sur le reload de la fenêtre
  setFeature(feature){
    if (feature){
      this.currentFeature = feature;
    }
    this.paginationService.resetPageIndex();
    
    this.initFeatureAttribute(feature);
    // affichage de la fenêtre modal des valeurs attributaires de la couches demandées
    $('#featureAttributeTableModal').modal('show');
  }
  
  
  initializeSorter(){
    if (!this.isInitializedSorter){

      this.featureAttributeKeyTable.forEach(headerKey => {
        if (FeatureAttributeTableComponent.bboxKey != headerKey 
          && FeatureAttributeTableComponent.osmOriginalGeomKey != headerKey ){
          
          this.paginationService.setSort(headerKey, PaginationService.UNSORTED);
        }      
      });
      this.isInitializedSorter = true;
    }
  }

  ////////////////////////////////////////////////////////////
  // LES EVENEMENTS
  public onChangePageIndex($event){
    
    this.checkChangingMapZoom(function(scope){
      scope.paginationService.setPageIndex(parseInt($event.target.innerHTML)-1); 
    });

    this.requestWFS();
  }
  

  /* fonction déclenchée suite au click bouton "Ouvrir" de la dialogue de fichier */
  public handlePageSizeInputKeyDown(event: any) {
    // Concerne les 2 touches "Entrée"
    if (event.keyCode == 13) {
      let pageInput = parseInt(event.target.value)-1;

      this.checkChangingMapZoom(function(scope){
        scope.paginationService.setPageIndex(pageInput);
      });
      this.requestWFS();
    }
  }

  onChangePreviousPage(){
    this.checkChangingMapZoom(function(scope){
      scope.paginationService.goToPreviousPage();
    });
    this.requestWFS();
  }

  checkChangingMapZoom(callback :Function){
    if (this.currentZoomMap == this.mapService.getMap().getView().getZoom()){      
      callback(this); 
    } else {
      this.currentZoomMap = this.mapService.getMap().getView().getZoom();
      this.paginationService.resetPageIndex();
    }    
  }

  onChangeNextPage(){
    this.checkChangingMapZoom(function(scope){
      scope.paginationService.goToNextPage(); 
    });

    this.requestWFS();
  }
  
  public onChangePageSize(){

    // console.log(" => Nombre d'éléments par page : " + this.pageSize.nativeElement.innerText);
    this.paginationService.resetPageIndex();
    this.paginationService.setPageSize(parseInt(this.pageSize.nativeElement.value));
    this.requestWFS();
  }
  
  public onChangeLastPage(){

    this.checkChangingMapZoom(function(scope){
      scope.paginationService.setPageIndex(scope.paginationService.getLastPageIndex() ); 
    });

    this.requestWFS();
  }


  private parseWFS(data){
    let jsonData = JSON.parse(data);
    this.featureAttributeValuesTable = [];

    jsonData.features.forEach(element => {
      if (this.featureAttributeKeyTable.length==0){
        this.featureAttributeKeyTable =  Object.keys(element.properties);
      }
      this.featureAttributeValuesTable.push(element);
    });
    this.paginationService.setData(this.featureAttributeValuesTable);

    this.paginationService.setTotalElement(jsonData['totalFeatures']?jsonData['totalFeatures']:jsonData['numberMatched']);
    this.paginationService.actualizePagination();
  }


  // evenement levé sur le clique du bouton "Centrer", 
  // fait appel au service de carte pour centrer la carte sur la géométrie d el'item concidéré
  centerGeom($event, geom) {
    this.mapService.centerItemGeom(geom);
  }

  sort(featureAttributeKey : string){
    this.featureAttributeValuesTable = [];
    let sorterDir = this.paginationService.setSortColumn(featureAttributeKey);
    this.wfsRequest.setSorter(featureAttributeKey, sorterDir);
    this.requestWFS();
  }

  public requestWFS(){    
    this.loadingWFS = true;
    this.wfsRequest.setStartIndex(this.paginationService.getPageIndex() * this.paginationService.getPageSize() + 1);
    this.wfsRequest.setCount(this.paginationService.getPageSize() );
    this.http.get(this.wfsRequest.build(), {responseType: 'text'})
    .subscribe(
      
      data => {
        this.loadingWFS = false;
        this.parseWFS(data);
        // initialisation des headers une fois qu'ils sont connus
        this.initializeSorter();
        this.pageSizeInput.nativeElement.value = "";
      },
      error => {
        this.loadingWFS = false;
        console.log(error);
      }
    );
  }
}
