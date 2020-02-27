export class Change{
    osmId : number
    id : number
    changeType:number
    tagsNew
    tagsOld
    timestamp: string
    versionNew : number
    versionOld : number
    type : string
    theGeomNew
    theGeomOld

    constructor(){};
}