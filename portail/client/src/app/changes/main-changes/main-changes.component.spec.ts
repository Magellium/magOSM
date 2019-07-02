import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MainChangesComponent } from './main-changes.component';

describe('MainChangesComponent', () => {
  let component: MainChangesComponent;
  let fixture: ComponentFixture<MainChangesComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MainChangesComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MainChangesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
