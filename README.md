# Contract grammar
Contract grammar is a modified ACSL grammar used to specify contracts how functions should work.

You can compile it to whatever target you want using antlr4 targets. We use it for C++ target.
```
antlr4 -Dlanguage=CSharp Contract.g4
```

## License
 - C grammar belongs to ANTLR grammars collection: https://github.com/antlr/grammars-v4/blob/master/c/C.g4. BSD license.
 - ACSL grammar specification belongs to its original authors: https://github.com/acsl-language/acsl. CC BY 4.0

Licenses are included in LICENSE file.
