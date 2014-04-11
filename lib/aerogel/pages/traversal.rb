module Aerogel::Pages
  module Traversal

    def self.page( id, lang )
      PageNode.find( id ).try( :page, lang )
    end

    def self.root( lang )
      Page.root(lang)
    end

    def self.find( url, lang )
      page = root(lang)
      traverse page, url.dup, lang
    end

    def self.traverse( page, url, lang )
      return page if page.nil? || url.blank?
      link = url.shift
      page = page.children.where( link: link ).first
      traverse page, url, lang
    end

    def self.find_closest_in_other_lang( page, lang )
      return page.page_node.page(lang) if page.page_node.page(lang).present?
      return root(lang) if page.root?
      find_closest_in_other_lang( page.parent, lang )
    end
  end # module Traversal
end # module Aerogel::Pages