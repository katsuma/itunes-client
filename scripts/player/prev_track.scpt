tell application "iTunes"
  previous track
  play
  return persistent ID of current track
end tell
