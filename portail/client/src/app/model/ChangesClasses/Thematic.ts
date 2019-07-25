import { ThematicCategory } from "./ThematicCategory";

export class Thematic {
    name:string;
    id:number;
    changesRequest:string;
    category:ThematicCategory;
  
    constructor(name : string ,id : number, changesRequest : string, category:ThematicCategory){
      this.name= name;
      this.id = id;
      this.changesRequest = changesRequest;
      this.category = category;
    }

    public getName() : string {
        return this.name;
    }
  }