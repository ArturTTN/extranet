defmodule Sabre.Driver do

  defstruct [:ipcc, :password, :username, :token, :id, :timer]


  alias SessionManager.Interfaces.Storage
  alias Sabre.Requestor

  def get_data(params) do

    driver = %Sabre.Driver{
      :ipcc => params.ipcc,
      :password => params.password,
      :username => params.username,
      :timer => params.timer
    }

    Storage.get_session(driver)

    # with  session_id    <- Storage.get_session(driver),
    #       search_resp   <- Requestor.search_recommendation(session_id, driver)
    # do
    #   search_resp
    # end

  end

end

defimpl SessionManager.Protocol, for: Sabre.Driver do

  alias Sabre.Driver.ResultDecorator
  alias Sabre.Requestor
  alias Sabre.Driver.ResultDecorator.Session

  def create_session(driver) do

    with  {:ok, %HTTPoison.Response{body: body}} <- Requestor.get_session(driver),
          %Session{error: nil, token: session_id, id: id} <- ResultDecorator.extract_session_data(body)
    do
      {:ok, %{id: id, token: session_id}}
    else
      session -> {:error, session.error}
    end

  end

  def close_session(driver) do
    %{id: id, token: token} = driver
    {:ok, %HTTPoison.Response{body: body}} = Requestor.close_session(driver, token, id)
  end

end
