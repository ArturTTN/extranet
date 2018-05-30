defmodule Sabre.Driver.FactoryElement do

  import XmlBuilder

  def envelope do
    %{
      "xmlns:env": "http://schemas.xmlsoap.org/soap/envelope/",
      "xmlns:SOAP-ENV": "http://schemas.xmlsoap.org/soap/envelope/",
      "xmlns:eb": "http://www.ebxml.org/namespaces/messageHeader",
      "xmlns:xlink": "http://www.w3.org/1999/xlink",
      "xmlns:xsd": "http://www.w3.org/1999/XMLSchema",
      "xmlns:wsdl": "https://webservices.sabre.com/websvc"
    }
  end

  def get_header(pcc, conversation_id, service \\ "SessionCreateRQ") do

    IO.puts "conversation_id"
    IO.inspect conversation_id

    dt = DateTime.utc_now() |> DateTime.to_iso8601()
    element(
      "eb:MessageHeader",
      %{
        "SOAP-ENV:mustUnderstand": 1,
        "eb:version": 1.0,
      },
      [
        element(
        "eb:From", [
          element(
            "eb:PartyId", "WebServiceClient")
        ]),
        element("eb:To", [
          element(
            "eb:PartyId", "WebServiceClient")
        ]),
        element("eb:CPAId", pcc),
        element("eb:ConversationId", conversation_id),
        element("eb:Service", service),
        element("eb:Action", service),
        element("eb:MessageData", [
          element("eb:MessageId", "1"),
          element("eb:Timestamp", dt)
        ])
      ]
    )
  end


  def security_header( username, password, pcc, domain \\ "DEFAULT") do

    element(
      "wsse:Security",
      %{
        "xmlns:wsse": "http://schemas.xmlsoap.org/ws/2002/12/secext",
        "xmlns:wsu": "http://schemas.xmlsoap.org/ws/2002/12/utility"
      },
      [
        element("wsse:UsernameToken", [
          element("wsse:Username", username),
          element("wsse:Password", password),
          element("Organization", pcc),
          element("Domain", domain)
        ])
      ]
    )
  end

  def pos(pcc) do

    element("POS", [
      element("Source", %{"PseudoCityCode": pcc})
    ])
  end

  def binary_token(token) do
    element(
      "wsse:Security", %{
        "xmlns:wsse": "http://schemas.xmlsoap.org/ws/2002/12/secext",
        "xmlns:wsu": "http://schemas.xmlsoap.org/ws/2002/12/utility"
      },
      [
        element(
          "wsse:BinarySecurityToken", %{
            "valueType": "String",
            "EncodingType": "wsse:Base64Binary"
          },
          token
        )
      ]
    )
  end


end