require 'sinatra'
require 'json'

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
    if structureType == "scale"
      convertedValue = currentValue.to_i
    elsif structureType == "bool"
      convertedValue = (currentValue.downcase == "true" || currentValue.downcase == "yes")
    else
      convertedValue = currentValue
    end
    transformedObject[key] = convertedValue

  end

  content_type :json
  transformedObject.to_json
end
