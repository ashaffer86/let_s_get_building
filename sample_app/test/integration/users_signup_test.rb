require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "Find Signup Page" do
    get signup_path
    assert_template "users/new"
  end

  test "Invalid Form Submission" do

    get signup_path
    assert_no_difference "User.count" do
        post signup_path, params: {
        user: {
          name: "",
          email: "user@invalid",
          password: "foo",
          password_confirmation: "bar"
        }
      }
    end
    assert_template "users/new"
    assert_select("div#error_explanation")
    assert_select("div.field_with_errors")
  end

  test "Valid Form Submission" do

    assert_difference "User.count" do
      get signup_path
      post signup_path, params: {
        user: {
          name: "r_Test User",
          email: "r_test@somewhere.com",
          password: "password",
          password_confirmation: "password"
        }
      }
    end
    follow_redirect!
  #  assert_template 'users/show'
  #  assert_not flash.empty?
  #  assert is_logged_in?
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference "User.count", 1 do
      post signup_path, params: { user: {  name: "Example User",
                                          email: "user@example.com",
                                          password: "password",
                                          password_confirmation: "password"}}
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    #Try logging in
    log_in_as(user)
    assert_not is_logged_in?
    #Invalid activation token
    get edit_account_activation_url("Invalid token", email: user.email)
    assert_not is_logged_in?
    #valid token, wrong email
    get edit_account_activation_url(user.activation_token, email: "wrong")
    assert_not is_logged_in?
    #valid activation_token
    get edit_account_activation_url(user.activation_token, email: user.email)
    assert is_logged_in?
    assert user.reload.activated?
    follow_redirect!
    assert_template "users/show"
  end

end
