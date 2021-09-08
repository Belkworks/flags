local sort, concat
do
  local _obj_0 = table
  sort, concat = _obj_0.sort, _obj_0.concat
end
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
local keys
keys = function(t)
  local _accum_0 = { }
  local _len_0 = 1
  for i in pairs(t) do
    _accum_0[_len_0] = i
    _len_0 = _len_0 + 1
  end
  return _accum_0
end
local filter
filter = function(t, fn)
  local _accum_0 = { }
  local _len_0 = 1
  for i, v in pairs(t) do
    if fn(v, i, t) then
      _accum_0[_len_0] = v
      _len_0 = _len_0 + 1
    end
  end
  return _accum_0
end
local flagger
flagger = function(string, flags)
  if flags == nil then
    flags = { }
  end
  local mode = 'set'
  local _list_0 = chars(string)
  for _index_0 = 1, #_list_0 do
    local char = _list_0[_index_0]
    local _exp_0 = char
    if '+' == _exp_0 then
      mode = 'set'
    elseif '-' == _exp_0 then
      mode = 'unset'
    elseif ' ' == _exp_0 or '\t' == _exp_0 or '\n' == _exp_0 then
      local _ = noop
    else
      flags[char] = mode == 'set'
    end
  end
  return flags
end
local assertValidFlag
assertValidFlag = function(fn)
  return function(self, flag, ...)
    flag = tostring(flag)
    assert(#flag == 1, 'flag must be a single character long!')
    return fn(self, flag, ...)
  end
end
local FlagString
do
  local _class_0
  local _base_0 = {
    parse = function(self, flags)
      local _list_0 = chars(flags)
      for _index_0 = 1, #_list_0 do
        local char = _list_0[_index_0]
        self.data[char] = true
      end
    end,
    clear = function(self)
      self.data = { }
    end,
    has = function(self, flag)
      return self.data[flag] == true
    end,
    hasNot = function(self, flag)
      return not self:has(flag)
    end,
    set = assertValidFlag(function(self, flag)
      self.data[flag] = true
    end),
    unset = assertValidFlag(function(self, flag)
      self.data[flag] = nil
    end),
    apply = function(self, change)
      local _exp_0 = type(change)
      if 'string' == _exp_0 then
        return flagger(change, self.data)
      elseif 'table' == _exp_0 then
        local data = assert(change.data, 'invalid table to apply')
        for i in pairs(data) do
          if data[i] then
            self.data[i] = true
          end
        end
      end
    end,
    stringify = function(self)
      chars = filter((keys(self.data)), (function()
        local _base_1 = self
        local _fn_0 = _base_1.has
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)())
      sort(chars)
      return concat(chars, '')
    end,
    __tostring = function(self)
      return self:stringify()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, flags)
      if flags == nil then
        flags = ''
      end
      self.data = { }
      return self:parse(flags)
    end,
    __base = _base_0,
    __name = "FlagString"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  FlagString = _class_0
  return _class_0
end
