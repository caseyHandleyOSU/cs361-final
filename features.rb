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
