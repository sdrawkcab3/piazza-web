module AuthenticationHelpers
    def log_in(user, password: "Password11")
        post login_path, params: {
            user: {
                email: user.email,
                password: password
            }
        }
    end
end