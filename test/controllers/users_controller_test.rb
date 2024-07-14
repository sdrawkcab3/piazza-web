require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "redirects to feed after successful sign up" do
    get sign_up_path
    assert_response :ok

    assert_difference ["User.count", "Organization.count"], 1 do
      post sign_up_path, params: {
        user: {
          name: "John",
          email: "johndoe@example.com",
          password: "securePass1",
          password_confirmation: "securePass1"
        }
      }
    end

    assert_redirected_to root_path
    follow_redirect!
    assert_select ".notification.is-success",
      text: I18n.t("users.create.welcome", name: "John")
  end

  test "renders errors if input data is invalid" do
    get sign_up_path
    assert_response :ok
    
    assert_no_difference [ "User.count", "Organization.count" ] do
      post sign_up_path, params: {
        user: {
          name: "John",
          email: "johndoe@example.com",
          password: "pass",
          password_confirmation: "pass"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select "p.is-danger",
      text:
        "#{I18n.t(
          'activerecord.errors.models.user.attributes.password.too_short'
        )} and #{I18n.t(
          'activerecord.errors.models.user.attributes.password.password_complexity'
        )}"
  end

  test "renders error if passwords and confirmation mismatch" do
    get sign_up_path
    assert_response :ok

    assert_no_difference [ "User.count", "Organization.count" ] do
      post sign_up_path, params: {
        user: {
          name: "John",
          email: "johndoe@example.com",
          password: "Password1",
          password_confirmation: "Password2"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select "p.is-danger",
    text:
      I18n.t(
        'activerecord.errors.models.user.attributes.password_confirmation.confirmation'
      )
  end

end
