import { Injectable } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class ConfigService {

  private configUrl: string = "./assets/maps/";

  constructor(
    private route: ActivatedRoute,
    private http: HttpClient
  ) { }

  getConfig() {
    // now returns an Observable of Config
    var conf=this.route.snapshot.queryParams['config'];
    if(conf==undefined){
      conf="default.json"
    }
    return this.http.get<any>(this.configUrl+conf);
  }
}
