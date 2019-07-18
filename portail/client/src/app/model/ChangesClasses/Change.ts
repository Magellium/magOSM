export class Change{
    osmId : number
    id : number
    changeType:number
    tagsNew : Map<string, string>
    tagsOld : Map<string, string>
    timestamp: string
    versionNew : number
    versionOld : number
    type : string
    theGeomNew
    theGeomOld

    constructor(){};
}