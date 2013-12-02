class User < ActiveRecord::Base

  validates :name, presence: true

  def self.from_omniauth(auth)
  	User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || create_with_omniauth(auth)
  end

  def self.create_with_omniauth(auth)
  	User.create! do |user|

      puts auth

  		user.provider = auth["provider"]
  		user.uid = auth["uid"]

      # omniauth puts the id in auth["uid"], used above
      # user.id = auth["id"]                            #: "104902858181206516235",
      user.name = auth["info"]["name"]                  #: "Emil Pirfält",
      user.given_name = auth["info"]["first_name"]      #: "Emil",
      user.family_name = auth["info"]["last_name"]      #: "Pirfält",
      user.picture = auth["info"]["image"]              #: "https://lh6.googleusercontent.com/-_lWUgNIu90A/AAAAAAAAAAI/AAAAAAAAAE8/71yFXTVBJ3o/photo.jpg",
      user.gender = auth["extra"]["gender"]             #: "male",
      user.locale = auth["extra"]["locale"]             #: "en"
  	end
  end

end
