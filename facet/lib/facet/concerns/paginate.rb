# frozen_string_literal: true

# Pagination allows you to segment records into a renderable subset.
module Facet
  module Paginate
    extend ActiveSupport::Concern

    included do
      delegate :default_page, :default_page?, :pagination?, to: :class
    end

    class_methods do
      def default_page
        default_page? ? @default_page : 1
      end

      def inherited(base)
        base.__send__(:page_default, @default_page) if default_page?
        super
      end

      def default_page?
        @default_page.present?
      end

      def pagination?
        return true unless defined?(@default_page)

        @default_page >= 1
      end

      private

      def disable_pagination!
        page_default(-1)
      end

      def page_default(value)
        @default_page = value
      end
    end
  end
end
