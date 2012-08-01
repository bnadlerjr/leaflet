module Rack
  module Test
    module Assertions
      def assert_flash_message(expected, type=:notice, message=nil)
        assert_flash(type, message)
        flash = last_request.env['rack.session']['flash'][type.to_s]
        msg = build_message(message, "expected flash to be <?> but was <?>", expected, flash)
        assert_block(msg) do
          expected == flash
        end
      end

      def assert_flash(type=:notice, message=nil)
        msg = build_message(message, "expected <?> flash to exist, but was nil", type.to_s)
        assert_block(msg) do
          last_request.env['rack.session']['flash']
        end
      end

      def assert_response(expected, message=nil)
        msg = build_message(message, "expected last response to be <?> but was <?>", expected, last_response.status)
        assert_block(msg) do
          last_response.send("#{expected}?")
        end
      end

      def assert_body_contains(expected, message=nil)
        msg = build_message(message, "expected body to contain <?>\n#{last_response.body}", expected)
        assert_block(msg) do
          last_response.body.include?(expected)
        end
      end
    end
  end
end