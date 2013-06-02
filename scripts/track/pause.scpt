on run argv
  tell application "iTunes"
    set persistent_id to (item 1 of argv) as string
    set specified_track to (some track whose persistent ID is persistent_id)

    pause specified_track
  end tell
end run
