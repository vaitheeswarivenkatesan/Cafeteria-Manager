class MenuItemsController < ApplicationController
  before_action :ensure_user_logged_in
  before_action :ensure_owner, only: [:update, :create, :destroy, :edit]

  def index
    @menu_category_id = params[:menu_category_id]
    @menu_category_name = MenuCategory.find(@menu_category_id).menu_category_name
    @menu_items = MenuItem.where("menu_category_id = ?", @menu_category_id).active
    if params[:status] == "Inactive" && @current_user.is_owner?
      @menu_items = MenuItem.where("menu_category_id = ?", @menu_category_id).not_active
    end
    render "index"
  end

  def create
    new_menu_item = MenuItem.new(
      menu_category_id: params[:menu_category_id],
      name: params[:name].capitalize,
      description: params[:description].capitalize,
      price: params[:price],
      status: true,
    )
    if new_menu_item.save
    else
      flash[:error] = new_menu_item.errors.full_messages.join(", ")
    end
    redirect_back(fallback_location: root_path)
  end

  def update
    id = params[:id]
    menu_item = MenuItem.find(id)
    menu_item.name = params[:name]
    menu_item.description = params[:description]
    menu_item.price = params[:price]
    menu_item.status = params[:status]
    menu_item.save!
    redirect_to menu_items_path(menu_category_id: menu_item.menu_category_id)
  end

  def destroy
    id = params[:id]
    menu_item = MenuItem.find(id)
    menu_item.destroy
    redirect_back(fallback_location: root_path)
  end
end
