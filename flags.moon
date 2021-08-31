-- flags.moon
-- SFZILabs 2021

chars = (s) -> [s\sub i, i for i = 1, #s]

flagger = (string, flags = {}) ->
	mode = 'reset'
	for char in *chars string
		switch char
			when '+' then mode = 'set'
			when '-' then mode = 'unset'
			else
				if mode == 'reset'
					flags = {}
					mode = 'set'

				flags[char] = mode == 'set'

	flags
