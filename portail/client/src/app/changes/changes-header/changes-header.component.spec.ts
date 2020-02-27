import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ChangesHeaderComponent } from './changes-header.component';

describe('ChangesHeaderComponent', () => {
  let component: ChangesHeaderComponent;
  let fixture: ComponentFixture<ChangesHeaderComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ChangesHeaderComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ChangesHeaderComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
