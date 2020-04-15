class Product < ApplicationRecord
    belongs_to :user

    validates :product_name, presence: true, length: { minimum: 1 }

    def self.search(term, per_page, current_page)
        if term
            Product.offset((current_page-1) * per_page).limit(per_page).where("category LIKE ?", "%#{term}%")
        else
            # @products = Product.all
            Product.offset((current_page-1) * per_page).limit(per_page)

        end
    end
end
