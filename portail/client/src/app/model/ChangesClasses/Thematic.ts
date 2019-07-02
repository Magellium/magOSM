export class Thematic {
    name:string;
    id:number;
    changesRequest:string;
  
    constructor(name : string ,id : number, changesRequest : string){
      this.name= name;
      this.id = id;
      this.changesRequest = changesRequest;
    }

    public getName() : string {
        return this.name;
    }
  }