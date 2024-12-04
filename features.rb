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

  def get_hash()
    return create_json_obj().to_hash()
  end

  def get_json()
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
    coordinates = []
    @segments.each{ |segment| 
      seg_points = []
      segment.each{ |point| 
        point_as_arr = [point.lon, point.lat]
        seg_points.append(point.to_arr)
      }
      coordinates.append(seg_points)
    }
    @coordinates = coordinates

    return super
  end

end
