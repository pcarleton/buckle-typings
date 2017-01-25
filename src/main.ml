
let getName n =
    n##name##text

let rec getVals n =
    let childVals =  match Js.Undefined.to_opt n##members with
        | None -> [||]
        | Some members -> Array.fold_left (fun vs m -> Array.append (getVals m) vs) [||] members
    in 
       Array.append [|getName n|] childVals 

let string_repeat s n =
      String.concat "" (Array.to_list (Array.make n s))

module Line = struct
    type t = { text: string; level : int}

    let nest n v =
        {text=v; level=n}

    let toVal : t -> string = fun l -> 
        let spaces = string_repeat "    " l.level  in
            spaces ^ l.text

end


let getEnumPrinterFn n nestNum modName =
    let rawType = "type rawEnum" in
    let name = getName n in
    let modExt = "[@@bs.module \"" ^ modName ^ "\"]" in
    let valExt = "[@@bs.val]" in
    let extDecl = "external enum : rawEnum = \"" ^ name ^ "\"" in
    let rawDeclText = String.concat " " [extDecl; modExt; valExt] in
    
    let convDecl = "external _getName" in
    let convTypeDecl = ": rawEnum -> t -> string" in
    let convVal = "= \"\" [@@bs.get_index]" in
    let convText = String.concat " " [convDecl; convTypeDecl; convVal] in 

    let fnDecl = "let getName tv = _getName enum tv" in
    List.map (Line.nest nestNum) [rawType; rawDeclText; convText; fnDecl]

let makeVariant typeName names nestNum =
    let typeDecl = "type " ^ typeName ^ " =" in
    let varNest = nestNum + 1 in 
    let varLine name = Line.nest varNest ("| " ^ name) in
    let varLines = List.map varLine names in
    (Line.nest nestNum typeDecl) :: varLines


let printEnumNode n nestNum modName =
    let enumName = getName n in
    let modOpen = "module " ^ enumName ^ " = struct" in
    let endToken = "end" in
    let childNames =  match Js.Undefined.to_opt n##members with
        | None -> [] 
        | Some members -> List.map getName (Array.to_list members)
    in
    let modNest = nestNum + 1 in
    let variantLines = makeVariant "t" childNames modNest in
    let printerFn = getEnumPrinterFn n modNest modName in
    let prelude = [Line.nest nestNum modOpen] in
    let endLine = [Line.nest nestNum endToken] in
    List.concat [prelude; variantLines; printerFn; endLine]


let printNode n =
    let enumStrs = printEnumNode n 0 "typescript" in
    let lineStrs = List.map Line.toVal enumStrs in
    let singleStr = String.concat "\n" lineStrs  in
    Js.log singleStr


type buffer
external readFileSync : string -> buffer = "readFileSync" [@@bs.module "fs"]
external bufferToStr : buffer -> string = "toString" [@@bs.send]

let () =
    let path = "test/enum-small.d.ts" in
    let txt = bufferToStr ( readFileSync path) in 
    (* The file path doesn't seem important for this use case so far*)
    (* TODO: Make a declaration for this enum *)
    let scriptTarget = 1 in
    let obj = Typescript.createSourceFile path txt scriptTarget false in
    let statements = obj##statements in
    let statement = statements.(0) in
    printNode statement
    (* Array.iter (fun s -> Js.log s##kind) statements *)
    
