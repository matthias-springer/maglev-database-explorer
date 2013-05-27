class Maglev::System
  class_primitive '__stone_version_report', 'stoneVersionReport'
  class_primitive '__gem_version_report', 'gemVersionReport'

  class_primitive '__commit_transaction', 'commitTransaction'
  class_primitive '__abort_transaction', 'abortTransaction'
  class_primitive '__continue_transaction', 'continueTransaction'

  class << self
    def __DBECommitTransaction
      DBEBootstrapChanges.undo_all_changes
      __commit_transaction
      DBEBootstrapChanges.redo_all_changes
      true
    end

    def __DBEAbortTransaction
      DBEBootstrapChanges.undo_all_changes
      __abort_transaction
      DBEBootstrapChanges.redo_all_changes
      true
    end

    def __DBEContinueTransaction
      __continue_transaction
    end

    def __basetype
      :systemClass
    end

    def to_database_view(depth, ranges = {}, params = {})
      obj = super

      if depth > 0
        params_all_elements = {:allElements => true}
        stone_version_report = __stone_version_report
        gem_version_report = __gem_version_report
        obj[:stoneVersionReport] = stone_version_report.to_database_view(depth - 1, ranges, params_all_elements)
        obj[:stoneVersionReportSize] = stone_version_report.size
        obj[:gemVersionReport] = gem_version_report.to_database_view(depth - 1, ranges, params_all_elements)
        obj[:gemVersionReportSize] = gem_version_report.size
      end

      return obj
    end
  end
end
