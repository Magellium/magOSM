import { Component, OnInit, ViewChild } from '@angular/core';
import { Http } from "@angular/http";
import { ActivatedRoute } from '@angular/router';
import { Location } from '@angular/common';

@Component({
  selector: 'app-change-details',
  templateUrl: './change-details.component.html',
  styleUrls: ['./change-details.component.css']
})
export class ChangeDetailsComponent implements OnInit {

  private baseUrl = 'http://localhost/services-webapp-magosm/'
  private change;
  private change_id;

  public init: boolean = false;

  constructor(
    public http: Http,
    private route: ActivatedRoute,
    private location: Location
  ) { }

  ngOnInit() {
    this.change_id = +this.route.snapshot.paramMap.get('change_id');
    let url = this.baseUrl+'changedpoints/'+this.change_id;
    this.http.get(url).subscribe(data => {
      // Read the result field from the JSON response.
      this.change = JSON.parse(data['_body']);
      console.log(this.change);
      this.init = true;
    })
  }

}
