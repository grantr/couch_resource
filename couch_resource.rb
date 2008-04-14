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

  end
end
