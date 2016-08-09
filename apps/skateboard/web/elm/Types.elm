module Types exposing (..)

import Material

type Page
  = LobbyPage
  | GamePage
  | NotImplementedPage
  | Mdl (Material.Msg Msg)

