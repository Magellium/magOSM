import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ChangesByThematicComponent } from './changes-by-thematic.component';

describe('ChangesByThematicComponent', () => {
  let component: ChangesByThematicComponent;
  let fixture: ComponentFixture<ChangesByThematicComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ChangesByThematicComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ChangesByThematicComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
