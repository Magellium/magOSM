import { MapService } from "app/service/map.service";
import { Layer } from "./Layer";
import { environment } from '../../environments/environment';
import { FeatureAttributeTableComponent } from "app/feature-attribute-table/feature-attribute-table.component";
import { PaginationService } from "app/service/pagination.service";




export class WFSRequest {


    public currentFeature: Layer;
    public sorterColumn : string;
    public sorterDirection : number;
    public count : number;
    public startIndex : number;

    constructor(
        public mapService: MapService) {

    }

    public setFeature(feature){
        this.currentFeature = feature;
    }

    public setSorter(column : string, direction : number){
        this.sorterColumn = column;
        this.sorterDirection = direction;
    }

    public setCount(count : number){
        this.count = count;
    }
    public setStartIndex(startIndex : number){
        this.startIndex = startIndex;
    }

    public getCount(): number{
        return this.count;
    }
    public getStartIndex(): number{
        return this.startIndex;
    }

    public setRangeRequest(pageSize : number, startIndex : number){
        this.count = pageSize;
        this.startIndex = startIndex;
    }

    build() :string {
        let url: string;
        let urlservice = environment.geoserver_baseurl + '/ows?service=wfs&version=2.0.0&request=GetFeature';
        var searchMask = "getCapabilities";
        var regEx = new RegExp(searchMask, "ig");
        var replaceMask = "GetFeature";

        urlservice = urlservice.replace(regEx, replaceMask);
        let outputformat = "application/json";

        url = urlservice;
        
        if (this.count && this.startIndex){
            url += '&count='+ this.getCount() + '&startIndex='+this.getStartIndex();
        } else{
            url += '&maxfeatures=5000&count=10';
        } 
        url +='&typename=' + this.currentFeature.layername + '&outputFormat=' + outputformat + '&srsname=EPSG:3857';
       
        let extent = this.mapService.getBoundingBoxCorner();
        
        url += "&bbox=" + extent.join(',') + ',EPSG:3857'

        // sorter column
        if (this.sorterColumn && this.sorterDirection){
            url += "&sortBy="+this.sorterColumn+(this.sorterDirection===PaginationService.SORT_DESC? "+D":"");
        }

        // filter : Evolution : ajouter un filtre en entête de colonne  
        /*if(layerconfig.filter){ 
          url+="&CQL_FILTER=BBOX("+layerconfig.getGeomAttributeName()+","+extent.join(',')+",'EPSG:3857') AND "+layerconfig.filter;
        }
        else{
          */
        console.log(url);

        return url;
    }

}