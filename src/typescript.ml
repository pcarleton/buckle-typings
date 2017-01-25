
module SyntaxKind = struct
    type t 
end 

class type _identifier = object
    method text: string
end [@bs]

type identifier = _identifier Js.t

class type _node = object
    method kind: SyntaxKind.t
    method members: _node Js.t array Js.Undefined.t
    method name: identifier
end [@bs]

type node = _node Js.t

class type _sourceFileObject = object
  method text: string
  method statements: node array
end [@bs]

type sourceFileObject = _sourceFileObject Js.t
external createSourceFile :
  string -> string -> int-> bool -> sourceFileObject =
  "createSourceFile" [@@bs.module "typescript"]
