class User < ApplicationRecord
    validates :name, presence: true
    validates :email,
        format: { with: URI::MailTo::EMAIL_REGEXP },
        uniqueness: { case_sensitive: false }

    has_many :memberships, dependent: :destroy
    has_many :organizations, through: :memberships  
    has_many :app_sessions

    before_validation :strip_extraneous_spaces

    has_secure_password
    validates :password, presence: true,
        length: { minimum: 8 }

    validates :password_confirmation, presence: true

    validate :password_complexity

    def self.create_app_session(email:, password:)
        user = User.find_by(email: email.downcase)
        return nil unless user&.authenticate(password)

        user.app_sessions.create
    end

    def authenticate_app_session(app_session_id, token)
        app_sessions.find(app_session_id).authenticate_token(token)
    rescue ActiveRecord::RecordNotFound
        nil
    end

    private

    def strip_extraneous_spaces
        self.name = self.name&.strip
        self.email = self.email&.strip
    end

    def password_complexity
        if password.present? and !password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{3,}$/)
            errors.add :password, 
                I18n.t("activerecord.errors.models.user.attributes.password.password_complexity", 
                field: I18n.t("activerecord.models.attributes.user.password"))
        end
    end
end
