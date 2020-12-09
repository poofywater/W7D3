class User < ApplicationRecord

    validates :email, uniqueness: true, presence: true                  #V
    validates :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: true
    validates :password, length: {minimum: 6}, allow_nil: true

    attr_reader :password                                               #A
    after_initialize :ensure_session_token

    def self.find_by_credentials(username, password)                    #F
        user = User.find_by(email: username)
        return nil if user.nil?
        user.is_password?(password)? user : nil
    end

    def self.generate_session_token                                     #G
        SecureRandom.urlsafe_base64(16)
    end

    def reset_session_token!                                            #R
        self.session_token = self.class.generate_session_token   
        self.save!
        self.session_token
    end

    def ensure_session_token                                            #E
        self.session_token ||= self.class.generate_session_token
    end

    def password=(password)                                             #P
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)                                                    #I
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end
    
end