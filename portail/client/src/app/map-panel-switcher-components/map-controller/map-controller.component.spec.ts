import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MapControllerComponent } from './map-controller.component';

describe('MapControllerComponent', () => {
  let component: MapControllerComponent;
  let fixture: ComponentFixture<MapControllerComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MapControllerComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MapControllerComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should be created', () => {
    expect(component).toBeTruthy();
  });
});
