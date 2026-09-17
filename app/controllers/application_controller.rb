# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include AuthManagement

  allow_browser versions: :modern
end
