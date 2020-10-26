defmodule Live.MixProject do
  use Mix.Project

  def project do
    [
      app: :live,
      version: "0.1.1",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Live, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:quick_struct, "~> 0.1"},
      {:distillery, "~> 2.0"},
      {:propcheck, "~> 1.1", only: [:dev, :test]},
      {:postgrex, ">= 0.0.0"},
      {:ecto_sql, "~> 3.0"}
    ]
  end
end
