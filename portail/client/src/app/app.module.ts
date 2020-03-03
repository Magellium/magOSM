import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';
import { RouterModule, Routes } from '@angular/router';
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
import { ChangesMainComponent } from './changes/changes-main/changes-main.component';
import { ChangesDetailledMapComponent } from './changes/changes-detailled-map/changes-detailled-map.component';
import { ChangeDetailsComponent } from './changes/change-details/change-details.component';
import { ChangesConfigPanelComponent } from './changes/changes-config-panel/changes-config-panel.component';
import { ChangesMapComponent } from './changes/changes-map/changes-map.component';
import { ChangesHeaderComponent } from './changes/changes-header/changes-header.component';
import { MyDateRangePickerModule } from 'mydaterangepicker';
import { ConfigService } from './service/config.service';
import { HelpComponent } from './help-components/help/help.component';
import { HelpChangeTypeComponent } from './help-components/help-subsection/help-subsection.component';
import { Ng5SliderModule } from 'ng5-slider';
import { LoadSpinnerComponent } from './utils/load-spinner/load-spinner.component';

// Define the routes
const ROUTES: Routes = [
  {
    path: '',
    redirectTo: '/carte',
    pathMatch: 'full',
  },
  { 
    path : 'changements-aide',
    component : HelpComponent,
    data : {title : 'Aide au suivi de changement'}
  },
  {
    path: 'carte',
    component: MainComponent,
    data: { title: 'Portail' }
  },
  {
    path: 'changements',
    component: ChangesMainComponent,
    data: { title: 'Suivi de changement' }
  },
  { path: '**', redirectTo: '/carte' },
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
    ChangesMainComponent,
    ChangesDetailledMapComponent,
    ChangeDetailsComponent,
    ChangesConfigPanelComponent,
    ChangesMapComponent,
    ChangesHeaderComponent,
    HelpComponent,
    HelpChangeTypeComponent,
    LoadSpinnerComponent,
  ],
  imports: [ 
    NguiAutoCompleteModule,
    BrowserModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule,
    RouterModule.forRoot(
      // [
      //   {
      //     path: 'carte',
      //     component: MainComponent
      //   }
      // ]
      ROUTES
      ),
    HttpModule,
    RouterModule.forRoot(ROUTES),
    MyDateRangePickerModule,
    Ng5SliderModule
  ],
  providers: [
    ConfigService,
    MapService,
    LayerChangeService, 
    UserContextService,
    {provide: LocationStrategy, useClass: HashLocationStrategy}
  ],
  bootstrap: [AppComponent],
})
export class AppModule { }
