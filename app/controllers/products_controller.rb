class ProductsController < ApplicationController
    # http_basic_authenticate_with name: "dhh", password: "secret", except: [:index, :show]
    skip_before_action :require_user, only: [:index, :show]
    def index
        # @products = Product.all
        @PER_PAGE = 12
        @current_page = [params.fetch(:page, 1).to_i, 1].max
        @total_pages = (Product.count.to_f / @PER_PAGE.to_f).ceil()
        @products = Product.search(params[:term], @PER_PAGE, @current_page)
    end

    def show
        @product = Product.find(params[:id])
    end

    def new
        @product = Product.new
    end

    def edit
        redirect_not_same_user
        @product = Product.find(params[:id])
    end

    # def create
    #     render plain: params[:product].inspect
    # end

    def create
        # @current_user ||= User.find(session[:user_id]) if session[:user_id]
        @current_user = current_user

        # @product = Product.new(product_params)
        @product = @current_user.products.new(product_params)

        if @product.save
            redirect_to @product
          else
            render 'new'
        end
    end

    def update
        redirect_not_same_user
        @product = Product.find(params[:id])
        if @product.update(product_params)
          redirect_to @product
        else
          render 'edit'
        end
    end

    def destroy
        redirect_not_same_user
        @product = Product.find(params[:id])
        @product.destroy

        redirect_to products_path
    end

    def generate
        10.times do
            @current_user = current_user
            @product = @current_user.products.create(
                product_name: Faker::Commerce.product_name,
                category: Faker::Commerce.department.downcase,
                price: "#{Faker::Commerce.price}",
                description: Faker::Lorem.paragraph,
                contact_email: Faker::Internet.email,
                cover: Faker::LoremFlickr.image(size: "640x480")
            )
        end
        redirect_to products_path
    end

    def clean
        @current_user.products.destroy_all
        redirect_to products_path
    end

    def dashboard
        @PER_PAGE = 12
        @current_page = [params.fetch(:page, 1).to_i, 1].max
        @total_pages = (Product.count.to_f / @PER_PAGE.to_f).ceil()
        @products = Product.offset((@current_page-1) * @PER_PAGE).limit(@PER_PAGE).where(user_id: @current_user.id)
        render :template => "products/index.html.erb"
    end

    private
    def product_params
        params.require(:product).permit(:product_name, :category, :description, :price, :contact_email, :cover, :term)
    end

    private
    def redirect_not_same_user
        @product = Product.find(params[:id])
        if current_user.id != @product.user.id
            redirect_to products_path
        end
    end
end
