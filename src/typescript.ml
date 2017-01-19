type sourceFileObject
external createSourceFile :
    string -> string -> int-> bool -> sourceFileObject =
        "createSourceFile" [@@bs.module "typescript"]
