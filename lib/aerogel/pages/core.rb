module Aerogel::Pages

  def self.registered(app)
    setup_reloader(app) if Aerogel.config.aerogel.reloader?

    # module initialization
    Aerogel::Pages.reset!
  end

  def self.setup_reloader(app)
    app.use Aerogel::Reloader, :'db/model', before: true do
      Aerogel::Pages.reset!
    end
  end

  def self.reset!
    @registered_page_block_types ||= {}
  end

  def self.registered_page_block_types
    @registered_page_block_types ||= {}
  end

  def self.register_page_block_type( type, model )
    registered_page_block_types[type] = model
  end

  def self.create_page_block( type, *args )
    type = type.to_sym
    if registered_page_block_types[type].nil?
      raise ArgumentError.new( "Invalid page block type: '#{type}'")
    end
    registered_page_block_types[type].new( *args )
  end

end # module Aerogel::Pages

