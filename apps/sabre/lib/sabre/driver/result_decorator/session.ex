defmodule Sabre.Driver.ResultDecorator.Session do

  defstruct pid: "", id: "", token: "", error: nil

  alias Sabre.Driver.ResultDecorator.Session

  def parse(body) do

    with {:ok, pid}             <- Agent.start_link(fn -> nil end),
          sess_struct           <- struct(Session, %{:pid => pid}),
         {:ok, session, _tail}  <- :erlsom.parse_sax(body, sess_struct, &Session.attr/2),
         :ok                    <- Agent.stop(pid)
    do
      session
    end
  end

  def attr({:startElement, _url, tag, _, _}, session) do
    session.pid
      |> Agent.cast(&(&1=tag))
    session
  end

  def attr({:characters, value}, session) do
    tag = Agent.get(session.pid, &(&1))
    _put(tag, value, session)
  end


  def attr(:startDocument, session), do: session
  def attr(:endDocument, session), do: session
  def attr({:processingInstruction, _, _}, session), do: session
  def attr({:startPrefixMapping, _, _}, session), do: session
  def attr({:endPrefixMapping, _}, session), do: session
  def attr({:endElement, _, _, _}, session), do: session
  def attr({:ignorableWhitespace, _,}, session), do: session




  defp _put('faultstring', val, session), do: %Session{session | error: val}
  defp _put('ConversationId', val, session), do: %Session{session | id: List.to_string(val)}
  defp _put('BinarySecurityToken', val, session), do: %Session{session | token: List.to_string(val)}

  defp _put(_tag, _val, session), do: session

end