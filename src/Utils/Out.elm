module Utils.Out exposing
    ( addCmd
    , andThen
    , map2
    , mapCmd
    , mapModel
    , withCmd
    , withModel
    , withNoCmd
    )

{-| This module provides:

1.  Functions to create "update tuples"
2.  Pipeline-friendly functions to manipulate "update tuples"

I call "update tuple" to a tuple with type `( model, Cmd msg )`.

-}


{-| Start a pipeline from a model.

    { model | user = user }
        |> Out.withNoCmd

-}
withNoCmd : model -> ( model, Cmd msg )
withNoCmd model0 =
    ( model0, Cmd.none )


{-| Start a pipeline from a model and a command.

    { model | user = user }
        |> Out.withCmd (\model -> saveUser model.user)

-}
withCmd : (model -> Cmd msg) -> model -> ( model, Cmd msg )
withCmd cmd0 model0 =
    ( model0, cmd0 model0 )


{-| Start a pipeline from a command and a model.

    someCmd
        |> Out.withModel model

-}
withModel : model -> Cmd msg -> ( model, Cmd msg )
withModel model0 cmd0 =
    ( model0, cmd0 )


{-| Add a command to a pipeline.

Unlike `withCmd`, you can't start a pipeline with this function.

    model
        |> Out.withCmd cmd0
        |> Out.addCmd (\model -> cmd1 model)

-}
addCmd : (model -> Cmd msg) -> ( model, Cmd msg ) -> ( model, Cmd msg )
addCmd cmd0 ( model0, cmd1 ) =
    ( model0, Cmd.batch [ cmd0 model0, cmd1 ] )


{-| Searching answers in the stars.
-}
mapModel : (a -> b) -> ( a, Cmd msg ) -> ( b, Cmd msg )
mapModel f ( model0, cmd0 ) =
    ( f model0, cmd0 )


{-| Following my intuition.
-}
andThen : (a -> ( b, Cmd msg )) -> ( a, Cmd msg ) -> ( b, Cmd msg )
andThen f ( model0, cmd0 ) =
    let
        ( model1, cmd1 ) =
            f model0
    in
    ( model1, Cmd.batch [ cmd0, cmd1 ] )


{-| Letting go.
-}
mapCmd : (msg0 -> msg1) -> ( model, Cmd msg0 ) -> ( model, Cmd msg1 )
mapCmd f ( model0, cmd0 ) =
    ( model0, Cmd.map f cmd0 )


{-| Seriously?
-}
map2 :
    (model0 -> model1 -> model2)
    -> ( model0, Cmd msg )
    -> ( model1, Cmd msg )
    -> ( model2, Cmd msg )
map2 f ( model0, cmd0 ) ( model1, cmd1 ) =
    ( f model0 model1, Cmd.batch [ cmd0, cmd1 ] )
