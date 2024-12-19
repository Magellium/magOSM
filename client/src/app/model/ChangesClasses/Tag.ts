export class Tag{
    key : string;
    valueNew? : string;
    valueOld? : string;

    constructor(key : string, valueNew, valueOld){
        this.key = key;
        this.valueNew = valueNew;
        this.valueOld = valueOld;
    }
}