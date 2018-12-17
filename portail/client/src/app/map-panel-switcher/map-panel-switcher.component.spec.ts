import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MapPanelSwitcherComponent } from './map-panel-switcher.component';

describe('MapPanelSwitcherComponent', () => {
  let component: MapPanelSwitcherComponent;
  let fixture: ComponentFixture<MapPanelSwitcherComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MapPanelSwitcherComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MapPanelSwitcherComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should be created', () => {
    expect(component).toBeTruthy();
  });
});
