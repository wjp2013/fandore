class Frontend::ProductsController < Frontend::ApplicationController

  before_action :load_cart

  def index
    load_products
  end

  def show
    load_product
  end

  private
  
  def load_cart
    @cart = current_cart
  end

  def load_products
    @products ||= product_scope.all
  end

  def load_product
    @product ||= product_scope.find(params[:id])
    @variants = @product.variants_including_master.includes([:option_values])
    @product_properties = @product.product_properties.includes(:property)
  end

  def product_scope
    Product
  end
end
