require "fileutils"

module Shu
  module Util

    # @return [Pathname]
    def self.data_home()
      if (data_home = ENV["XDG_DATA_HOME"])
        return Pathname.new(data_home)
      end
      return Pathname.new(File.join(Dir.home, ".local", "share"))
    end

    # @param create [Boolean]
    # @return [Pathname]
    def self.data_dir(create: true)
      path = self.data_home().join("shu")
      FileUtils.mkdir_p(path) if create
      return path
    end

    # @return [Hash<Symbol>]
    def self.markdown_table_styles()
      return {
        border_top:    false,
        border_bottom: false,
        border_x:      "-",
        border_y:      "|",
        border_i:      "|",
      }
    end

    # Credit to (VK)(https://www.asciiart.eu/clothing-and-accessories/footwear)
    #
    # @return [String]
    def self.logo()
      return <<~SHOE
             ________
          __(_____  <|
         (____ / <| <|
         (___ /  <| L`-------.
         (__ /   L`--------.  \\
         /  `.    ^^^^^ |   \\  |
        |     \\---------'    |/
        |______|____________/]
        [_____|`-.__________]
      SHOE
    end

  end
end
