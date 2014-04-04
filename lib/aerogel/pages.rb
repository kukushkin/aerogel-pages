require 'aerogel/core'
require 'aerogel/admin'
require "aerogel/pages/version"
require "aerogel/pages/core"

module Aerogel

  # Finally, register module's root folder
  register_path File.join( File.dirname(__FILE__), '..', '..' )


  # configure module
  on_load do |app|
    app.register Aerogel::Pages
  end

end

