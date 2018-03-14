local chat = require 'chat'

local dialog = chat.run(loadfile('./sample.lua'))

local response = dialog:next()
while response do
  if response[1] == 'say' then
    print(dialog.vars.character .. ':', response[2])

    response = dialog:next()
  elseif response[1] == 'ask' then
    print(dialog.vars.character .. ':', response[2].phrase)

    print 'Respond:'

    local map = {}
    for k, v in pairs(response[2].responses) do
      table.insert(map, k)
      print('', tostring(#map) .. ':', v)
    end

    response = dialog:next(map[io.read('*number')])
  end
end
