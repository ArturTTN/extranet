defmodule Sabre.Interfaces.Search do

  alias Sabre.Driver
  defdelegate get_data(data), to: Driver
end