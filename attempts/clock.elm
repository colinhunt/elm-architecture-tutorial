import Html exposing (..)
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)
import Array


main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model = {
  time: Time,
  paused: Bool
}


init : (Model, Cmd Msg)
init =
  ({time = 0, paused = False}, Cmd.none)



-- UPDATE


type Msg
  = Tick Time | Pause Bool


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      ({ model | time = newTime }, Cmd.none)

    Pause paused ->
      ({ model | paused = paused}, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  case model.paused of
    True ->
      Sub.none

    False ->
      Time.every Time.millisecond Tick



-- VIEW


view : Model -> Html Msg
view model =
  let
    getCoord f angle = toString (50 + 40 * f angle)

    marks =
      Array.toList (Array.map (\angle -> 
        line [ x1 "50", y1 "50", x2 (getCoord cos angle), y2 (getCoord sin angle), stroke "#023963" ] []
      ) (Array.initialize 12 (\n -> turns (toFloat n)/12)))

    adjust turns = turns + 0.75

    angle timeGetter =
      let
        time = timeGetter model.time
      in
        turns (adjust time - toFloat (floor time))

    secondHand =
      {x = getCoord cos (angle Time.inMinutes), y = getCoord sin (angle Time.inMinutes) }

    minuteHand =
      {x = getCoord cos (angle Time.inHours), y = getCoord sin (angle Time.inHours) }

    hourHand =
      let
        inHalfDays = (\time -> ((Time.inHours time) + 5)/12)
      in
        {x = getCoord cos (angle inHalfDays), y = getCoord sin (angle inHalfDays) }

  in
    div [] [
      svg [ viewBox "0 0 100 100", width "300px" ] [
        circle [ cx "50", cy "50", r "45", fill "#c9d6e8" ] [],
        g [] marks,
        circle [ cx "50", cy "50", r "35", fill "#c9d6e8" ] [],
        line [ x1 "50", y1 "50", x2 secondHand.x, y2 secondHand.y, stroke "#023963", strokeWidth "0.5" ] [],
        line [ x1 "50", y1 "50", x2 minuteHand.x, y2 minuteHand.y, stroke "#023963", strokeWidth "1" ] [],
        line [ x1 "50", y1 "50", x2 hourHand.x, y2 hourHand.y, stroke "#023963", strokeWidth "1.5" ] []
      ],
      button [onClick (Pause (not model.paused))] [Html.text "Pause"]
    ]
