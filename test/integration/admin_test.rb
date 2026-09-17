# frozen_string_literal: true

require "test_helper"

class AdminTest < ActionDispatch::IntegrationTest
  setup do
    bulletins(:draft).image.attach(io: File.open("test/fixtures/files/test.png"), filename: "test.png")
  end

  test "#index lists bulletins on moderation for admin" do
    sign_in_by_github(email: users(:admin).email, admin: true)
    bulletins(:draft).to_moderate!

    get admin_root_path

    assert_response :success
    assert { @response.body.include?(bulletins(:draft).title) }
  end

  test "#index is closed for a regular user" do
    sign_in_by_github(email: users(:regular).email)

    get admin_root_path

    assert_redirected_to root_path
  end

  test "#publish moves a bulletin to published" do
    sign_in_by_github(email: users(:admin).email, admin: true)
    bulletins(:draft).to_moderate!

    patch publish_admin_bulletin_path(bulletins(:draft))

    assert_redirected_to admin_root_path
    assert { bulletins(:draft).reload.published? }
  end

  test "#reject returns a bulletin to the author" do
    sign_in_by_github(email: users(:admin).email, admin: true)
    bulletins(:draft).to_moderate!

    patch reject_admin_bulletin_path(bulletins(:draft))

    assert_redirected_to admin_root_path
    assert { bulletins(:draft).reload.rejected? }
  end

  test "#category create and update" do
    sign_in_by_github(email: users(:admin).email, admin: true)

    assert_difference -> { Category.count }, 1 do
      post admin_categories_path, params: { category: { name: "Спорттовары" } }
    end

    assert_redirected_to admin_categories_path

    patch admin_category_path(categories(:one)), params: { category: { name: "Цифровая техника" } }

    assert_redirected_to admin_categories_path
    assert { categories(:one).reload.name == "Цифровая техника" }
  end

  private

  def sign_in_by_github(email:, admin: false)
    post "#{auth_request_path('github')}?email=#{CGI.escape(email)}&admin=#{admin}"
    follow_redirect!
  end
end
