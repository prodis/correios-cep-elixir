[
  inputs:
    if System.version() =~ ~r/1.7.*/ do
      # Ignoring test/support because Elixir 1.7 formatter breaks on Travis.
      [
        "{mix,.credo,.formatter}.exs",
        "{config,lib}/**/*.{ex,exs}",
        "test/test_helper.exs",
        "test/correios/**/*.{ex,exs}"
      ]
    else
      ["{mix,.credo,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"]
    end
]
