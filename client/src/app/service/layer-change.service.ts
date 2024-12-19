import { Injectable, Output, EventEmitter } from '@angular/core';

@Injectable()
export class LayerChangeService {

  @Output() announceLayerChangeEvent: EventEmitter<any> = new EventEmitter();

  constructor( ) {}

  emitAnnounceLayerChangeEvent(newSelectedLayer) {
    this.announceLayerChangeEvent.emit(newSelectedLayer);
  }

  getAnnounceLayerChangeEventEmitter(): EventEmitter<any> {
    return this.announceLayerChangeEvent;
  }
}
