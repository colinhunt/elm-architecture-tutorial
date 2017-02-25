import Html exposing (..)
import Html.Events exposing (..)
import Random



main = 
  Html.program { 
    init = init,
    view = view,
    update = update,
    subscriptions = subscriptions
  }



-- MODEL


type alias Model = { 
  count: Int
}


init: (Model, Cmd Msg)
init =
  (Model 1, Cmd.none)



-- UPDATE


type Msg = 
  Increment | Decrement


update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Increment ->
      ({ model | count = model.count + 1}, Cmd.none)

    Decrement ->
      ({ model | count = model.count - 1}, Cmd.none)



-- SUBSCRIPTIONS


subscriptions: Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view: Model -> Html Msg
view {count} =
  div [] [ 
    button [ onClick Decrement ] [ text "-" ],
    div [] [ text (toString count) ],
    button [ onClick Increment ] [ text "+" ]
  ]