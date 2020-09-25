use Mix.Config

config :calc, Server,
  port: 8080,
  irgendwas: "Steht hier noch"

import_config "#{Mix.env()}.exs"
