type buffer
external readFileSync :
    string -> buffer = "readFileSync" [@@bs.module "fs"]

external argv : string array = "process.argv" [@@bs.val]

external bufferToStr : buffer -> string = "toString" [@@bs.send]

