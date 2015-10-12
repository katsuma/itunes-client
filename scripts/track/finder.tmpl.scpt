tell application "iTunes"
  set specified_tracks to (every track #{whose} #{conditions})
	set json to "["

	repeat with specified_track in specified_tracks
    set props to {}

    set end of props to "{"
    set end of props to ("\"persistent_id\":\"" & persistent ID of specified_track & "\",")
    set end of props to ("\"name\":\"" & my escape_quote(name of specified_track) & "\",")
    set end of props to ("\"album\":\"" & my escape_quote(album of specified_track) & "\",")
    set end of props to ("\"artist\":\"" & my escape_quote(artist of specified_track) & "\",")
    set end of props to ("\"track_count\":\"" & track count of specified_track & "\",")
    set end of props to ("\"track_number\":\"" & track number of specified_track & "\",")
    set end of props to ("\"year\":\"" & year of specified_track & "\",")
    set end of props to ("\"video_kind\":\"" & video kind of specified_track & "\",")
    set end of props to ("\"show\":\"" & show of specified_track & "\",")
    set end of props to ("\"season_number\":\"" & season number of specified_track & "\",")
    set end of props to ("\"episode_number\":\"" & episode number of specified_track & "\"")
    set end of props to "}"

    set json to json & props as string & ","
  end repeat

  set json to json & "null]"
  return json

end tell


on escape_quote(someText)
 return replaceText(someText, "\"", "\\\"")
end escape_quote

(*
   https://discussions.apple.com/thread/4588230?start=0&tstart=0
*)
on replaceText(someText, oldItem, newItem)
     set {tempTID, AppleScript's text item delimiters} to {AppleScript's text item delimiters, oldItem}
     try
          set {itemList, AppleScript's text item delimiters} to {text items of someText, newItem}
          set {someText, AppleScript's text item delimiters} to {itemList as text, tempTID}
     on error errorMessage number errorNumber -- oops
          set AppleScript's text item delimiters to tempTID
          error errorMessage number errorNumber -- pass it on
     end try

     return someText
end replaceText
