defmodule Sabre.Driver.ResultDecorator do

  alias Sabre.Driver.ResultDecorator.Session

  def extract_session_data(response) do
    Session.parse(response)
  end
end