import { Component, OnInit } from '@angular/core';
import { Http } from "@angular/http";
import { ActivatedRoute } from '@angular/router';
import { Location } from '@angular/common';

@Component({
  selector: 'app-changes-by-thematic',
  templateUrl: './changes-by-thematic.component.html',
  styleUrls: ['./changes-by-thematic.component.css']
})
export class ChangesByThematicComponent implements OnInit {

  private baseUrl = 'http://localhost/services-webapp-magosm/'
  private list_ul = this.baseUrl + '/thematics';
  private changesList;
  private id; 

  constructor(
    public http: Http,
    private route: ActivatedRoute,
    private location: Location
  ) { }

  ngOnInit() {
    this.id = +this.route.snapshot.paramMap.get('id');
    let url = this.list_ul+'/'+this.id+'/points';
    this.http.get(url).subscribe(data => {
      // Read the result field from the JSON response.
      this.changesList = JSON.parse(data['_body']);
      console.log(this.changesList);
    })
  }

}
