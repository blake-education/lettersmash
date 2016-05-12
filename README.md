# LettersMash

A multiplayer LetterPress game in Elixir, Phoenix and Elm

## Install Elm

From http://elm-lang.org/install - requires 0.17


## Configure app

```
> git clone git@github.com:blake-education/lettersmash.git
> cd lettersmash
> mix deps.get
> cd apps/skateboard/
> npm install
> mix ecto.create
> mix ecto.migrate
> cd web/elm
> elm package install
> cd ../../../..
> iex -S mix phoenix.server
> open localhost:4000
```

