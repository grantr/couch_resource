require 'lib/active_resource.rb'

module CouchResource
  class Base < ActiveResource::Base

    class << self
      def format
        ActiveResource::Formats[:json]
      end

      def element_path(id, prefix_options = {}, query_options = nil)
        "#{prefix(prefix_options)}#{id}#{query_string(query_options)}"
      end
    end

    def load(attributes)
      raise ArgumentError, "expected an attributes Hash, got #{attributes.inspect}" unless attributes.is_a?(Hash)
      @prefix_options, attributes = split_options(attributes)
      attributes.each do |key, value|
        @attributes[key.to_s] =
          case value
            when Array
              resource = find_or_create_resource_for_collection(key)
              value.map { |attrs| attrs.is_a?(Hash) ? resource.new(attrs) : (attrs.dup rescue attrs) }
            when Hash
              resource = find_or_create_resource_for(key)
              resource.new(value)
            else
              value.dup rescue value
          end
      end
      self
    end    
  end
end
