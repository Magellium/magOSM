import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ChangesMapComponent } from './changes-map.component';

describe('ChangesMapComponent', () => {
  let component: ChangesMapComponent;
  let fixture: ComponentFixture<ChangesMapComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ChangesMapComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ChangesMapComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
