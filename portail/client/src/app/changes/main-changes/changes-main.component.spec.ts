import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ChangesMainComponent } from './changes-main.component';

describe('ChangesMainComponent', () => {
  let component: ChangesMainComponent;
  let fixture: ComponentFixture<ChangesMainComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ChangesMainComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ChangesMainComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
