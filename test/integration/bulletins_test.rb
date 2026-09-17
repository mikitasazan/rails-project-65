# frozen_string_literal: true

require "test_helper"

class BulletinsTest < ActionDispatch::IntegrationTest
  test "#index shows only published bulletins" do
    get root_path

    assert_response :success
    assert { @response.body.include?(bulletins(:published).title) }
    assert { @response.body.include?(bulletins(:draft).title) == false }
  end

  test "#new requires sign in" do
    get new_bulletin_path

    assert_redirected_to root_path
  end

  test "#create by a signed-in user" do
    sign_in_by_github(email: users(:regular).email)
    image = fixture_file_upload("test/fixtures/files/test.png", "image/png")
    attrs = { title: "Продам гараж",
              description: "Сухой гараж в центре, охрана, свет.",
              category_id: categories(:one).id,
              image: }

    assert_difference -> { Bulletin.count }, 1 do
      post bulletins_path, params: { bulletin: attrs }
    end

    assert_redirected_to profile_path
    saved = Bulletin.find_by!(title: "Продам гараж")
    assert { saved.user == users(:regular) }
    assert { saved.image.attached? }
  end

  test "#create without image fails" do
    sign_in_by_github(email: users(:regular).email)

    assert_no_difference -> { Bulletin.count } do
      post bulletins_path, params: { bulletin: { title: "Без фото",
                                                 description: "Описание есть, а фотографии нет.",
                                                 category_id: categories(:one).id } }
    end

    assert_response :unprocessable_entity
  end

  test "#update of own bulletin" do
    sign_in_by_github(email: users(:regular).email)
    bulletins(:draft).image.attach(io: File.open("test/fixtures/files/test.png"), filename: "test.png")

    patch bulletin_path(bulletins(:draft)),
          params: { bulletin: { title: "Отдам котят в добрые руки",
                                description: bulletins(:draft).description,
                                category_id: bulletins(:draft).category_id } }

    assert_redirected_to profile_path
    assert { bulletins(:draft).reload.title == "Отдам котят в добрые руки" }
  end

  private

  def sign_in_by_github(email:, admin: false)
    post "#{auth_request_path('github')}?email=#{CGI.escape(email)}&admin=#{admin}"
    follow_redirect!
  end
end
