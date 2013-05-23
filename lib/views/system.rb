class Maglev::System
  class_primitive '__stone_version_report', 'stoneVersionReport'
  class_primitive '__gem_version_report', 'gemVersionReport'

  class << self
    def to_database_view(depth, ranges = {}, params = {})
      obj = super
      obj[:basetype] = :systemClass

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
