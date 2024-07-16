require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "requires a name" do
    @user = User.new( 
      name: "",
      email: "john1doe@example.com",
      password: "Password11",
      password_confirmation: "Password11"
    )
    assert_not @user.valid?

    @user.name = "John"
    assert @user.valid?
  end

  test "requires a valid email" do
    @user = User.new(
      name: "John", 
      email: "invalid",
      password: "Password11",
      password_confirmation: "Password11"
    )
    assert_not @user.valid?

    @user.email = "john1doe@example.com"
    assert @user.valid?
  end

  test "requires a unique email" do
    @existing_user = User.create(
      name: "John", 
      email: "jd5@example.com",
      password: "Password11",
      password_confirmation: "Password11"
    )
    assert @existing_user.persisted?

    @user = User.new(
      name: "Jon", 
      email: "jd5@example.com",
      password: "Password11",
      password_confirmation: "Password11"
    )
    assert_not @user.valid?
  end

  test "name and email is stripped of spaces before saving" do
    @user = User.create(
      name: " John",
      email: " johndoe@example.com ",
      password: "Password11",
      password_confirmation: "Password11"
    )
    assert_equal "John", @user.name
    assert_equal "johndoe@example.com", @user.email
  end
  
end
