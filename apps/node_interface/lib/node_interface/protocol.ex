defprotocol NodeInterface.Protocol do

  @moduledoc """
  A protocol for dealing with the
  driver methods.
  """
  @doc "get the search result."
  def search(params)

end