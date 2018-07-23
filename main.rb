require 'sinatra'
require 'json'

typeToConversionType = {
  "scale" => method(:Integer),

  "bool" => ->(c) { (c.downcase == "true" || c.downcase == "yes") },
  "string" => method(:String),
  "int" => method(:Integer),
  "float" => method(:String),
  "date" => method(:String)
}

post '/' do
  payload = JSON.parse(request.body.read) unless params[:path]
  logger.info "Recieved #{payload}"

  unless payload["structure"]
    status 500
    return "JSON has have the key: structure"
  end

  unless payload["object"]
    status 500
    return "JSON has have the key: object"
  end

  transformedObject = {}

  payload["object"].each do |key, currentValue|
    structureType = payload["structure"][key]
    if typeToConversionType.key?(structureType)
      convertedValue = typeToConversionType[structureType].call(currentValue)
    else
      convertedValue = convertedValue
    end
    transformedObject[key] = convertedValue

  end

  content_type :json
  transformedObject.to_json
end
