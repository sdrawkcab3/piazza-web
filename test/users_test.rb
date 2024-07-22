require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
    test "can update name" do
        log_in(users(:jerry))

        visit profile_path

        fill_in User.human_attribute_name(:name), with: "Jerry Seinfeld"
        click_button I18n.t("users.show.save_profile")

        assert_selector "form .notification", text: I18n.t("users.update.success")
        assert_selector "#current_user_name", text: "Jerry Seinfeld"
    end
end