
let getName n =
    n##name##text

let rec getVals n =
    let childVals =  match Js.Undefined.to_opt n##members with
        | None -> [||]
        | Some members -> Array.fold_left (fun vs m -> Array.append (getVals m) vs) [||] members
    in 
       Array.append [|getName n|] childVals 

let printNode n =
    let vals = getVals n in
    let singleStr = String.concat "\n" (Array.to_list vals) in
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
    
