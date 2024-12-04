#!/usr/bin/env ruby

require "json"
require_relative "locations"
require_relative "dataObjects"

class Track

  TYPE = "Feature"
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

    data = GisJsonObj.new(
      type: TYPE,
      properties: GisJson.properties(title: @name),
      geometry: GisJson.geometry(type: GEO_TYPE, coordinates: coordinates)
    )

    return data
  end

  def get_hash()
    return create_json_obj().get_hash()
  end

  def get_json()
    return create_json_obj().to_json()
  end

end

class World

  TYPE = "FeatureCollection"

  def initialize(name, features)
    @name = name
    @features = features
  end

  def add_feature(new_feature)
    @features.append(new_feature)
  end

  def create_json_obj()
    features = []
    @features.each {|feature| 
      features.append(feature.get_hash)
    }

    data = GisJsonObj.new(
      type: TYPE,
      features: features
    )
    
    return data
  end

  def get_hash()
    return create_json_obj().get_hash()
  end

  def get_json(indent=0)
    return create_json_obj().to_json()
  end
  
end

def main()

  w = Waypoint.new(-121.5, 45.5, 30, "home", "flag")
  w2 = Waypoint.new(-121.5, 45.6, nil, "store", "dot")
  ts1 = [
  Point.new(-122, 45),
  Point.new(-122, 46),
  Point.new(-121, 46),
  ]

  ts2 = [ Point.new(-121, 45), Point.new(-121, 46), ]

  ts3 = [
    Point.new(-121, 45.5),
    Point.new(-122, 45.5),
  ]

  t = Track.new([ts1, ts2], "track 1")
  t2 = Track.new([ts3], "track 2")

  world = World.new("My Data", [w, w2, t, t2])

  puts world.to_geojson()

end

if File.identical?(__FILE__, $0)
  main()
end

