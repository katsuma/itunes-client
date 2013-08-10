tell application "iTunes"
  next track
  play
  return persistent ID of current track
end tell
