import { TestBed, inject } from '@angular/core/testing';

import { NearbyFeaturesService } from './nearbyFeatures.service';

describe('NearbyFeaturesService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [NearbyFeaturesService]
    });
  });

  it('should be created', inject([NearbyFeaturesService], (service: NearbyFeaturesService) => {
    expect(service).toBeTruthy();
  }));
});
