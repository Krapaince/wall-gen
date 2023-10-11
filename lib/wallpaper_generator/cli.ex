defmodule WallpaperGenerator.Cli do
  def main(argv) do
    file_option_parser = fn maybe_filepath ->
      case File.stat(maybe_filepath) do
        {:ok, %File.Stat{type: :regular}} -> {:ok, maybe_filepath}
        {:ok, _} -> {:error, "#{maybe_filepath} is't a regular file"}
        {:error, error} -> {:error, "Error #{error}"}
      end
    end

    %Optimus.ParseResult{options: %{color_set: color_set, output: output, wallpaper: wallpaper}} =
      Optimus.new!(
        name: "wall-gen",
        description: "Generate nuance of a wallpaper",
        version: "0.0.1",
        author: "Krapaince krapaince@pm.me",
        allow_unknown_args: false,
        options: [
          color_set: [
            value_name: "COLOR_SET",
            short: "-c",
            long: "--color-set",
            help: "Color set",
            required: true,
            parser: file_option_parser
          ],
          output: [
            value_name: "OUTPUT",
            short: "-o",
            long: "--output",
            help: "Generated wallpapers output directory",
            required: true,
            parser: :string
          ],
          wallpaper: [
            value_name: "WALLPAPER",
            short: "-w",
            long: "--wallpaper",
            help: "Wallpaper",
            required: true,
            parser: file_option_parser
          ]
        ]
      )
      |> Optimus.parse!(argv)

    WallpaperGenerator.generate(color_set, wallpaper, output)
  end
end
