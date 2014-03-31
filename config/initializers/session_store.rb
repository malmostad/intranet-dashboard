Dashboard::Application.config.session_store :cookie_store, {
  key: Rails.env.test? ? "_dashboard_test_session" : "_dashboard_session",
  secure: Rails.env.production? || Rails.env.test?,
  httponly: true
}
