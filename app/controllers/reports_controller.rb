class ReportsController < ApplicationController
  before_action :find_coupon_orders!, only: :index
  before_action :find_coupons!, only: :index

  def index
    #http://jameshuynh.com/rails/paginate/find_by_sql/2017/09/30/how-to-paginate-rails-find-by-sql-result/
    sql = <<-SQL
      SELECT products.name,
      SUM(order_items.quantity) as quantity, 
      SUM(order_items.price) as price
      FROM products, orders
      JOIN order_items ON order_items.order_id = orders.id
      WHERE (date(orders.created_at) > date('2020-07-25') )
      AND orders.state != 'canceled'
      AND order_items.order_id = orders.id
      AND order_items.source_id = products.id
      GROUP BY products.name
      ORDER BY quantity DESC
    SQL

    @orders ||= ActiveRecord::Base.connection.exec_query(sql)
  end

  private

  def find_coupons!
    @coupons ||= Coupon.all
  end

  def find_coupon_orders!
    sql = <<-SQL
      SELECT users.email,
      orders.count as order_count,
      SUM(orders.total) as revenue
      FROM users, orders
      JOIN order_items ON order_items.source_id = ($1) AND order_items.source_type = 'Coupon'
      WHERE orders.id = order_items.order_id
      AND orders.state != 'canceled'
      AND users.id = orders.user_id
      GROUP BY users.email
    SQL

    @coupon_orders ||= ActiveRecord::Base.connection.exec_query(sql, 'sql',  [[nil, params[:coupon_id]]])
  end

end
