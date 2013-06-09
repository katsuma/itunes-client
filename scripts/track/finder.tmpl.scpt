tell application "iTunes"
  set specified_tracks to (every track whose #{conditions})

	set json to "["

	repeat with specified_track in specified_tracks
    set props to {}
    set end of props to "{"
    set end of props to ("\"persistent_id\":\"" & persistent ID of specified_track & "\",")
    set end of props to ("\"name\":\"" & name of specified_track & "\",")
    set end of props to ("\"album\":\"" & album of specified_track & "\",")
    set end of props to ("\"artist\":\"" & artist of specified_track & "\",")
    set end of props to ("\"track_count\":\"" & track count of specified_track & "\",")
    set end of props to ("\"track_number\":\"" & track number of specified_track & "\"")
    set end of props to "}"

    set json to json & props as string & ","
  end repeat

  set json to json & "null]"
  return json

end tell
