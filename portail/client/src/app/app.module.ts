import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';
import { RouterModule } from '@angular/router';
import { HashLocationStrategy, LocationStrategy } from '@angular/common';
import { NguiAutoCompleteModule } from '@ngui/auto-complete';
import { ApiAdresseComponent } from './apiadresse/apiadresse.component';
import { AppComponent } from './app/app.component';
import { FeaturePanelComponent } from './feature-panel/feature-panel.component';
import { MainComponent } from './main/main.component';
import { HeaderComponent } from './header/header.component';
import { MapComponent } from './map/map.component';
import { MapPanelSwitcherComponent } from './map-panel-switcher/map-panel-switcher.component';
import { LegendComponent } from './map-panel-switcher-components/legend/legend.component';
import { MapControllerComponent } from './map-panel-switcher-components/map-controller/map-controller.component';
import { LayerTreeComponent } from './map-panel-switcher-components/layer-tree/layer-tree.component';
import { OrderByPipeComponent } from './orderbypipe/orderbypipe.component';
import { LayerChangeService } from './service/layer-change.service';
import { MapService } from './service/map.service';
import { PermalinkComponent } from './permalink/permalink.component';
import { UserContextService } from './service/user-context.service';
import { HttpClientModule } from '@angular/common/http';
import { FeatureMainInfoComponent } from './feature-panel-components/feature-main-info/feature-main-info.component';
import { MainChangesComponent } from './changes/main-changes/main-changes.component';
import { ChangesMapComponent } from './changes/changes-map/changes-map.component';
import { ChangesByThematicComponent } from './changes/changes-by-thematic/changes-by-thematic.component';
import { ChangeDetailsComponent } from './changes/change-details/change-details.component';

// Define the routes
const ROUTES = [
  {
    path: 'changements',
    component: MainChangesComponent,
    data: { title: 'Suivi de changement' }
  },
  {
    path: 'changements/:id',
    component : ChangesByThematicComponent,
  }, 
  {
    path: 'changements/:id/:change_id',
    component : ChangeDetailsComponent,
  },
  {
    path: '',
    redirectTo: '/carte',
    pathMatch: 'full',
    data: { title: 'Portail'}
  },
];

@NgModule({
  declarations: [
    ApiAdresseComponent,
    AppComponent,
    FeaturePanelComponent,
    MainComponent,
    HeaderComponent,
    MapComponent,
    MapPanelSwitcherComponent,
    LegendComponent,
    MapControllerComponent,
    LayerTreeComponent,
    OrderByPipeComponent,
    PermalinkComponent,
    FeatureMainInfoComponent,
    MainChangesComponent,
    ChangesMapComponent,
    ChangesByThematicComponent,
    ChangeDetailsComponent,
  ],
  imports: [ 
    NguiAutoCompleteModule,
    BrowserModule,
    FormsModule,
    HttpClientModule,
    RouterModule.forRoot([
        {
          path: 'carte',
          component: MainComponent
        }
      ]),
    HttpModule,
    RouterModule.forRoot(ROUTES)
  ],
  providers: [
    MapService,
    LayerChangeService, 
    UserContextService,
    {provide: LocationStrategy, useClass: HashLocationStrategy}
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
