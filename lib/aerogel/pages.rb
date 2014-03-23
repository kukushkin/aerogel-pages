require 'aerogel/core'
require 'aerogel/admin'
require "aerogel/pages/version"

module Aerogel
  module Pages
    # Your code goes here...
  end

  # Finally, register module's root folder
  register_path File.join( File.dirname(__FILE__), '..', '..' )
end

