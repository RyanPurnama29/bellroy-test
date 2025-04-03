module ProductCard exposing (main)

import Browser
import Html exposing (Html, div, h2, img, p, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


-- MODEL

type alias ColorOption =
    { hex : String
    , imageUrl : String
    }

type alias Product =
    { title : String
    , price : String
    , isBestseller : Bool
    , description : String
    , colors : List ColorOption
    , selectedColor : ColorOption
    }


init : () -> ( Product, Cmd Msg )
init _ =
    let
        colorOptions =
            [ { hex = "#2B2B2B", imageUrl = "/img/black.png" }
            , { hex = "#1E2A45", imageUrl = "/img/navy.png" }
            , { hex = "#6B7946", imageUrl = "/img/olive.png" }
            , { hex = "#B86A3C", imageUrl = "/img/rust.png" }
            ]
    in
    ( { title = "Venture Ready Sling 2.5L"
      , price = "$89"
      , isBestseller = True
      , description = "2.5L / A rugged little sling for daily adventure"
      , colors = colorOptions
      , selectedColor = List.head colorOptions |> Maybe.withDefault { hex = "", imageUrl = "" }
      }
    , Cmd.none
    )



-- UPDATE

type Msg
    = SelectColor ColorOption

update : Msg -> Product -> ( Product, Cmd Msg )
update msg model =
    case msg of
        SelectColor color ->
            ( { model | selectedColor = color }, Cmd.none )



-- VIEW

view : Product -> Html Msg
view model =
    div [ class "product-card" ]
        ([ img [ src model.selectedColor.imageUrl, alt model.title, class "product-image" ] []
         ]
            ++ (if model.isBestseller then
                    [ div [ class "badge-wrapper" ]
                        [ div [ class "badge" ] [ text "Bestseller" ] ]
                    ]
                else
                    []
            )
            ++ [ h2 [ class "product-title" ] [ text model.title ]
               , div [ class "price" ] [ text model.price ]
               , div [ class "colors" ]
                   (List.map (colorDot model.selectedColor) model.colors)
               , p [ class "desc" ] [ text model.description ]
               ]
        )


colorDot : ColorOption -> ColorOption -> Html Msg
colorDot selected color =
    let
        className =
            if selected.hex == color.hex then
                "color-dot selected"
            else
                "color-dot"
    in
    div
        [ class className
        , style "background-color" color.hex
        , onClick (SelectColor color)
        ]
        []



-- MAIN

main : Program () Product Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }