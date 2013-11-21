class User < ActiveRecord::Base
  has_many :recipe, :through => :user_recipe_history
  has_many :recipe, :through => :user_recipe_favourite

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
      # user.id = auth["id"]                           #: "104902858181206516235",
      user.name = auth["info"]["name"]                 #: "Emil Pirfält",
      user.given_name = auth["info"]["given_name"]     #: "Emil",
      user.family_name = auth["info"]["family_name"]   #: "Pirfält",
      user.link = auth["info"]["link"]                 #: "https://plus.google.com/104902858181206516235",
      user.picture = auth["info"]["picture"]           #: "https://lh6.googleusercontent.com/-_lWUgNIu90A/AAAAAAAAAAI/AAAAAAAAAE8/71yFXTVBJ3o/photo.jpg",
      user.gender = auth["info"]["gender"]             #: "male",
      user.locale = auth["info"]["locale"]             #: "en"

  	end
  end

end
