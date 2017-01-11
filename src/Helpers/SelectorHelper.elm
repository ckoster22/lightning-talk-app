module Helpers.SelectorHelper exposing ((<<<), (<<<<))

{-
   Typical usage might be something like:

   view : Data -> Modifier -> Html Msg
   view =
       childView <<< selector

   ...

   childView : ViewModel -> Html Msg

   ...
   selector : Data -> Modifier -> ViewModel
-}


(<<<) : (c -> d) -> (a -> b -> c) -> (a -> b -> d)
(<<<) g f x y =
    g (f x y)



{-
   Typical usage might be something like:

   view : Page -> Data -> Modifier -> Html Msg
   view =
       childView <<<< selector

   ...

   childView : ViewModel -> Html Msg

   ...
   selector : Page -> Data -> Modifier -> ViewModel
-}


(<<<<) : (d -> e) -> (a -> b -> c -> d) -> (a -> b -> c -> e)
(<<<<) g f x y z =
    g (f x y z)
