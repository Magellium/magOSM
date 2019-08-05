import { Component, AfterViewInit, OnInit } from '@angular/core';
import { Router, NavigationEnd } from '@angular/router';
import { ApiRequestService } from 'app/service/api-request.service';
import { ChangeType } from 'app/model/ChangesClasses/ChangeType';
import { Color } from 'app/model/ChangesClasses/Color';

declare var $;

@Component({
  selector: 'app-help',
  templateUrl: './help.component.html',
  styleUrls: ['./help.component.css']
})
export class HelpComponent implements OnInit, AfterViewInit {

  public changeTypesList : Array<ChangeType>
  constructor(
    router: Router,
    public apiRequestService : ApiRequestService) {
    /* Lorsque le composant est chargé depuis une URL contenant une ancre :
    * - l'élément du DOM avec l'id correspondant à l'ancre n'est pas encore chargé
    * - on attend donc la fin de la navigation pour scroller jusqu'à l'ancre
    */
    router.events.subscribe(s => {
      if (s instanceof NavigationEnd) {
        const tree = router.parseUrl(router.url);
        if (tree.fragment) {
          const element = document.querySelector("#" + tree.fragment);
          if (element) { element.scrollIntoView(true); }
        }
      }
    });
  }
  ngOnInit(){
    this.apiRequestService.searchChangeTypes().subscribe(data => {
      this.changeTypesList = JSON.parse(data['_body']) as Array<ChangeType>;
      console.log(this.changeTypesList);
    })
  }

  ngAfterViewInit() {
    /* on ne déclare le scrollspy qu'une fois que le template est initialisé */
    $(document).ready(() => {
      $('body').scrollspy({target: "#navbar-example3", offset: 50});   
    });


    /* rustine pour que la navbar de Bootstrap cohabitent avec Angular et sa gestion des href :
    * - Bootstrap a besoin d'une href correspondant à une ancre (ex: href="#umap")
    * - Angular a besoin d'un chemin complet pour suivre un lien (ex: aide.html#umap)
    * ==> on conserve le format qui va bien à Bootstrapau au
    * ==> clic sur un élément du menu, on stop la navigation native d'Angular pour scroller vers l'ancre
    */
    $(".nav-link").click(function(event) {
      event.preventDefault();
      let fragment = event.target.hash;
      const element = document.querySelector(fragment);
      if (element) { element.scrollIntoView(true); }
        });

  }

  public getColorForRef(ref : string) : string{
    let color : Color = this.changeTypesList.filter(x => x.ref === ref)[0].color;
    return "rgba("+color.R+","+color.G+","+color.B+")";
  }


}
