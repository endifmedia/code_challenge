class OrdersController < ApplicationController
  before_action :find_order!, only: :show
  before_action :all_orders, only: :index

  def index
    unless params[:number]
      @orders ||= @order_items.paginate(page: params[:page], per_page: 10)
    end
    @orders ||= Order.where(number: params[:number]).paginate(page: params[:page], per_page: 10)
  end

  def show
    @user_address ||= @order.user.addresses
  end

  private

  def all_orders
    @order_items ||= Order.all
  end

  def find_order!
    @order = Order.find_by!(number: params[:number])
  end
end
