#!/usr/bin/env ruby

require "json"
require_relative "locations"
require_relative "dataObjects"
require_relative "features"

class FeatureCollection

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

  def get_json(indent=0)
    return create_json_obj().to_json()
  end
  
end

def main()

  w = Waypoint.new(point: Point.new(-121.5, 45.5, 30), name: "home", type: "flag")
  w2 = Waypoint.new(point: Point.new(-121.5, 45.6), name: "store", type: "dot")

  ts1 = [ Point.new(-122, 45), Point.new(-122, 46), Point.new(-121, 46), ]
  ts2 = [ Point.new(-121, 45), Point.new(-121, 46), ]
  ts3 = [ Point.new(-121, 45.5), Point.new(-122, 45.5), ]

  t = Track.new([ts1, ts2], "track 1")
  t2 = Track.new([ts3], "track 2")

  world = FeatureCollection.new("My Data", [w, w2, t, t2])

  puts world.to_geojson()

end

if File.identical?(__FILE__, $0)
  main()
end

