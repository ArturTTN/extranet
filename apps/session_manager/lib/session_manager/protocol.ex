defprotocol SessionManager.Protocol do

  @moduledoc """
  A protocol for dealing with the
  session manager methods.
  """
  @doc "start session"
  def create_session(driver)

  @doc "close session"
  def close_session(driver)

end