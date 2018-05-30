defmodule Api do


  def stream(param \\ []) do




    # [param]
    [
      %{
       "driver": "Sabre",
       "ipcc": "",
       "username": "",
       "password": "",
       "timer": 0
    },
    %{
       "driver": "Sabre",
       "ipcc": "",
       "username": "",
       "password": "",
       "timer": 0
    },
    %{
       "driver": "Sabre",
       "ipcc": "",
       "username": "",
       "password": "",
       "timer": 0
    },
    %{
       "driver": "Sabre",
       "ipcc": "",
       "username": "",
       "password": "",
       "timer": 0
    }
    ]
      |> Enum.map(&get_driver(&1[:driver], &1))
      |> Enum.map(&NodeInterface.Protocol.search/1)
      |> Enum.map(&(Task.await(&1, 15_000)))

      # |> Stream.map(&Api.search(&1))
      # |> Enum.to_list


  end

  def get_driver("Sabre", opts), do: struct(NodeInterface.Sabre, opts)

end





