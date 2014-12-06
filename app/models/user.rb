class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/
  
  # Include default devise modules. Others available are:
  # :database_authenticatable, :registerable, :validatable, :lockable, :timeoutable, :recoverable
  devise :rememberable, :trackable, :omniauthable, :confirmable, :async
  
  has_many :stop_requests, inverse_of: :user
  has_many :favorite_destinations, inverse_of: :user

  validates_presence_of :name, :email
  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  def self.find_for_oauth(auth, signed_in_resource = nil)
    
    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          #username: auth.info.nickname || auth.uid,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          photo_url:     auth.info.image,
          big_photo_url: auth.info.image,
          # password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation!
        user.save!
      end
    
    # Update user photos
    else
      user.update_columns(
        photo_url:     auth.info.image,
        big_photo_url: auth.info.image
      )
      user.touch
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end
  
  def photo_or_default_url
    self.photo_url || '/images/default.png'
  end
  
  def big_photo_or_default_url
    self.big_photo_url || '/images/default.png'
  end
  
  def predictor
    @predictor ||= Predictors::Cache.predictor_for(self)
  end
  
  def favorites_for(city, stop_sid)
    favorite_destinations.where(city: city, stop_sid: stop_sid, favorite: true).distinct.pluck(:destination)
  end

end
