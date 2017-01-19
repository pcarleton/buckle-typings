// A simple call to the TypeScript compiler
// to get the semantics right before doing it in BuckleScript

var typescript = require('typescript');

var sourceFile = typescript.createSourceFile("dummy_path",
  "declare var foo: number;",
  typescript.ScriptTarget.ES5,
  false
);

console.log(sourceFile);



