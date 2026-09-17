# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV.fetch("GITHUB_CLIENT_ID", ""), ENV.fetch("GITHUB_CLIENT_SECRET", ""), scope: "user"
end

if Rails.env.test?
  OmniAuth.config.test_mode = true

  # Placeholder AuthHash: before_callback_phase replaces it with data from params.
  OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
    provider: "github",
    uid: "",
    info: { email: "", name: "" },
    extra: { admin: false }
  )

  # E2E-проверка входит пользователями без GitHub: в test-окружении OmniAuth
  # строит сессию из параметров запроса (email, admin).
  OmniAuth.config.before_callback_phase do |env|
    params = env["omniauth.params"] || {}
    email = params["email"] || "user@test.com"
    env["omniauth.auth"] = OmniAuth::AuthHash.new(
      provider: "github",
      uid: email,
      info: { email:, name: email.split("@").first },
      extra: { admin: params["admin"] == "true" }
    )
  end
end
