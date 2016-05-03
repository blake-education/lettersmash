use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :skateboard, Skateboard.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# Configure your database
config :skateboard, Skateboard.Repo,
  adapter: Ecto.Adapters.Postgres,
  #username: System.get_env("DATABASE_USERNAME"),
  #password: System.get_env("DATABASE_PASSWORD"),
  database: System.get_env("DATABASE_URL"),
  pool_size: 20
  ssl: true
