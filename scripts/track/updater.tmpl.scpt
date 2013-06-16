tell application "iTunes"
  set specified_track to (some track whose persistent ID is "#{persistent_id}")
  #{update_records}
end tell
