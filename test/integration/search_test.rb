# frozen_string_literal: true

require "test_helper"

class SearchTest < ActionDispatch::IntegrationTest
  test "#index filters bulletins by title" do
    get root_path, params: { q: { title_cont: "велосипед" } }

    assert_response :success
    assert { @response.body.include?(bulletins(:published).title) }
    assert { @response.body.include?("Отдам котят") == false }
  end

  test "#index search button is visible for guests" do
    get root_path

    assert_response :success
    assert { @response.body.include?("Искать") }
  end
end
