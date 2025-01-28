import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { PermalinkComponent } from './permalink.component';

describe('PermalinkComponent', () => {
  let component: PermalinkComponent;
  let fixture: ComponentFixture<PermalinkComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ PermalinkComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(PermalinkComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
