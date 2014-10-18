require 'active_support'
require 'action_controller'

# Wraps jbuilder into a serializer class, so it can be used outside of a controller action.
#
# == Usage
#
#   Create a serializer and define the `template_path` and `locals` for jbuilder view.
#
#   # app/serializers/order_create_serializer.rb
#   class OrderCreateSerializer < Jbuilder::Serializer
#     set_template_path File.expand_path('views', __dir__)
#
#     locals do |attrs|
#       @order = attrs[:order]
#       @author = attrs[:user]
#       @items = @order.items.select &:active?
#     end
#   end
#
#   Create your jbuilder view file and place it on the folder specified through `template_path`.
#
#   # app/serializers/views/order_create.json.jbuilder
#   json.order do
#     json.created_by @author.username
#     json.id @order.id
#     json.items @items do |item|
#       json.id item.id
#       json.quantity item.quantity
#     end
#   end
#
#   Then instantiate the serializer, providing its args for `locals` assignment.
#
#   serializer = OrderCreateSerializer.new(order: @order, user: current_user)
#   serializer.to_json
#   => "{\"order\": {\"created_by\": \"donald-duck\", \"id\":34, \"items\": [{\"id\": 78, \"quantity\": 1},{\"id\": 94, \"quantity\": 3}]}}"
#
module Jbuilder
  class Serializer
    class_attribute :locals_block, :template_path

    # Sets locals (instance variables) to be used within the jbuilder template.
    def self.locals(&block)
      raise ArgumentError, 'no block given' unless block_given?

      self.locals_block = block
    end

    # Sets path to look for jbuilder templates.
    def self.set_template_path(path)
      self.template_path = path
    end

    def self.inherited(base)
      base.class_eval do
        @locals_block = superclass.locals_block
        @template_path = superclass.template_path
      end
    end

    def initialize(*args)
      renderer.instance_exec *args, &locals_block if locals_block
    end

    # Jbuilder view name. By default, it has the same name as the serializer.
    def template_name
      self.class.name.demodulize.underscore.gsub '_serializer', ''
    end

    # Returns resulting json as string.
    def to_json
      renderer.render_to_string template: template_name, handler: :jbuilder
    end

    private

    def renderer
      @renderer ||= ActionController::Base.new.tap do |r|
        r.prepend_view_path template_path
        r.lookup_context.formats = [:json]
        r.lookup_context.handlers = [:jbuilder]
      end
    end
  end
end
