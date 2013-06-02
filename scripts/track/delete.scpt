on run argv
  tell application "iTunes"
    set persistent_id to (item 1 of argv) as string
    set specified_track to (some track whose persistent ID is persistent_id)
    set loc to (get location of specified_track)

    delete specified_track

    tell application "Finder"
      delete loc
    end tell
  end tell
end run
