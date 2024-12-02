#!/usr/bin/env ruby

require "json"

class GisJson

  def self.properties(title: nil, icon: nil)
    properties = {
      title: title,
      icon: icon
    }
    properties.compact!

    return properties
  end

  def self.geometry(type: nil, coordinates: [])
    geometry = {
      type: type,
      coordinates: coordinates
    }
    geometry.compact!

    return geometry
  end

  def self.gen(hash)
    return JSON.generate(hash)
  end

end

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

class Tracker

  TYPE = "Feature"
  GEO_TYPE = "MultiLineString"

  def initialize(segments, name=nil)
    @name = name
    @segments = segments
  end

  def get_hash()
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
    return data.get_hash()
  end

  def get_json()
    return GisJson.gen(get_hash())
  end

end

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
    @point = Point.new(lon, lat, ele)
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
      properties: GisJson.properties(title: @name, icon: @type),
      geometry: GisJson.geometry(type: GEO_TYPE, coordinates: @point.to_arr)
    )
    return data.get_hash()
  end

  def get_json(indent=0)
    return GisJson.gen(get_hash())
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

  def get_hash()
    features = []
    @features.each {|feature| 
      features.append(feature.get_hash)
    }

    data = GisJsonObj.new(
      type: TYPE,
      features: features
    )

    return data.get_hash()
  end

  def get_json(indent=0)
    return GisJson.gen(get_hash())
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

  t = Tracker.new([ts1, ts2], "track 1")
  t2 = Tracker.new([ts3], "track 2")

  world = World.new("My Data", [w, w2, t, t2])

  puts world.to_geojson()

end

if File.identical?(__FILE__, $0)
  main()
end

