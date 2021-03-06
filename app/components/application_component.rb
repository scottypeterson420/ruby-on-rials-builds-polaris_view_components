require 'nokogiri'

class ApplicationComponent < ViewComponent::Base
  include ActiveModel::Validations

  def initialize(data: {}, aria: {}, html_options: {}, **args)
    @data = data
    @aria = aria
    @html_options = html_options
  end

  private

    def classes
      []
    end

    def additional_data
      {}
    end

    def additional_aria
      {}
    end

    def content_tag_options
      {
        class: classes.compact,
        data: @data.merge(additional_data),
        aria: @aria.merge(additional_aria)
      }.merge(@html_options)
    end

    def before_render
      validate!
    end

    def wrap_children!(css_class, additional_classes: [], exclusions: nil)
      return unless content.present?

      doc = Nokogiri::HTML(content)

      not_wrap = ":not(.#{css_class})"
      not_wrap << ":not(#{exclusions})" if exclusions.present?

      doc.css("body > *#{not_wrap}").each do |item|
        item.wrap("<div class='#{css_class} #{additional_classes.join(' ')}'></div>")
      end

      @_content = doc.css("body").first.inner_html
    end
end
