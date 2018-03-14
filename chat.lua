-- Functions available on the object returned from `ask`
local ask_meta = {}

function ask_meta:responses(responses)
  -- TODO: use enum.lua
  local resp = coroutine.yield {
    'ask',
    { phrase = self.phrase, responses = responses }
  }

  return {
    [resp] = true
  }
end

-- Functions available to our DSL
local edsl_meta = {}

function edsl_meta.start(variables)
  for k, v in pairs(variables) do
    -- 0 is global, 1 is this function, 2 is the dialog (since it's our direct
    -- parent)
    getfenv(2)[k] = v
  end

  -- TODO: Use enum.lua
  coroutine.yield 'START'
end

function edsl_meta.say(phrase)
  -- TODO: Use enum.lua
  coroutine.yield {'say', phrase}
end

function edsl_meta.ask(phrase)
  local ask = {
    phrase = phrase,
  }
  setmetatable(ask, { __index = ask_meta })
  return ask
end

-- Functions on the object returned from `run`
local run_meta = {}

function run_meta:next(...)
  if coroutine.status(self._coroutine) == 'dead' then
    return nil
  else
    local succ, answer = coroutine.resume(self._coroutine, ...)

    if not succ then
      error 'Dialog failed'
    end

    return answer
  end
end

local mod = {}

function mod.run(func)
  local env = { _answer = nil }

  setmetatable(env, { __index = edsl_meta })

  setfenv(func, env)

  local out = {}

  setmetatable(out, { __index = run_meta })

  out.vars = env
  out._coroutine = coroutine.create(func)

  local succ, resp = coroutine.resume(out._coroutine)
  if not succ then
    error 'Failed to initialize dialog'
  elseif resp ~= 'START' then
    error 'Dialog is missing initializer'
  end

  return out
end

return mod
