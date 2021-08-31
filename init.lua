local chars
chars = function(s)
  local _accum_0 = { }
  local _len_0 = 1
  for i = 1, #s do
    _accum_0[_len_0] = s:sub(i, i)
    _len_0 = _len_0 + 1
  end
  return _accum_0
end
local flagger
flagger = function(string, flags)
  if flags == nil then
    flags = { }
  end
  local mode = 'reset'
  local _list_0 = chars(string)
  for _index_0 = 1, #_list_0 do
    local char = _list_0[_index_0]
    local _exp_0 = char
    if '+' == _exp_0 then
      mode = 'set'
    elseif '-' == _exp_0 then
      mode = 'unset'
    else
      if mode == 'reset' then
        flags = { }
        mode = 'set'
      end
      flags[char] = mode == 'set'
    end
  end
  return flags
end
