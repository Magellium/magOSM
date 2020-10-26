import { ElementRef, Injectable } from '@angular/core';


@Injectable({
  providedIn: 'root'
})
export class PaginationService {

    public static UNSORTED : number = 0;
    public static SORT_ASC : number = 1;
    public static SORT_DESC : number = -1;
    
    // les données du tableau
    public data : Array<any>;

    // index de la page ( 0........ n)
    public pageIndex: number = 0;
    public pageSize: number = 10;
    public totalElement: number = 0;
    // public totalPages: number = 0;

    public sorter : Array<any> = [] ;

    public pageSizeArray : Array<any> = [10,20,50];

    // barre de navigation des pages
    // indicateur entre 1 .......n (donc différents de pageIndex)
    public previousPage : ElementRef;
    public pageItem1 : ElementRef;
    public pageItem2 : ElementRef;
    public pageItem3 : ElementRef;
    public nextPage : ElementRef;
    public numberPerPage : ElementRef;
    public rangePage: ElementRef; 
    
    constructor() { }

    initializePagination() {
        this.setPageIndex(0);
        this.setPageSize(0);
        this.setTotalElement(0);
    }

    public initializeElementRef(previousPage : ElementRef, pageItem1 : ElementRef, pageItem2 : ElementRef, pageItem3 : ElementRef, 
                      nextPage : ElementRef, numberPerPage : ElementRef, rangePage: ElementRef){
        if (!this.previousPage){
            this.previousPage = previousPage;
            this.pageItem1 = pageItem1;
            this.pageItem2 = pageItem2;
            this.pageItem3 = pageItem3;
            this.nextPage = nextPage;
            this.numberPerPage = numberPerPage;
            this.rangePage = rangePage;
        }
    }

    public setData (data : Array<any>){
        this.data = data;
    }

    public setPageSize (pageSize : number){
        this.pageSize = pageSize;
        // on relance la requête de chargement du tableau
        this.actualizePagination();
    }
    public getPageSize (): number{
        return this.pageSize;
    }
    
    public getPageSizeArray (): Array<number>{
        return this.pageSizeArray;
    }
    
    public setPageIndex (pageIndex : number){
        this.pageIndex  = pageIndex;
        // on relance la requête de chargement du tableau
        this.pageIndex = this.pageIndex > this.getLastPageIndex()-1 ? (this.getLastPageIndex()-1 > 0 ? this.getLastPageIndex()-1 : 0) : this.pageIndex;
        this.actualizePagination();
        console.log(" => Allez à la page : " + (this.getPageIndex()));
        this.setHighLight();
    }

    public getPageIndex() : number{
        return this.pageIndex;
    }
    public setTotalElement(totalElement: number){
        this.totalElement = totalElement;
    }
    public getTotalElement(): number{
        return this.totalElement;
    }

    public setSort(headerKey : string, dir : number){
        this.sorter[headerKey] = dir;

    }
    public getSort() : Array<any>{
       return  this.sorter;
    }

    public setSortColumn(headerKey : string) : number{
        let sorterDir = this.sorter[headerKey];

        if (sorterDir === PaginationService.UNSORTED){
        sorterDir = PaginationService.SORT_ASC;
        } else if (sorterDir === PaginationService.SORT_ASC){
        sorterDir = PaginationService.SORT_DESC;
        } else {
        sorterDir = PaginationService.UNSORTED;
        }

        Object.keys(this.sorter).forEach(element => {
        this.setSort(element, PaginationService.UNSORTED);
        });
        
        this.setSort(headerKey, sorterDir);
        
        return sorterDir;
    }


    goToPreviousPage(){
        let previousPage = this.getPageIndex() -1;
        previousPage = (previousPage>=0?previousPage:0);
        this.setPageIndex(previousPage);      
    }

    goToNextPage(){
        let nextPage = this.getPageIndex() + 1;
        this.setPageIndex(nextPage);
    }

    resetPageIndex() {
        this.setPageIndex(0);
        this.setTotalElement(0);
        this.actualizeButtonPagination();
    }
    
    resetPagination(){
        this.previousPage = null;
        this.pageItem1 = null;
        this.pageItem2 = null;
        this.pageItem3 = null;
        this.nextPage = null;
        this.rangePage = null;
    }

    public actualizePagination(){
        // si les éléments sur initialisés dans l'IHM, on met à jour la pagination
        if (this.previousPage){
            this.actualizeButtonPagination();
            this.actualizeRangePage();
        }
    }

    public actualizeButtonPagination(){
        if (this.previousPage){
        
            let pageArray = [1, 2, 3];
                
            this.previousPage.nativeElement.parentElement.classList.remove('disabled'); 
            this.nextPage.nativeElement.parentElement.classList.remove('disabled'); 
            this.pageItem1.nativeElement.parentElement.classList.remove('disabled');   
            this.pageItem2.nativeElement.parentElement.classList.remove('disabled');  
            this.pageItem3.nativeElement.parentElement.classList.remove('disabled');  

            if (this.getPageIndex()==0){
                this.previousPage.nativeElement.parentElement.classList.add('disabled'); 
            } else if (this.getPageIndex() >= this.getLastPageIndex()){
                this.nextPage.nativeElement.parentElement.classList.add('disabled'); 
                if (this.getPageIndex()>2){
                    pageArray=[this.getPageIndex()-1, this.getPageIndex(), this.getPageIndex()+1];    
                } 
            } else if (this.getPageIndex() == this.getLastPageIndex()-1 ){        
                pageArray=[this.getPageIndex()-1, this.getPageIndex(), this.getPageIndex()+1];    
            } else {            
                pageArray=[this.getPageIndex(), this.getPageIndex()+1, this.getPageIndex()+2];    
            }
            
            this.pageItem1.nativeElement.innerText = pageArray[0];
            this.pageItem2.nativeElement.innerText = pageArray[1];
            this.pageItem3.nativeElement.innerText = pageArray[2];

            if (pageArray[0] > (this.getLastPageIndex())){
                this.pageItem1.nativeElement.parentElement.classList.add('disabled'); 
            }
            if (pageArray[1] > (this.getLastPageIndex())){
                this.pageItem2.nativeElement.parentElement.classList.add('disabled'); 
            }
            if (pageArray[2] > (this.getLastPageIndex())){
                this.pageItem3.nativeElement.parentElement.classList.add('disabled');  
            }
            if (pageArray[0] == 1 ){
                this.previousPage.nativeElement.parentElement.classList.add('disabled'); 
            }
            if (pageArray[2] >= this.getLastPageIndex() ){
                this.nextPage.nativeElement.parentElement.classList.add('disabled');  
            }                
        }
    }
    
    public actualizeRangePage(){
        this.rangePage.nativeElement.innerText = "Pas de données";
        if (this.data && this.data.length>0){
            let fisrtRangeElement = this.getPageIndex() * parseInt(this.numberPerPage.nativeElement.value) ;
            let lastRangeElement = fisrtRangeElement+1 +  + parseInt( this.numberPerPage.nativeElement.value); 
            lastRangeElement = (lastRangeElement > this.getTotalElement() ? this.getTotalElement():lastRangeElement);
            
            this.rangePage.nativeElement.innerText = (fisrtRangeElement+1) + " - " + lastRangeElement +" sur " + this.getTotalElement() ;
        } 
    }

    public getLastPageIndex(){
        let nberPerPage = this.numberPerPage? parseInt(this.numberPerPage.nativeElement.value): this.pageSizeArray[0];
        let lastPageIndex = Math.round( this.getTotalElement() / nberPerPage );
        if ( this.getTotalElement() - (Math.round(this.getTotalElement() / nberPerPage) * nberPerPage)>0){
            lastPageIndex += 1;
        } 

        return lastPageIndex;
    }

    public setHighLight(){
        if (this.previousPage){
            let buttons = document.getElementsByClassName('page-link');

            // on supprime la précédente surbrillance
            for (var i = 0; i < buttons.length; i++) {
                buttons[i].classList.remove('active');
            }

            if (this.getPageIndex()==0){
                buttons[1].classList.add('active');
            } else if (this.getPageIndex() == this.getLastPageIndex()-1){
                buttons[3].classList.add('active');
            } else{            
                buttons[2].classList.add('active');  
            }
        }
    }
}