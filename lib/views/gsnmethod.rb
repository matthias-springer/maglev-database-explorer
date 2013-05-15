# GsNMethod may not be modified
class GsNMethodProxy
  def self.for(method)
    instance = self.new
    instance.method = method
    instance
  end

  def method=(val)
    @method = val
  end

  def source_string
    @method.__evaluate_smalltalk('self sourceString')
  end

  def env_id
    @method.__evaluate_smalltalk('self environmentId')
  end

  def description_for_stack
    @method.__evaluate_smalltalk('self _descrForStack')
  end

  def selector
    @method.__evaluate_smalltalk('self selector')
  end

  def filename_line
    @method.__evaluate_smalltalk('self _fileAndLine')
  end

  def __for_database_explorer
    @method.__evaluate_smalltalk('{self sourceString. self environmentId. self selector. self _fileAndLine}')
  end
end

