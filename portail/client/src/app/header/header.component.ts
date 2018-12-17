import { Component, OnInit, Input } from '@angular/core';

import { Router } from '@angular/router';
import {Observable} from 'rxjs';

declare var config: any;

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.css']
})
export class HeaderComponent implements OnInit {

  ngOnInit() {
  }


  constructor( public router: Router) {
    
  }


}
