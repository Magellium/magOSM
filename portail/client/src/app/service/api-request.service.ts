import { Injectable } from '@angular/core';
import { throwError as observableThrowError, Observable} from 'rxjs';
import { Http } from '@angular/http';
import { catchError } from 'rxjs/operators';
import { Thematic } from 'app/model/ChangesClasses/Thematic';
import { ConfigService } from './config.service';
import 'rxjs/add/observable/fromPromise';
import 'rxjs/add/operator/mergeMap'
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class ApiRequestService {

  private baseUrl : string ;
  private thematicsSuffix =  'thematics';
  private changesSuffix = 'changesrequest';
  private changeTypesSuffix = 'change_types';
  private featurechangesSuffix = 'featurechangesrequest';
  private lastChangeSuffix ='lastpolygonchanged';
  public beginDate : Date;
  public endDate : Date;
  public thematic : Thematic;

  private configPromise: Promise<any>;

  constructor(
    public http: Http,
    public configService : ConfigService) 
    { 
      this.configPromise = this.configService.getConfig().toPromise().then(config => {
        this.baseUrl = environment.services_baseurl;
        return config;
    });
    }

  public searchThematics(): Observable<any> {
    return Observable.fromPromise(this.configPromise).mergeMap((config) => {
      return this.http.get(this.baseUrl + this.thematicsSuffix)
    });
  };

  public getLastChange(): Observable<any> {
    return Observable.fromPromise(this.configPromise).mergeMap((config) => {
      return this.http.get(this.baseUrl + this.lastChangeSuffix)
    });
  };

  public searchChanges(data, options): Observable<any> {
    return Observable.fromPromise(this.configPromise).mergeMap((config) => {
      return this.http.post(this.baseUrl+this.changesSuffix, data, options).pipe(
        catchError(error => observableThrowError(error))
      )
    });
  };

  public searchChangeTypes(): Observable<any> {

    return Observable.fromPromise(this.configPromise).mergeMap((config) => {
      return this.http.get(this.baseUrl + this.changeTypesSuffix);
    });
  }

  public searchFeatureChanges(data, options) : Observable<any> {
    return Observable.fromPromise(this.configPromise).mergeMap((config) => {
      return this.http.post(this.baseUrl+this.featurechangesSuffix, data, options).pipe(
        catchError(error => observableThrowError(error))
      )
    });
  };
}
