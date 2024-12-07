class Feature

  TYPE = "Feature"
  GEO_TYPE = ""

  def create_json_obj()
    data = GisJsonObj.new(
      type: TYPE,
      properties: Properties.new(title: @name, icon: @type).to_hash(),
      geometry: Geometry.new(type: self.class::GEO_TYPE, coordinates: @coordinates).to_hash()
    )

    return data
  end

  def to_hash()
    return create_json_obj().to_hash()
  end

  def to_json()
    return create_json_obj().to_json()
  end

end

class Track < Feature

  GEO_TYPE = "MultiLineString"

  def initialize(segments, name=nil)
    @name = name
    @segments = segments
  end

  def create_json_obj()
    @coordinates = []
    @segments.each{ |segment| @coordinates.append(segment.to_arr()) }
    return super
  end

end

class Waypoint < Feature
  attr_reader :name, :type

  GEO_TYPE = "Point"

  def initialize(point:, name: nil, type: nil)
    @point = point
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

  def create_json_obj()
    @coordinates = @point.to_arr
    return super
  end

end