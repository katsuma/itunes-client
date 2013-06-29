on run argv
  tell application "iTunes"
    set persistent_id to (item 1 of argv) as string
    set specified_track to (some track whose persistent ID is persistent_id)
    set loc to (get location of specified_track)

    set converted_tracks to (convert specified_track)
    set converted_track to item 1 of converted_tracks
    return persistent ID of converted_track
  end tell
end run
