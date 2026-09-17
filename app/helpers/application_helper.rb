# frozen_string_literal: true

module ApplicationHelper
  include AuthManagement

  def alert_classes(type)
    case type.to_s
    when "success", "notice"
      "bg-green-50 text-green-700"
    when "error", "alert"
      "bg-red-50 text-red-700"
    else
      "bg-blue-50 text-blue-700"
    end
  end
end
