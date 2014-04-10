module Aerogel::Pages
  module Traversal

    def self.page( id, lang )
      Page.find( id ).try( :content, lang )
    end

    def self.root( lang )
      Page.root.try( :content, lang )
    end

    def self.find( url, lang )
      root = Page.root
      traverse root, url.dup, lang
    end

    def self.traverse( page, url, lang )
      return page if page.nil? || url.blank?
      link = url.shift
      page = page.children.elem_match( page_contents: { lang: lang, link: link } ).first
      traverse page, url, lang
    end

    def self.find_closest_in_other_lang( page, lang )
      return page if page.content(lang)
      closest_page = page.ancestors.with_content( lang ).sort_by(&:depth).last
    end
  end # module Traversal
end # module Aerogel::Pages