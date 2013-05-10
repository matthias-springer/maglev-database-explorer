class String
  def to_database_view(depth, ranges = {}, params = {})
    obj = super
    obj[:basetype] = :string

    return obj
  end

  primitive '__evaluate_smalltalk_in_context', 'evaluateInContext:'
end

