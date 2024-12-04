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