require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
  end

  test "unsuccesful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "",
                                              email: "foo@invalid",
                                              password: "foo",
                                              password_confirmation: "bar"}}
    assert_template('users/edit')
    assert_select("div#error_explanation li", count: 4)
  end

 test "successful edit" do
   log_in_as(@user)
   get edit_user_path(@user)
   assert_template 'users/edit'
   name = "name"
   email = "foo@bar.com"

   patch user_path(@user, params: {user: { name: name,
                                           email: email,
                                           password: "",
                                           password_confirmation: ""}})
   assert_not flash.empty?
   assert_redirected_to @user
   @user.reload
   assert_equal name, @user.name
   assert_equal email, @user.email
 end

 test "sucessful edit with friendly forwarding" do
   get edit_user_path(@user)
   log_in_as(@user)
   assert_redirected_to edit_user_url(@user)

   name = "name"
   email = "foo@bar.com"

   patch user_path(@user, params: {user: { name: name,
                                           email: email,
                                           password: "",
                                           password_confirmation: ""}})
   assert_not flash.empty?
   assert_redirected_to @user
   @user.reload
   assert_equal name, @user.name
   assert_equal email, @user.email
 end

 test "sucessful edit with friendly forwarding only once" do
   get edit_user_path(@user)
   log_in_as(@user)
   assert_redirected_to edit_user_url(@user)

   log_out
   log_in_as(@user)
   assert_redirected_to @user

   name = "name"
   email = "foo@bar.com"

   patch user_path(@user, params: {user: { name: name,
                                           email: email,
                                           password: "",
                                           password_confirmation: ""}})
   assert_not flash.empty?
   assert_redirected_to @user
   @user.reload
   assert_equal name, @user.name
   assert_equal email, @user.email
 end
end
