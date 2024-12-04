class Point
  attr_reader :lat, :lon, :ele

  def initialize(lon, lat, ele=nil)
    @lon = lon
    @lat = lat
    @ele = ele
  end

  def to_arr
    arr = [lon, lat]
    if ele != nil
      arr.append(ele)
    end

    return arr
  end

end

class Waypoint
  attr_reader :name, :type

  TYPE = "Feature"
  GEO_TYPE = "Point"

  def initialize(lon, lat, ele=nil, name=nil, type=nil)
    @point = Point.new(lon, lat, ele) # Dependency... should this be passed in instead?
    @name = name
    @type = type
  end

  def lat
    return @point.lat
  end

  def lon
    return @point.lon
  end

  def ele
    return @point.ele
  end

  def get_hash()
    data = GisJsonObj.new(
      type: TYPE,
      properties: Properties.new(title: @name, icon: @type).to_hash(),
      geometry: Geometry.new(type: GEO_TYPE, coordinates: @point.to_arr).to_hash()
    )
    return data.get_hash()
  end

  def get_json(indent=0)
    return GisJson.gen(get_hash())
  end
  
end