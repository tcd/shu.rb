require "test_helper"

module Test
  module Shu
    class UtilTest < Minitest::Test

      test ".logo" do
        refute_nil(::Shu::Util.logo())
      end

      test "logo returns a String" do
        logo = ::Shu::Util.logo()
        refute_nil(logo)
        assert_instance_of(String, logo)
      end

      test "data home returns a Pathname" do
        data_home = ::Shu::Util.data_home()
        refute_nil(data_home)
        assert_instance_of(Pathname, data_home)
      end

    end
  end
end
