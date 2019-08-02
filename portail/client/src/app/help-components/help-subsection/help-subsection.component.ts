import { Component, OnInit, Input } from '@angular/core';

@Component({
  selector: 'app-help-subsection',
  templateUrl: './help-subsection.component.html',
  styleUrls: ['./help-subsection.component.css']
})
export class HelpChangeTypeComponent{

  @Input() header : string;
  @Input() content : string;
  @Input() ref : string;
  constructor() { }

}
