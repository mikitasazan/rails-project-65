# frozen_string_literal: true

require "test_helper"

class AuthFlowTest < ActionDispatch::IntegrationTest
  test "#callback creates a user and signs in" do
    assert_difference -> { User.count }, 1 do
      sign_in_by_github(email: "someone@test.com")
    end

    assert_redirected_to root_path
    assert { User.find_by(email: "someone@test.com") }
  end

  test "#callback marks an admin when asked to" do
    sign_in_by_github(email: "boss@test.com", admin: true)

    assert { User.find_by(email: "boss@test.com")&.admin? == true }
  end

  test "#logout resets the session" do
    sign_in_by_github(email: users(:regular).email)

    delete auth_logout_path

    assert_redirected_to root_path
  end

  private

  # Тот же путь, что и e2e-проверка: OmniAuth в test-режиме строит
  # сессию из query-параметров запроса.
  def sign_in_by_github(email:, admin: false)
    post "#{auth_request_path('github')}?email=#{CGI.escape(email)}&admin=#{admin}"
    follow_redirect!
  end
end
