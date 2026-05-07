require "rails_helper"

RSpec.describe Product, type: :model do
  it "cria um produto válido" do
    product = Product.new(
      name: "Produto teste",
      description: "Descrição do produto",
      price: 99.90
    )

    expect(product).to be_valid
  end
end
