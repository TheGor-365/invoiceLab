# frozen_string_literal: true

module TimezoneHelper
  # Returns [["(+02:00) Europe/Vienna", "Europe/Vienna"], ...] sorted by UTC offset
  def timezone_options_for_select(selected = nil)
    zones = ActiveSupport::TimeZone.all.sort_by(&:utc_offset).map do |tz|
      # tz.formatted_offset -> "+02:00"
      # tz.tzinfo.identifier -> "Europe/Vienna"
      ["(#{tz.formatted_offset}) #{tz.tzinfo.identifier}", tz.tzinfo.identifier]
    end
    options_for_select(zones, selected)
  end
end
