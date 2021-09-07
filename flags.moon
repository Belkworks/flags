-- flags.moon
-- SFZILabs 2021

import sort, concat from table

chars = (s) -> [s\sub i, i for i = 1, #s]
keys = (t) -> [i for i in pairs t]
filter = (t, fn) -> [v for i, v in pairs t when fn v, i, t]

flagger = (string, flags = {}) ->
    mode = 'reset'
    for char in *chars string
        switch char
            when '+' then mode = 'set'
            when '-' then mode = 'unset'
            when ' ', '\t', '\n' then noop
            else
                if mode == 'reset'
                    flags = {}
                    mode = 'set'

                flags[char] = mode == 'set'

    flags

assertValidFlag = (fn) ->
    (flag, ...) => 
        flag = tostring flag
        assert #flag == 1, 'flag must be a single character long!'
        fn @, flag, ...

class FlagString
    new: (flags = '') => -- string? flags 
        @parse flags

    parse: (flags) =>
        @data = {}
        for char in *chars flags
            @data[char] = true

    isSet: (flag) => -- string flag -> bool is set
        @data[flag] == true

    set: assertValidFlag (flag) =>
        @data[flag] = true

    unset: assertValidFlag (flag) =>
        @data[flag] = nil

    apply: (change) => -- string,table change
        switch type change
            when 'string' then flagger change, @data
            when 'table'
                data = assert change.data, 'invalid table to apply'
                @data[i] = true for i in pairs data when data[i]

    stringify: =>
        chars = filter (keys @data), @\isSet
        sort chars
        concat chars, ''

    __tostring: => @stringify!
