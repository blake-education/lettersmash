defmodule Library do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Library.Dictionary, [[], [name: :dictionary]]),
      supervisor(Library.GameSup, []),
      # worker(Library.Game, []),
    ]

    opts = [strategy: :one_for_one, name: Library.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
