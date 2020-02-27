import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ChangesDetailledMapComponent } from './changes-detailled-map.component';

describe('ChangesDetailledMapComponent', () => {
  let component: ChangesDetailledMapComponent;
  let fixture: ComponentFixture<ChangesDetailledMapComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ChangesDetailledMapComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ChangesDetailledMapComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
