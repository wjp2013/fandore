class Backend::OrdersController < Backend::ApplicationController

  load_and_authorize_resource :class => "Order"

  def new
  end

  def index
    load_orders
  end

  def show
    load_order
  end

  def edit
    load_order
    build_order
  end

  def update
    load_order
    build_order
    save_order or render 'edit'
  end

  def update_state
    load_order
    if params[:event] == "delivery"
      redirect_to fill_in_express_admin_order_path(@order)
    else
      @order.update_state_with_track!(params[:event], current_user)
      redirect_to :back
    end
  end

  def fill_in_express
  end

  def create_express
    express_number = params[:express][:number]
    p express_number
  end

  private

  def load_orders
    @orders ||= order_scope.all
  end

  def load_order
    @order = order_scope.find(params[:id])
  end

  def build_order
    @order ||= order_scope.new
    @order.attributes = order_params
  end

  def save_order
    if @order.save
      if @order.line_items.collect(&:changed?).include? true
        @order.update_state_with_track!('change_line_item', current_user)
      end
      redirect_to admin_order_path(@order), notice: '订单更新成功.'
    end
  end

  def order_params
    order_params = params[:order]
    # order_params ? order_params.permit(:sku, :price, :position, option_value_ids: [], variant_properties_attributes: variant_properties_attributes) : {}
    order_params ? order_params.permit! : {}
  end

  def order_scope
    Order
  end

end
