class Point
  attr_reader :lat, :lon, :ele

  def initialize(lon, lat, ele=nil)
    @lon = lon
    @lat = lat
    @ele = ele
  end

  def to_arr()
    arr = [lon, lat]
    if ele != nil
      arr.append(ele)
    end

    return arr
  end

end

class PointSegment

  def initialize(points: [])
    @points = points
  end

  def to_arr()
    points = []
    @points.each{ |point| 
      points.append(point.to_arr())
    }
    return points
  end

  def add(point)
    @points.append(point)
  end

end