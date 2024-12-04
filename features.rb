class Feature

  TYPE = "Feature"

  def get_hash()
    return create_json_obj().to_hash()
  end

  def get_json()
    return create_json_obj().to_json()
  end

end
