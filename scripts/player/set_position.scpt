on run argv
  tell application "iTunes"
    set player position to (item 1 of argv)
    return player position
  end tell
end run
