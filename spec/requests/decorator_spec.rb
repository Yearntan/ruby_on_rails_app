require 'rails_helper'

RSpec.describe PaginatingDecorator do
  describe 'pagination' do
    before do
      # Create a collection of objects to decorate
      # Assuming there's a model called `Item` for simplicity
      @items = Kaminari.paginate_array((1..100).map { |i| Item.new }).page(1).per(10)
      @decorated_collection = PaginatingDecorator.decorate(@items)
    end

    it 'preserves pagination' do
      # Test that the decorator doesn't interfere with pagination methods
      expect(@decorated_collection.current_page).to eq(1)
      expect(@decorated_collection.limit_value).to eq(10)  # 'per' value in Kaminari
      expect(@decorated_collection.total_pages).to eq(10)
    end

    it 'decorates each item' do
      # Ensures each item in the collection is decorated
      expect(@decorated_collection.first).to be_decorated
    end

    it 'responds to model methods' do
      # Assuming the decorated model has a method named `some_method`
      expect(@decorated_collection.first).to respond_to(:some_method)
    end
  end
end
