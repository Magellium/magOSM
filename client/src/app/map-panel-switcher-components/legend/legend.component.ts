import { Component, Input, OnInit } from '@angular/core';

declare var $: any;

@Component({
  selector: 'app-legend',
  templateUrl: './legend.component.html',
  styleUrls: ['./legend.component.css']
})
export class LegendComponent implements OnInit {

  @Input() public legendUrls: string[];
  @Input() public legendSubTitles: string[];
  @Input() public legendTitle: string;
  @Input() public currentScale;

  constructor() { }

  ngOnInit() {
  }

  ngAfterViewInit() {
      //$("#accordionLegend").draggable({cancel:"#legendContainer"});
      $("#menu-close").click(function(e) {
        e.preventDefault();
        $("#sidebar-wrapper").toggleClass("active");
      });
      $("#menu-toggle").click(function(e) {
        e.preventDefault();
        $("#sidebar-wrapper").toggleClass("active");
      });      
  }

}
