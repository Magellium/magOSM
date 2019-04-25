import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { FeatureMainInfoComponent } from './feature-main-info.component';

describe('FeatureMainInfoComponent', () => {
  let component: FeatureMainInfoComponent;
  let fixture: ComponentFixture<FeatureMainInfoComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ FeatureMainInfoComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(FeatureMainInfoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
