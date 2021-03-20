# frozen_string_literal: true

module Polaris
  module Labelled
    class Component < Polaris::Component
      include ComplexActionHelper

      validates :action, type: Action, allow_nil: true
      validates :index, numericality: { only_integer: true }, allow_nil: true

      attr_reader :action, :index

      def initialize(form:, attr:, id: "", label: "", error: "", action: nil, help_text: "", label_hidden: "", index: nil, **args)
        super

        @form = form
        @attr = attr
        @id = id
        @label = label
        @error = error
        @action = action
        @help_text = help_text
        @label_hidden = label_hidden
        @index = index
      end

      def label_attrs
        {
          form: @form,
          attr: @attr,
          hidden: false,
          index: @index,
        }
      end

      def error?
        @error.present? && @error.is_a?(String)
      end

      private

        def classes
          classes = []

          classes << "Polaris-Labelled--hidden" if @label_hidden

          classes
        end
    end
  end
end
