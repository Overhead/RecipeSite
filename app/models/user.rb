class User < ActiveRecord::Base
  has_many :recipe, :through => :user_recipe_history
  has_many :recipe, :through => :user_recipe_favourite

  validates :name, presence: true

  def self.from_omniauth(auth)
  	User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || create_with_omniauth(auth)
  end

  def self.create_with_omniauth(auth)
  	User.create! do |user|
  		user.provider = auth["provider"]
  		user.uid = auth["uid"]
  		user.name = auth["info"]["name"] || "Anonymous"
  	end
  end

end
