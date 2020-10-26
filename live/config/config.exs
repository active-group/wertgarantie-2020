use Mix.Config

config :live, Live.Repo,
  database: "elixir",
  username: "elixir",
  password: "34kjasdP",
  hostname: "tim.active-group.de",
  port: "15432"

if Mix.env() == :test do
  import_config "#{Mix.env()}.exs"
end
