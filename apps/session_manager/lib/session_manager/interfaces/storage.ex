defmodule SessionManager.Interfaces.Storage do

  defdelegate get_session(driver), to: SessionManager

end