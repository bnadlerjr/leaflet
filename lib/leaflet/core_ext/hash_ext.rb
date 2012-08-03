module Leaflet
  module CoreExt
    module HashExt
      def symbolize_keys!
        keys.each do |key|
          self[(key.to_sym rescue key) || key] = delete(key)
        end
        self
      end

      def symbolize_keys
        dup.extend(HashExt).symbolize_keys!
      end
    end
  end
end