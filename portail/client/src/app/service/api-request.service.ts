import { Injectable } from '@angular/core';
import { throwError as observableThrowError, Observable} from 'rxjs';
import { Http } from '@angular/http';
import { catchError } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class ApiRequestService {

  private baseUrl = 'http://localhost/services-webapp-magosm/';
  private thematicsSuffix =  'thematics';
  private changesSuffix = 'changesrequest';
  private changeTypesSuffix = 'change_types';
  private featurechangesSuffix = 'featurechangesrequest';
  public beginDate : Date;
  public endDate : Date;
  public thematic : number;

  constructor(public http: Http) { }

  public searchThematics(): Observable<any> {
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
