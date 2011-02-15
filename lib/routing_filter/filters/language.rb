# The language filter extracts segments matching /:language from the beginning of
# the recognized path and exposes the page parameter as params[:page]. When a
# path is generated the filter adds the segments to the path accordingly if
# the page parameter is passed to the url helper.
#
#   incoming url: /de/products/page/1
#   filtered url: /de/products
#   params:       params[:language] = 'de'
#
# You can install the filter like this:
#
#   # in config/routes.rb
#   Rails.application.routes.draw do
#     filter :language
#   end
#
# To make your named_route helpers or url_for add the pagination segments you
# can use:
#
#   products_path(:language => 'de')
#   url_for(:products, :language => 'de'))

require 'i18n'

module RoutingFilter
  class Language < Filter
    @@include_default_language = true
    cattr_writer :include_default_language

    class << self
      def include_default_language?
        @@include_default_language
      end

      def languages
        @@languages ||= I18n.available_locales.map{|l| l.to_sym}
      end

      def languages=(languages)
        @@languages = languages.map(&:to_sym)
      end

      #redefine original method to support locales like en-RU etc
      def languages_pattern
        @@languages_pattern ||= %r(^/(#{self.languages.map{|l| Regexp.escape(l.to_s).sub(/[A-Z]{2}$/,"[A-Z]{2}")}.join('|')})(?=/|$))
      end

    end

    def around_recognize(path, env, &block)
      language = extract_segment!(self.class.languages_pattern, path) # remove the language from the beginning of the path
      yield.tap do |params|                                       # invoke the given block (calls more filters and finally routing)
        params[:language] = language if language                  # set recognized language to the resulting params hash
      end
    end

    def around_generate(*args, &block)
      params = args.extract_options!                              # this is because we might get a call like forum_topics_path(forum, topic, :language => :en)

      language = params[:language]                           # extract the passed :language option
      language = I18n.locale if language.nil?  # default to I18n.locale when language is nil (could also be false)
      language = I18n.lang_tag(language) if language
      language = nil unless valid_language?(language)                   # reset to no language when language is not valid
       
      params.delete(:language) unless configatron.prevent_deleting_language_param

      args << params

      yield.tap do |result|
        prepend_segment!(result, language) if prepend_language?(language)
      end
    end

    protected

    def valid_language?(language)
      language && self.class.languages.include?(language.to_sym)
    end

    def default_language?(language)
      language && language.to_sym == I18n.lang_tag(I18n.default_locale).to_sym
    end

    def prepend_language?(language)
      language && (self.class.include_default_language? || !default_language?(language))
    end
  end
end
