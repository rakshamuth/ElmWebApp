{- This app is the basic counter app. You can increment and decrement the count
like normal. The big difference is that the current count shows up in the URL.
Try changing the URL by hand. If you change it to a number, the app will go
there. If you change it to some invalid address, the app will recover in a
reasonable way.
-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import Html.Events exposing ( onClick )
import Navigation
import String

-- component import example
import Components.Hello exposing ( hello )

main =
  Navigation.program urlParser
    { init = init
    , view = view
    , update = update
    , urlUpdate = urlUpdate
    , subscriptions = subscriptions
    }



-- URL PARSERS - check out evancz/url-parser for fancier URL parsing


toUrl : Int -> String
toUrl count =
  "#/" ++ toString count


fromUrl : String -> Result String Int
fromUrl url =
  String.toInt (String.dropLeft 2 url)


urlParser : Navigation.Parser (Result String Int)
urlParser =
  Navigation.makeParser (fromUrl << .hash)



-- MODEL


type alias Model = Int


init : Result String Int -> (Model, Cmd Msg)
init result =
  urlUpdate result 0



-- UPDATE


type Msg = Increment | Decrement


{-| A relatively normal update function. The only notable thing here is that we
are commanding a new URL to be added to the browser history. This changes the
address bar and lets us use the browser&rsquo;s back button to go back to
previous pages.
-}
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let
    newModel =
      case msg of
        Increment ->
          model + 1

        Decrement ->
          model - 1
  in
    (newModel, Navigation.newUrl (toUrl newModel))


{-| The URL is turned into a result. If the URL is valid, we just update our
model to the new count. If it is not a valid URL, we modify the URL to make
sense.
-}
urlUpdate : Result String Int -> Model -> (Model, Cmd Msg)
urlUpdate result model =
  case result of
    Ok newCount ->
      (newCount, Cmd.none)

    Err _ ->
      (model, Navigation.modifyUrl (toUrl model))



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container", style [("margin-top", "30px"), ( "text-align", "center" )] ][    -- inline CSS (literal)
    div [ class "row" ][
      div [ class "col-xs-12" ][
        div [ class "jumbotron" ][
          img [ src "static/img/elm.jpg", style styles.img ] []                                    -- inline CSS (via var)
          , div
            [ class "h2" ]
            [ text ( "Connecting Activists with Supporters" ) ]                                                                     -- ext 'hello' component (takes 'model' as arg)
          , p [] [ text ( "Find Out How You Can Help" ) ]
          , button [ class "btn btn-primary btn-lg", onClick Decrement ] [                  -- click handler
            span[ class "" ][]                                      -- glyphicon
            , span[][ text "Find a protest" ]
          ]
          , button [ class "btn btn-primary btn-lg", onClick Increment ] [                  -- click handler
            span[ class "" ][]                                      -- glyphicon
            , span[][ text "List a protest" ]
          ]
        ]
      ]
    ]
  ]

-- CSS STYLES
styles : { img : List ( String, String ) }
styles =
  {
    img =
      [ ( "width", "33%" )
      , ( "border", "4px solid #337AB7")
      ]
  }
