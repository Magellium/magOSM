import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ChangesConfigPanelComponent } from './changes-config-panel.component';

describe('ChangesConfigPanelComponent', () => {
  let component: ChangesConfigPanelComponent;
  let fixture: ComponentFixture<ChangesConfigPanelComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ChangesConfigPanelComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ChangesConfigPanelComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
