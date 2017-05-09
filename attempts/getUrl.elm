import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http

main = 
  Html.program { init = init, subscriptions = \_ -> Sub.none, update = update, view = view }

type alias Model = { url: String, result: Result Http.Error String }

type Msg = SetURL String | Load | Response (Result Http.Error String)

init: (Model, Cmd Msg)
init = ({ url = "", result = Ok "" }, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SetURL url -> ({ model | url = url }, Cmd.none )
    Load -> (model, Http.send Response (Http.getString model.url))
    Response result -> ({model | result = result }, Cmd.none)

view : Model -> Html Msg
view model =
  div []
     [
       input [onInput SetURL, defaultValue "http://" ] []
     , button [onClick Load] [ text "Load" ]
     , div [] [text (toString model.result)]
     ]