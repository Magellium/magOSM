import { TestBed, inject } from '@angular/core/testing';

import { ApiRequestService } from './api-request.service';

describe('ApiRequestService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [ApiRequestService]
    });
  });

  it('should be created', inject([ApiRequestService], (service: ApiRequestService) => {
    expect(service).toBeTruthy();
  }));
});
