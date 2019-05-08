export class KeyLabelObject {
  key:string;
  label:string;

  constructor(keyLabel){
    this.key = keyLabel.osm_key;
    this.label = keyLabel.label;
  }
}