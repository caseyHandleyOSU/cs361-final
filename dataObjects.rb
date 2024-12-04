class GisJsonObj

  def initialize(type: nil, properties: nil, geometry: nil, features: nil)
    @hash = {
      type: type,
      properties: properties,
      geometry: geometry,
      features: features
    }
    @hash.compact!
  end

  def get_hash()
    return @hash
  end

  def to_json()
    return JSON.generate(@hash)
  end

end
