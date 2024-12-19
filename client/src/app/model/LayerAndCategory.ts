import { Layer } from "./Layer";

export class LayerAndCategory {
  category:string;
  layer: Layer;

  constructor(category: string, layer: Layer){
    this.category = category;
    this.layer = layer;
  }
}