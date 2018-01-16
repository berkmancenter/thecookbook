class Recipe < ActiveRecord::Base
  acts_as_taggable_on :tags, :ingredients
  mount_uploader :image, ImageUploader

  belongs_to :user
  belongs_to :fork_origin, class_name: "Recipe"
  has_many   :forks, class_name: "Recipe", foreign_key: 'fork_origin_id'

  validates_presence_of :name, :directions, :user_id

  def fork(new_user)
    dup.tap do |forked_recipe|
      forked_recipe.user           = new_user
      forked_recipe.fork_origin_id = id
      forked_recipe.tag_list       = tag_list
      forked_recipe.image          = image
      forked_recipe.save
    end
  end

  def forked?
    !!fork_origin
  end
end
