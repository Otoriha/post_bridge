require "test_helper"

class OmniauthCallbacksControllerTest < ActionDispatch::IntegrationTest
  test "should get github" do
    get omniauth_callbacks_github_url
    assert_response :success
  end

  test "should get twitter" do
    get omniauth_callbacks_twitter_url
    assert_response :success
  end

  test "should get failure" do
    get omniauth_callbacks_failure_url
    assert_response :success
  end
end
