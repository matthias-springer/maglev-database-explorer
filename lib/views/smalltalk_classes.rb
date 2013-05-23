class DBEBootstrapChanges
  class << self
    def add(class_object, selector)
      @changes ||= []
      @changes.push([class_object, selector, class_object.__source_for_selector(selector, :smalltalk)[0]])
    end

    def undo_all_changes
      @changes ||= []
      @redo_changes = []

      @changes.each do |ch|
        @redo_changes.push([ch[0], ch[1], ch[0].__source_for_selector(ch[1], :smalltalk)[0]])
        ch[0].__compile(ch[2])
      end

      @changes = []
    end

    def redo_all_changes
      @redo_changes.each do |ch|
        ch[0].__compile(ch[2])
      end
    end
  end
end

# Save original method source that will be changed later
DBEBootstrapChanges.add(AbstractException, :signalNotTrappable)

# Change some Smalltalk methods
Object.__evaluate_smalltalk(File.open("./lib/views/smalltalk_classes.st", "r").read)

DBEHalt = __resolve_smalltalk_global(:DBEHalt)

