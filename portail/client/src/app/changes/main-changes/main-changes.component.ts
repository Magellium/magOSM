import { Component, OnInit } from '@angular/core';
import { Http, RequestOptions, Request, RequestMethod, Headers } from '@angular/http';
import { Thematic } from '../../model/ChangesClasses/Thematic'

@Component({
  selector: 'app-main-changes',
  templateUrl: './main-changes.component.html',
  styleUrls: ['./main-changes.component.css']
})
export class MainChangesComponent implements OnInit {

  private baseUrl = 'http://localhost/services-webapp-magosm/';
  private list_ul = this.baseUrl + '/thematics';
  private list : Array<Thematic>;


  constructor(public http: Http) { }

  ngOnInit() {
    this.http.get(this.list_ul).subscribe(data => {
      // Read the result field from the JSON response.
      this.list = JSON.parse(data['_body']);
      console.log(this.list);
    })
  }
}
