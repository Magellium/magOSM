export class Color{
    R : string
    G : string
    B : string

    public getRGBA(): string{
      return "rgba("+this.R+","+this.G+","+this.B+")"
    }

    constructor(data: any) {
      Object.assign(this, data);
    }

}