defmodule Sabre.Requestor do

  import XmlBuilder
  # import Logger

  alias Sabre.Driver.FactoryElement
  # alias Avia.Driver.Protocol

  @endpoint Application.get_env(:sabre, :endpoint)


  def search_recommendation(session_id, _driver) do
    {:ok, session_id}
  end

  def get_session(driver) do

    length = 12
    conversation_id =
      length
        |> :crypto.strong_rand_bytes
        |> Base.url_encode64
        |> binary_part(0, length)

    xml =
      element("env:Envelope", FactoryElement.envelope(),
        [
          element("env:Header",
            [
              FactoryElement.get_header(driver.ipcc, conversation_id),
              FactoryElement.security_header(driver.username, driver.password, driver.ipcc)
            ]),
          element("env:Body", [
            element("SessionCreateRQ", [
              FactoryElement.pos(driver.ipcc)
              ])
            ])
        ]
      ) |> generate

    #Apex.ap xml

    response = HTTPoison.post @endpoint, xml, [{"Content-Type", "text/xml"}]

    Apex.ap response

    response
  end

  def close_session(driver, token, conversation_id) do

    xml =
      element("env:Envelope", FactoryElement.envelope(),
        [
          element("env:Header",
            [
              FactoryElement.get_header(driver.ipcc, conversation_id, "SessionCloseRQ"),
              FactoryElement.binary_token(token)
            ]),
          element("env:Body", [
            element("SessionCloseRQ", [
              FactoryElement.pos(driver.ipcc)
              ])
            ])
        ]
      ) |> generate

    # Apex.ap xml

    response = HTTPoison.post @endpoint, xml, [{"Content-Type", "text/xml"}]

    Apex.ap response

    response
  end

end