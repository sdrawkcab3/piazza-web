class User < ApplicationRecord
    include Authentication

    validates :name, presence: true
    validates :email,
        format: { with: URI::MailTo::EMAIL_REGEXP },
        uniqueness: { case_sensitive: false }

    has_many :memberships, dependent: :destroy
    has_many :organizations, through: :memberships  

    before_validation :strip_extraneous_spaces
    validates :password_confirmation, presence: true
    validate :password_complexity

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
