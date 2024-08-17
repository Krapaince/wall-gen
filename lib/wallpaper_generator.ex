defmodule WallpaperGenerator do
  require Logger

  @tmp_dir "/tmp/wallpapers"

  def generate(color_set, wallpaper, output_dir) do
    File.mkdir_p!(@tmp_dir)
    File.mkdir_p!(output_dir)

    File.read!(color_set)
    |> Jason.decode!(keys: :atoms)
    |> Stream.map(fn color_set ->
      {lowthresh, highthresh, operations} = into_operations(color_set)

      into_commands(wallpaper, lowthresh, highthresh, operations)
      |> Enum.to_list()
    end)
    |> Stream.with_index(1)
    |> Task.async_stream(
      fn {cmds_args, i} -> generate_wallpaper(cmds_args, i, output_dir, wallpaper) end,
      timeout: :infinity
    )
    |> Stream.run()

    :ok
  end

  defp into_operations(%{
         l: lowthresh,
         h: highthresh,
         r: red,
         y: yellow,
         g: green,
         c: cyan,
         b: blue,
         m: magenta
       }) do
    operations =
      [r: red, y: yellow, g: green, c: cyan, b: blue, m: magenta]
      |> Enum.reject(fn {_, amount} -> amount == 0 end)

    {lowthresh, highthresh, operations}
  end

  defp into_commands(input_filename, lowthresh, highthresh, operations) do
    operations
    |> Stream.transform(input_filename, fn {color, amount}, input_filename ->
      output_file = Path.join(@tmp_dir, get_uniq_filename()) <> ".png"

      args = [
        "-l",
        "#{lowthresh}",
        "-h",
        "#{highthresh}",
        "-c",
        "#{color}",
        "-a",
        "#{amount}",
        "-r",
        "h",
        input_filename,
        output_file
      ]

      {[args], output_file}
    end)
  end

  defp generate_wallpaper(cmds_arguments, i, output_dir, original) when is_integer(i) do
    filename = String.pad_leading("#{i}", 3, "0") <> ".png"
    filepath = Path.join(output_dir, filename)

    case File.exists?(filepath) do
      false ->
        Logger.info("Making #{filename}...")
        generate_wallpaper(cmds_arguments, filepath, original)
        Logger.info("#{filename} done.")

      true ->
        Logger.info("#{filename} already exists, skipping.")
    end
  end

  defp generate_wallpaper([], filename, original), do: File.ln(original, filename)

  defp generate_wallpaper(cmds_arguments, filename, _) do
    output_file = cmds_arguments |> List.last() |> List.last()

    errors =
      cmds_arguments
      |> Enum.map(&System.cmd("colorbalance2", &1))
      |> Enum.reject(fn {_, exit_status} -> exit_status == 0 end)

    case errors do
      [] ->
        File.copy!(output_file, filename)

      _ ->
        errors = errors |> Enum.map(&elem(&1, 0)) |> Enum.join("\n")

        Logger.error("Error while making #{filename}: #{errors}")
        :error
    end
  end

  defp get_uniq_filename(),
    do: Stream.repeatedly(fn -> ?a..?z |> Enum.random() end) |> Enum.take(16)
end
