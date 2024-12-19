import { Color } from "./Color";

export class ChangeType{
    id : number
    ref : string
    name : string
    short_name : string
    label : string
    color : Color //hstore

    get relatedColor(): Color{
        return new Color(this.color);
    }
    constructor(data: any) {
        Object.assign(this, data);
      }
}