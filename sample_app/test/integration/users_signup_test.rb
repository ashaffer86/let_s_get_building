require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "Find Signup Page" do
    get signup_path
    assert_template "users/new"
  end

  test "Invalid Form Submission" do

    assert_no_difference "User.count" do
      get signup_path
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
    assert_template 'users/show'
    assert_not flash.empty?
  end
end
