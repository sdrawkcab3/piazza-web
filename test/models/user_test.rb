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

  test "password lengths must be between 8 and ActiveModel's maximum" do
    @user = User.new(
      name: "Jane",
      email: "janedoe@example.com",
      password: "La2",
      password_confirmation: "La2"
    )
    assert_not @user.valid?

    @user.password = "Password11"
    @user.password_confirmation = "Password11"
    assert @user.valid?

    max_length =
      ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED
    @user.password = "a" * (max_length + 1)
    assert_not @user.valid?
  end

  test "can create a session with email and correct password" do
    @app_session = User.create_app_session(
      email: "jerry@example.com",
      password: "Password11"
    )
    assert_not_nil @app_session
    assert_not_nil @app_session.token
  end

  test "cannot create a session with email and incorrect password" do
    @app_session = User.create_app_session(
      email: "jerry@example.com",
      password: "WRONGPASS1"
    )

    assert_nil @app_session
  end

  test "creating a session with non existant email returns nil" do
    @app_session = User.create_app_session(
      email: "whoami@example.com",
      password: "WRONGPASS1"
    )

    assert_nil @app_session
  end

  test "can authenticate with a valid session id and token" do
    @user = users(:jerry)
    @app_session = @user.app_sessions.create

    assert_equal @app_session, @user.authenticate_app_session(@app_session.id, @app_session.token)
  end

  test "trying to authenticate with a roken that doesn't exist returns false" do
    @user = users(:jerry)

    assert_not @user.authenticate_app_session(50, "token")
  end
  
end
