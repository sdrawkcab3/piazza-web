class SessionsController < ApplicationController
    def new
    end

    def create
        @app_session = User.create_app_session(
            email: login_params[:email],
            password: login_params[:password]
        )

        if @app_session
            # TODO: Store details in a cookie

            flash[:success] = t(".success")
            redirect_to root_path, status: :see_other
        else
            flash.now[:danger] = t(".incorrect_details")
            render :new, status: :unprocessable_entity
        end
    end

    private
        def login_params
            # The `||=` (conditional assignment) operator only assigns a value if variable is nil or false, otherwise it short-circuits to the current value
            # This technique is called memoization, which is a programming technique to reduce the complexity of repeated operations within a routine.
            @login_params ||= 
                params.require(:user).permit(:email, :password)
        end
end
