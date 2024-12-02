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

end

class Tracker

  def initialize(segments, name=nil)
    @name = name
    @segments = segments
  end

  def get_track_json()
    coordinates = []
    @segments.each{ |segment| 
      seg_points = []
      segment.each{ |point| 
        point_as_arr = [point.lon, point.lat]
        seg_points.append(point_as_arr)
      }
      coordinates.append(seg_points)
    }

    json_hash = { 
      type: "Feature", 
      properties: {
        title: "#{@name}"
      },
      geometry: {
        type: "MultiLineString",
        coordinates: coordinates
      }
    }

    return JSON.generate(json_hash)

  end

end

class Point
  attr_reader :lat, :lon, :ele

  def initialize(lon, lat, ele=nil)
    @lon = lon
    @lat = lat
    @ele = ele
  end

  def to_s
    return "#{@lat},#{@lon}#{@ele != nil ? ",#{@ele}" : ""}"
  end

end

class Waypoint
  attr_reader :lat, :lon, :ele, :name, :type

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

  def get_waypoint_json(indent=0)
    j = '{"type": "Feature",'
    # if name is not nil or type is not nil
    j += '"geometry": {"type": "Point","coordinates": '
    j += "[#{lon},#{lat}"
    if ele != nil
      j += ",#{ele}"
    end
    j += ']},'
    if name != nil or type != nil
      j += '"properties": {'
      if name != nil
        j += '"title": "' + @name + '"'
      end
      if type != nil  # if type is not nil
        if name != nil
          j += ','
        end
        j += '"icon": "' + @type + '"'  # type is the icon
      end
      j += '}'
    end
    j += "}"
    return j
  end
end

class World

  def initialize(name, things)
    @name = name
    @features = things
  end

  def add_feature(f)
    @features.append(t)
  end

  def to_geojson(indent=0)
    # Write stuff
    s = '{"type": "FeatureCollection","features": ['
    @features.each_with_index do |f,i|
      if i != 0
        s +=","
      end
        if f.class == Tracker
            s += f.get_track_json
        elsif f.class == Waypoint
            s += f.get_waypoint_json
      end
    end
    s + "]}"
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

