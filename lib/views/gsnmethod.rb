# GsNMethod may not be modified

class Object
  private

  def __gsnmethod_to_database_view(obj, depth, ranges = {}, params = {})
    obj[:basetype] = :gsnmethod

    return obj
  end
end

