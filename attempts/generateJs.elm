module Main exposing (..)

import Html exposing (..)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { count : Int
    }


init : ( Model, Cmd Msg )
init =
    ( Model 1, Cmd.none )



-- UPDATE


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | count = model.count + 1 }, Cmd.none )

        Decrement ->
            ( { model | count = model.count - 1 }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view { count } =
    div []
        [ text <| javaScript
        ]


type JsInt
    = JsInt String


type JsString
    = JsString String


type JsDate
    = JsDate String


type JsVoid
    = JsVoid String


type alias Console =
    { log : JsString -> JsVoid }


console : Console
console =
    { log =
        (\(JsString msg) ->
            JsVoid <| String.concat [ "console.log(", msg, ")" ]
        )
    }


type alias Date =
    { ctorInt : JsInt -> JsDate
    , now : JsInt
    , getDay : JsDate -> JsString
    , setDate : JsInt -> JsDate -> JsDate
    , toLocaleDateString : JsDate -> JsString
    }


date : Date
date =
    { ctorInt = (\(JsInt v) -> JsDate <| "new Date(" ++ v ++ ")")
    , now = JsInt "Date.now()"
    , getDay = (\(JsDate d) -> JsString <| d ++ ".getDay()")
    , setDate = (\(JsInt v) (JsDate d) -> JsDate <| chainable d (".setDate(" ++ v ++ ")"))
    , toLocaleDateString = \(JsDate d) -> JsString <| d ++ ".toLocaleDateString()"
    }


chainable : String -> String -> String
chainable expr methodCall =
    String.concat [ "(function(e) { e", methodCall, "; return e})(", expr, ")" ]


javaScript : String
javaScript =
    date.now
        |> date.ctorInt
        |> date.setDate (JsInt "7")
        |> date.toLocaleDateString
        |> console.log
        |> \(JsVoid e) -> e


quote : String -> String
quote str =
    "'" ++ str ++ "'"
