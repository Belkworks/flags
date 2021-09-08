-- flags.moon
-- SFZILabs 2021

import sort, concat from table

chars = (s) -> [s\sub i, i for i = 1, #s]
keys = (t) -> [i for i in pairs t]
filter = (t, fn) -> [v for i, v in pairs t when fn v, i, t]

flagger = (string, flags = {}) ->
    mode = 'set'
    for char in *chars string
        switch char
            when '+' then mode = 'set'
            when '-' then mode = 'unset'
            when ' ', '\t', '\n' then noop
            else flags[char] = mode == 'set'

    flags

assertValidFlag = (fn) ->
    (flag, ...) => 
        flag = tostring flag
        assert #flag == 1, 'flag must be a single character long!'
        fn @, flag, ...

selfy = (fn) ->
    (...) =>
        fn @, ...
        @

class FlagString
    new: (flags = '') => -- string? flags 
        @data = {}
        @parse flags

        @toggle = @flip

    parse: (flags) =>
        for char in *chars flags
            @data[char] = true

    clear: selfy => @data = {}

    has: (flag) => -- <char> flag -> bool is set
        @data[flag] == true

    hasNot: (flag) => -- <char> flag -> <bool> is not set
        not @has flag

    set: selfy assertValidFlag (flag) =>
        @data[flag] = true

    unset: selfy assertValidFlag (flag) =>
        @data[flag] = nil
    
    flip: assertValidFlag (flag) =>
        if @has flag
            @unset flag
        else @set flag
        
        @has flag

    apply: selfy (change) => -- string,table change
        switch type change
            when 'string' then flagger change, @data
            when 'table'
                data = assert change.data, 'invalid table to apply'
                for i, v in pairs data
                    @data[i] = if v
                        true
                    else nil

    stringify: =>
        chars = filter (keys @data), @\has
        sort chars
        concat chars, ''

    __tostring: => @stringify!
