export class Color{
    R : number
    G : number
    B : number

    public getRGBA(): string{
        return "rgba("+this.R+","+this.G+","+this.B+")"
      }
}