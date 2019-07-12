export class Change{
    osm_id : number //BigInt !!
    id : number
    change_type:number
    tags_new
    tags_old
    timestamp: String
    version_new : number
    version_old : number
    type : String
    the_geom_new
    the_geom_old
}