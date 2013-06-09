tell application "iTunes"
  set specified_track to (some track whose #{conditions})

  set props to {}
  set end of props to "{"
  set end of props to ("\"persistent_id\":\"" & persistent ID of specified_track & "\",")
  set end of props to ("\"name\":\"" & name of specified_track & "\",")
  set end of props to ("\"album\":\"" & album of specified_track & "\",")
  set end of props to ("\"artist\":\"" & artist of specified_track & "\",")
  set end of props to ("\"track_count\":\"" & track count of specified_track & "\",")
  set end of props to ("\"track_number\":\"" & track number of specified_track & "\"")
  set end of props to "}"

  return props as string
end tell
