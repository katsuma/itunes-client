on run argv
  tell application "iTunes"
    set sound volume to (sound volume - (item 1 of argv))
  end tell
end run
