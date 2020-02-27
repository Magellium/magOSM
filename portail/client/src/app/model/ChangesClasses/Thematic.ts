import { ThematicCategory } from "./ThematicCategory";

export class Thematic {
    name:string;
    viewName : string
    id:number;
    changesRequest:string;
    category:ThematicCategory;
  
    constructor(name : string, viewName : string, id : number, changesRequest : string, category:ThematicCategory){
      this.name= name;
      this.viewName = viewName;
      this.id = id;
      this.changesRequest = changesRequest;
      this.category = category;
    }

    public getName() : string {
        return this.name;
    }

    public getViewName() : string {
      return this.viewName
    }
  }