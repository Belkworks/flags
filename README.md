

# flags
*A flag reader/writer in MoonScript, inspired by IRC*

**Importing with [Neon](https://github.com/Belkworks/NEON)**:
```lua
FlagString = NEON:github('belkworks', 'flags')
```

## API

### Creating a FlagString

To create a FlagString, call **FlagString**.  
`FlagString(string? flags) -> FlagString`
```lua
flags = FlagString('abc')
-- or,
flags = FlagString() -- empty flags
```

### Querying a FlagString

**has**: `flags:has(char flag) -> boolean`  
Checks if `flag` is set.
```lua
flags:has('a') -- true
flags:has('d') -- false
```

### Modifying a FlagString

**set**: `flags:set(char flag, any value = true) -> self`  
Sets `flag` to the truthiness of `value`.
```lua
flags:set('d'):has('d') -- true
```

**unset**: `flags:unset(char flag) -> self`  
Unsets `flag`.
```lua
flags:unset('d'):has('d') -- false
```

**flip**: `flags:flip(char flag) -> boolean`  
Alternative call: `flags:toggle(char flag) -> boolean`  
Inverts the status of `flag` and returns the new value.
```lua
flags:has('d') -- false
flags:flip('d') -- true
flags:has('d') -- true
```

**apply**: `flags:flip(string/table delta) -> self`  
Applies multiple changes specified by `delta`.  
If `delta` is a string, the setting mode is changed via `+` and `-`.  
Further characters will either be set or unset.  
Multiple modes can be used in a single string.
```lua
-- state: abcd
flags:apply('+ef-d'):stringify() -- 'abcef'
```
If `delta` is a table, flags will be set via truthiness of keys.
```lua
-- state: abcd
flags:apply({e = true, f = true, d = false}):stringify() -- 'abcef'
```

### Outputting a FlagString

**stringify**: `flags:stringify() -> string`  
Returns the FlagString's current state as a string.
```lua
flags:stringify() -- 'abcef'
```

**tostring**: `tostring(flags) -> string`  
The same as **stringify**.
```lua
tostring(flags) -- 'abcef'
```
