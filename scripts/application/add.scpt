on run argv
  tell application "iTunes"
    set file_path to (POSIX file (item 1 of argv)) as string
    set added_track to add file_path
    return persistent ID of added_track
  end tell
end run
