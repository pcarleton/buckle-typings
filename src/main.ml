

let () =
    let txt = "declare var foo: number;" in
    (* The file path doesn't seem important for this use case so far*)
    let path = "dummy_path" in
    (* TODO: Make a declaration for this enum *)
    let scriptTarget = 1 in
    let obj = Typescript.createSourceFile path txt scriptTarget false in
    Js.log obj
