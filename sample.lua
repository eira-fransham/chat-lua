start {
  character = "Frank"
}

say "Funny to see you around here again."
response = ask "Say, what are you doing around here anyway?"
  :responses {
    clues = "Just looking for clues, that's my job after all.",
    classified = "I'm afraid that's classified.",
  }

if response.clues then
  say "I would expect nothing less from the great detective."
elseif response.classified then
  say "Well that's not a very nice way to talk to an old friend."
end
