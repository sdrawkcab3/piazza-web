require "test_helper"

class Users::PasswordsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:jerry)
    log_in(@user)
  end

  test "can change password" do
    patch users_change_password_path, params: {
      user: {
        current_password: "Password11",
        password: "new_Password11"
      }
    }

    assert_redirected_to profile_path
    assert @user.reload.authenticate("new_Password11")
  end

  test "error response if current password is incorrect" do
    patch users_change_password_path, params: {
      user: {
        current_password: "wrong",
        password: "new_Password11"
      }
    }

    assert_response :unprocessable_entity
  end

  test "error response is new password is invalid" do
    patch users_change_password_path, params: {
      user: {
        current_password: "Password11",
        password: "invalid"
      }
    }

    assert_response :unprocessable_entity
  end
end
