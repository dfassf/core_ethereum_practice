# 4-22
Data location must be "storage" or "memory" for constructor parameter, but none was given.
> memory로 줌

Visibility for constructor is ignored. If you want the contract to be non-deployable, making it "abstract" is sufficient.
> public 삭제

#4-29
totalSupply() expected { but got constant
approve 함수 기능

#4-31
Using ".value(...)" is deprecated. Use "{value: ...}" instead.
Wrong argument count for function call: 0 arguments given but expected 1. This function requires a single bytes argument. Use "" as argument to provide empty calldata.
Operator == not compatible with types tuple(bool,bytes memory) and bool

#4-32
Type tuple(bool,bytes memory) is not implicitly convertible to expected type bool.
Invalid type for argument in function call. Invalid implicit conversion from bytes4 to bytes memory requested. This function requires a single bytes argument. If all your arguments are value types, you can use abi.encode(...) to properly generate it.