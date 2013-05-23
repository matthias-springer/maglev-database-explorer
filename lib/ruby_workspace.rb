class RubyWorkspace
  def get_binding
    @binding ||= binding()
  end

  def evaluate(text)
    puts "RUBY WORKSPACE: #{text}"
    result = CodeEvaluation.wait_for_eval_thread do
      eval(text, get_binding)
    end

    store_object(result)
    result
  end

  def store_object(obj)
    Maglev::PERSISTENT_ROOT[:debug_storage] ||= {}
    Maglev::PERSISTENT_ROOT[:debug_storage][obj.object_id] = obj
  end

  def initialize
    store_object(self)
  end

  class << self
    def default_instance
      @default_instance ||= self.new
    end
  end
end
