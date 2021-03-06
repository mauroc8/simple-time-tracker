module Utils.Time exposing (toStringWithAmPm)

import Clock


toStringWithAmPm : Clock.Time -> String
toStringWithAmPm time =
    let
        minutes =
            Clock.getMinutes time

        ( hours, amPm ) =
            getHoursAndMeridiem time
    in
    String.fromInt hours
        ++ ":"
        ++ (String.fromInt minutes |> String.padLeft 2 '0')
        ++ " "
        ++ meridiemToString amPm


{-| For example `3 pm` can be represented as `( 3, Pm )`
-}
type AmPm
    = Pm
    | Am


getHoursAndMeridiem : Clock.Time -> ( Int, AmPm )
getHoursAndMeridiem time =
    let
        hours =
            Clock.getHours time
    in
    if hours > 12 then
        ( hours - 12, Pm )

    else
        ( hours, Am )


meridiemToString : AmPm -> String
meridiemToString amPm =
    case amPm of
        Pm ->
            "pm"

        Am ->
            "am"
