module JsonParser
  def jsonParseHelper
    JSON.parse(response.body)
  end
end