class RecipePresenter < ApplicationPresenter
  def initialize(recipe)
    @recipe = recipe
  end

  attr_reader :recipe

  delegate :id, :name, :user, :source, :directions, :image,
    :forked?, :intro_text, to: :recipe

  def tag_links
    return if recipe.tags.empty?
    recipe.tags.map do |tag|
      h.link_to tag.name, "/tags/#{tag.name}"
    end.join(", ").html_safe
  end

  def ingredient_links
    return if recipe.ingredients.empty?
    recipe.ingredients.map do |tag|
      h.link_to tag.name, "/tags/#{tag.name}"
    end.join(", ").html_safe
  end

  def created_by
    h.link_to user.name, "/users/#{user.id}/#{(user.name || "").parameterize}"
  end

  def fork_origin_link
    if origin = recipe.fork_origin
      text = "#{origin.user.name}'s #{origin.name}"
      "Forked from ".html_safe + h.link_to(text, fork_origin_path)
    end
  end

  def fork_origin_icon_link
    if origin = recipe.fork_origin
      text = "#{origin.user.name}'s #{origin.name}"

      h.link_to h.content_tag(:i, nil, class: 'fa fa-cutlery'),
                fork_origin_path, title: "Forked from #{text}"
    end
  end

  def source
    h.link_to(recipe.source, recipe.source) if recipe.source.present?
  end

  def to_param
    "#{recipe.id}/#{recipe.name.parameterize}"
  end

  def fork_link(current_user)
    text = "Fork this recipe"
    url  = "/recipes/#{id}/fork"
    icon = h.content_tag(:i, nil, class: 'fa fa-cutlery')
    options = {
      method: :post,
      class: 'btn btn-primary btn-fork',
      title: 'Make it your own!'
    }


    if user = current_user
      if forked_recipe = user.recipes.where(fork_origin_id: recipe.id).first
        text = "View your fork"
        url  = "/recipes/#{forked_recipe.id}"
        options.delete(:method)
        options.delete(:title)
      end
    end

    h.link_to [icon, text].join(' ').html_safe, url, options
  end

  private

  def fork_origin_path
    origin = recipe.fork_origin
    "/recipes/#{origin.id}/#{origin.name.parameterize}"
  end
end
