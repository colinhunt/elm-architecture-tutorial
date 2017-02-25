import Html exposing (..)
import Random
import Html.Events exposing (..)

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

type alias Model = {
    dieFace: Int
}

type Msg = 
    Roll |
    NewFace Int

update: Msg->Model->(Model, Cmd Msg)
update msg model =
    case msg of
        Roll ->
            (model, Random.generate NewFace (Random.int 1 6))

        NewFace newFace ->
            (Model newFace, Cmd.none)

init: (Model, Cmd Msg)
init =
    (Model 1, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

view: Model -> Html Msg
view {dieFace} =
    div [] [
        h1 [] [text (toString dieFace)],
        button [onClick Roll] [text "Roll"]
    ]