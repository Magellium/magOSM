import {AfterViewInit, Directive, ElementRef, EventEmitter, Input, NgZone, OnDestroy, Output} from "@angular/core";
import { Subject} from "rxjs";
import { fromEvent } from "rxjs";
import { takeUntil, switchMap, map, buffer, debounceTime, filter} from "rxjs/operators";

@Directive({
  selector: '[draggable]'
})
export class DraggableDirective implements AfterViewInit, OnDestroy {

  @Input() dragHandle: string;
  @Input() dragTarget: string;

  @Output() doubleClick = new EventEmitter();

  // Element to be dragged
  private target: HTMLElement;
  // Drag handle
  private handle: HTMLElement;
  private delta = {x: 0, y: 0};
  private offset = {x: 0, y: 0};

  private destroy$ = new Subject<void>();

  constructor(private elementRef: ElementRef, private zone: NgZone) {
  }

  public ngAfterViewInit(): void {
    this.handle = this.dragHandle ? document.querySelector(this.dragHandle) as HTMLElement :
      this.elementRef.nativeElement;
      this.handle.style.cursor="move";
    this.target = document.querySelector(this.dragTarget) as HTMLElement;
    this.setupEvents();
  }

  public ngOnDestroy(): void {
    this.destroy$.next();
  }

  private setupEvents() {
    this.zone.runOutsideAngular(() => {
      let mousedown$ = fromEvent(this.handle, 'mousedown');
      let mousemove$ = fromEvent(document, 'mousemove');
      let mouseup$ = fromEvent(document, 'mouseup');
      let mouseclick$ = fromEvent(document, 'click');

      let mousedrag$ = mousedown$.pipe(
        switchMap((event: MouseEvent) => {
          let startX = event.clientX;
          let startY = event.clientY;

          return mousemove$.pipe(
            map((event: MouseEvent) => {
              event.preventDefault();
              this.delta = {
                x: event.clientX - startX,
                y: event.clientY - startY
              };
            }),
            takeUntil(mouseup$)
          )}),
        takeUntil(this.destroy$)
      );

      mouseclick$.pipe(
        takeUntil(this.destroy$),
        buffer(mouseclick$.pipe(debounceTime(150))),
        map(list => list.length),
        filter(x => x === 2)
      ).subscribe(() => {
        this.doubleClick.emit();
      });


      mousedrag$.subscribe(() => {
        if (this.delta.x === 0 && this.delta.y === 0) {
          return;
        }

        this.translate();
      });

      mouseup$.pipe(takeUntil(this.destroy$)).subscribe(() => {
        this.offset.x += this.delta.x;
        this.offset.y += this.delta.y;
        this.delta = {x: 0, y: 0};
      });
    });
  }

  private translate() {
    requestAnimationFrame(() => {
      this.target.style.transform = `
        translate(${this.offset.x + this.delta.x}px,
                  ${this.offset.y + this.delta.y}px)
      `;
    });
  }
}