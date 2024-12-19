/* tslint:disable:no-unused-variable */
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { DebugElement } from '@angular/core';

import { ApiAdresseComponent } from './apiadresse.component';

describe('ApiAdresseComponent', () => {
  let component: ApiAdresseComponent;
  let fixture: ComponentFixture<ApiAdresseComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ApiAdresseComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ApiAdresseComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
