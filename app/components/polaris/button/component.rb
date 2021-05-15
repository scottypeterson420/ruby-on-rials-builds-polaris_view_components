# frozen_string_literal: true

module Polaris
  module Button
    class Component < Polaris::Component
      attr_reader :text_align, :size, :aria_expanded, :pressed, :disclosure

      DEFAULT_DISCLOSURE = 'down'
      DEFAULT_TEXT_ALIGN = 'center'
      DEFAULT_SIZE = 'medium'

      ALLOWED_ALIGNMENT = %w[left center right]
      ALLOWED_DISCLOSURES = %w[down up select]
      ALLOWED_SIZES = %w[slim medium large]

      validates :disclosure, inclusion: { in: ALLOWED_DISCLOSURES, message: "%{value} is not a valid disclosure" }, allow_blank: true, allow_nil: true
      validates :size, inclusion: { in: ALLOWED_SIZES, message: "%{value} is not a valid size" }, allow_blank: true, allow_nil: true
      validates :text_align, inclusion: { in: ALLOWED_ALIGNMENT, message: "%{value} is not a valid text_align" }, allow_blank: true, allow_nil: true
      validates_inclusion_of :aria_expanded, in: [true, false], allow_blank: true, allow_nil: true
      validates_inclusion_of :pressed, in: [true, false], allow_blank: true, allow_nil: true

      # TODO
      # Options missing:
      # - disclosure
      # - icon
      def initialize(
        accessibility_label: '',
        aria_controls: '',
        aria_described_by: '',
        aria_expanded: '',
        destructive: false,
        disabled: false,
        disclosure: nil,
        download: false,
        external: false,
        full_width: false,
        id: '',
        loading: false,
        monochrome: false,
        outline: false,
        plain: false,
        pressed: '',
        primary: false,
        role: '',
        size: nil,
        submit: false,
        text_align: nil,
        url: '',
        **args
      )
        super

        @accessibility_label = accessibility_label
        @aria_controls = aria_controls
        @aria_described_by = aria_described_by
        @aria_expanded = aria_expanded
        @destructive = destructive
        @disabled = disabled
        @disclosure = disclosure
        @download = download
        @external = external
        @full_width = full_width
        @id = id
        @loading = loading
        @monochrome = monochrome
        @outline = outline
        @plain = plain
        @pressed = pressed
        @primary = primary
        @role = role
        @size = size
        @submit = submit
        @text_align = text_align
        @url = url

        @tag = url.present? ? 'a' : 'button'
      end

      def disclosure_icon
        case @disclosure
          when 'down'
            '<path d="M5 8l5 5 5-5H5z"></path>'
          when 'up'
            '<path d="M15 12l-5-5-5 5h10z"></path>'
          when 'select'
            '<path d="M10 16l-4-4h8l-4 4zm0-12l4 4H6l4-4z"></path>'
        end
      end

      private

        def classes
          classes = ['Polaris-Button']

          classes << 'Polaris-Button--destructive' if @destructive
          classes << 'Polaris-Button--disabled' if @disabled
          classes << 'Polaris-Button--fullWidth' if @full_width
          classes << 'Polaris-Button--monochrome' if @monochrome
          classes << 'Polaris-Button--outline' if @outline
          classes << 'Polaris-Button--plain' if @plain
          classes << 'Polaris-Button--primary' if @primary
          classes << "Polaris-Button--size#{@size.camelize}" if @size.present?
          classes << "Polaris-Button--textAlign#{@text_align.camelize}" if @text_align.present?

          classes
        end

        def tag_attributes
          attrs = {
            type: @submit.present? ? 'submit' : 'button',
            disabled: @disabled,
          }

          attrs['aria-label'] = @accessibility_label if @accessibility_label.present?
          attrs['aria-controls'] = @aria_controls if @aria_controls.present?
          attrs['aria-describedby'] = @aria_described_by if @aria_described_by.present?
          attrs['aria-expanded'] = @aria_expanded.to_s if @aria_expanded.present?
          attrs['aria-pressed'] = @pressed.to_s if @pressed.present?
          attrs['role'] = @role if @role.present?
          attrs['id'] = @id if @id.present?

          if @loading
            attrs[:disabled] = true
            attrs['aria-busy'] = 'true'
          end

          if @url.present?
            attrs[:type] = nil
            attrs[:target] = '_blank' if @external
            attrs[:href] = @url
          end

          attrs
        end
    end
  end
end
