require_relative '../test_helper'
require_relative '../../lib/leaflet/authorization'

module Leaflet
  class AuthorizationTest < Test::Unit::TestCase
    VALID_CREDENTIALS = 'YWRtaW46c2VjcmV0' # echo -n "admin:secret" | base64 -

    test "authorizes admin with correct credentials" do
      env = { "HTTP_AUTHORIZATION" => "Basic #{VALID_CREDENTIALS}\n" }
      auth = Authorization.new(env) {}
      assert(auth.admin?, "expected to be authorized as admin")
    end

    test "does not authorize admin with incorrect credentials" do
      env = { "HTTP_AUTHORIZATION" => "Basic InvalidCredentials\n" }
      auth = Authorization.new(env) {}
      refute(auth.admin?, "did not expect to be authorized as admin")
    end

    test "#protect execute block given if authorized as admin" do
      env = { "HTTP_AUTHORIZATION" => "Basic #{VALID_CREDENTIALS}\n" }
      auth = Authorization.new(env) do
        raise ArgumentError
      end

      assert_raises(NotImplementedError) do
        auth.protect do
          raise NotImplementedError
        end
      end
    end

    test "#protect executes not authorized block if not an admin" do
      auth = Authorization.new({}) do
        raise ArgumentError
      end

      assert_raises(ArgumentError) do
        auth.protect do
          raise NotImplementedError
        end
      end
    end

    test "raises an error if not authorized block is not given" do
      assert_raises(ArgumentError) do
        Authorization.new({})
      end
    end
  end
end