import { Injectable } from '@angular/core';
import { throwError as observableThrowError, Observable} from 'rxjs';
import { Http } from '@angular/http';
import { catchError } from 'rxjs/operators';
import { Thematic } from 'app/model/ChangesClasses/Thematic';
import { resolve } from 'dns';
import { ConfigService } from './config.service';

declare var config : any;

@Injectable({
  providedIn: 'root'
})
export class ApiRequestService {

  private baseUrl : string ;
  private thematicsSuffix =  'thematics';
  private changesSuffix = 'changesrequest';
  private changeTypesSuffix = 'change_types';
  private featurechangesSuffix = 'featurechangesrequest';
  public beginDate : Date;
  public endDate : Date;
  public thematic : Thematic;
  public obs = new Observable<any>(res => {
    res.next(config);
  })

  constructor(
    public http: Http,
    public configService : ConfigService) 
    { 
      this.configService.getConfig().subscribe(config => {
        this.baseUrl = config.WEBAPP_BASE_URL;
      }) 
    }

  public searchThematics(): Observable<any> {
    console.log(this.baseUrl);
    console.log(config);
    return this.http.get(this.baseUrl + this.thematicsSuffix)
  };

  public searchChanges(data, options): Observable<any> {
    return this.http.post(this.baseUrl+this.changesSuffix, data, options).pipe(
      catchError(error => observableThrowError(error))
    )
  };

  public searchChangeTypes(): Observable<any> {
    return this.http.get(this.baseUrl + this.changeTypesSuffix)
  };

  public searchFeatureChanges(data, options) : Observable<any> {
    return this.http.post(this.baseUrl+this.featurechangesSuffix, data, options).pipe(
      catchError(error => observableThrowError(error))
    )
  };
}
