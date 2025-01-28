import { Component, OnInit } from '@angular/core';
import { UserContextService } from '../service/user-context.service';

@Component({
  selector: 'app-permalink',
  templateUrl: './permalink.component.html',
  styleUrls: ['./permalink.component.css']
})
export class PermalinkComponent implements OnInit {

  constructor(
    public userContextService: UserContextService
  ) { }

  ngOnInit() {
  }

  setPermalink(){
    this.userContextService.setPermalink()
  }
}
