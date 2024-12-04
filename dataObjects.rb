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

class ChildData

  def to_hash()
    @data.compact!
    return @data
  end

end

class Geometry < ChildData

  def initialize(type: nil, coordinates: [])
    @data = {
      type: type,
      coordinates: coordinates
    }
  end

  def set_type(type)
    @data[:type] = type
  end

  def set_coordinates(coordinates)
    @data[:coordinates] = coordinates
  end

end

class Properties < ChildData

  def initialize(title: nil, icon: nil)
    @data = {
      title: title,
      icon: icon
    }
  end

  def set_title(title)
    @data[:title] = title
  end

  def set_icon(icon)
    @data[:icon] = icon
  end

end