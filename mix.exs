defmodule WallpaperGenerator.MixProject do
  use Mix.Project

  def project do
    [
      app: :wallpaper_generator,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [main_module: WallpaperGenerator.Cli, name: "wall-gen"]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.4"},
      {:optimus, "~> 0.5"}
    ]
  end
end
