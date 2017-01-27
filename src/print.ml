
let getKind n =
   Typescript.SyntaxKind.getName n##kind 

let walk n fn =
    let baseList = [|fn n|] in
    let childVals =  match Js.Undefined.to_opt n##members with
        | None -> [||]
        | Some members -> Array.map fn members
    in
    Array.append baseList childVals 

let logKinds n =
    let kinds = walk n getKind in
    Array.map Js.log kinds

let () =
    let path = Fs.argv.(2) in 
    let txt = Fs.bufferToStr ( Fs.readFileSync path) in 
    (* TODO: Make a declaration for this enum *)
    let scriptTarget = 1 in
    let obj = Typescript.createSourceFile path txt scriptTarget false in
    let statements = obj##statements in
    Array.map logKinds statements |> ignore

