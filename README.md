# Jbuilder Serializer

Serializers integrated with jbuilder views.

Provides a class to handle variables assignment and uses a jbuilder view to define the JSON structure. Useful for using jbuilder outside of a controller `render` call.

## Usage

```ruby
# app/serializers/order_create_serializer.rb
class OrderCreateSerializer < JbuilderSerializer
  set_template_path File.expand_path('../views', __FILE__)

  locals do |attrs|
    @items = attrs[:items]
    @customer = attrs[:customer]
  end
end

# app/serializers/views/order_create.json.jbuilder
json.order_create do
  json.customer @customer, :name

  json.items @items do |item|
    json.product_name item.product.name
    json.product_id item.product_id
    json.product_url item.product.url
    json.quantity item.quantity
    json.price item.price
  end
end
```

Calling `to_json` on the jbuilder serializer instance will do the trick:
```ruby
OrderCreateSerializer.new(items: @items, customer: @customer).to_json
```

```json
{
  "order_create": {
    "customer": {
      "name": "John Doe"
    }
  },
  "items": [
    {
      "product_name": "Laptop 15'' Core i5",
      "product_id": "401db6bd42945385a1df3ed2b71a58fd",
      "product_url": "my-ecommerce.com/products/401db6bd42945385a1df3ed2b71a58fd",
      "quantity": 3,
      "price": 30000
    },
    {
      "product_name": "Wireless Mouse",
      "product_id": "1b0ecff49267942f9d1f49e0d6fcc451",
      "product_url": "my-ecommerce.com/products/1b0ecff49267942f9d1f49e0d6fcc451",
      "quantity": 3,
      "price": 2000
    },
    {
      "product_name": "Powerful headsets",
      "product_id": "646102e40a6b2c2d7609404fcefb19bf",
      "product_url": "my-ecommerce.com/products/646102e40a6b2c2d7609404fcefb19bf",
      "quantity": 3,
      "price": 4000
    }
  ]
}
```
