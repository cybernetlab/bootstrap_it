module BootstrapIt
  #
  module ViewHelpers
    #
    # SizableColumn
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    module SizableColumn
      extend ActiveSupport::Concern

      COLUMN_SIZE_REGEXP = /\A
        (?:col[-_]?)?
        (?<size>(?:
          xs
          |(?:extra[-_]?small))
          |(?:sm|small)
          |(?:md|medium)
          |(?:lg|large)
        )
        [-_]?
        (?<num>\d{1,2}
      )\z/x

      included do
        after_initialize do
          @arguments.extract!(
            Symbol, and: [COLUMN_SIZE_REGEXP]
          ).each { |arg| add_column_size(arg) }
        end
      end

      def column_size=(value)
        if value.is_a?(Array)
          value.each { |v| add_column_size(v) }
        else
          add_column_size(value)
        end
      end

      def column_size_defined?
        html_class?(/^col-(xs|sm|md|lg)-\d{1,2}/)
      end

      private

      def add_column_size(value)
        m = COLUMN_SIZE_REGEXP.match(value.to_s)
        size = ViewHelpers::COLUMN_SIZES[m[:size][0]]
        unless html_class?(/^col-#{size}-\d{1,2}/)
          add_html_class("col-#{size}-#{m[:num]}")
        end
      end
    end

    #
    # PlacableColumn
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    module PlacableColumn
      extend ActiveSupport::Concern

      COLUMN_PLACE_REGEXP = /\A
        (?:col[-_]?)?
        (?<size>(?:
          xs
          |(?:extra[-_]?small))
          |(?:sm|small)
          |(?:md|medium)
          |(?:lg|large)
        )
        [-_]?
        (?<act>offset|push|pull)
        [-_]?
        (?<num>\d{1,2})
      \z/x

      included do
        after_initialize do
          @arguments.extract!(
            Symbol, {and: [COLUMN_PLACE_REGEXP]}
          ).each { |arg| add_column_place(arg) }
        end
      end

      def column_place=(value)
        if value.is_a?(Array)
          value.each { |v| add_column_place(v) }
        else
          add_column_place(value)
        end
      end

      def column_offset_defined?
        html_class?(/^col-(xs|sm|md|lg)-offset-\d{1,2}/)
      end

      def column_push_defined?
        html_class?(/^col-(xs|sm|md|lg)-push-\d{1,2}/)
      end

      def column_pull_defined?
        html_class?(/^col-(xs|sm|md|lg)-pull-\d{1,2}/)
      end

      def column_place_defined?
        column_offset_defined? || column_push_defined? || column_pull_defined?
      end

      private

      def add_column_place(value)
        m = COLUMN_PLACE_REGEXP.match(value.to_s)
        size = ViewHelpers::COLUMN_SIZES[m[:size][0]]
        unless html_class?(/^col-#{size}-#{m[:act]}-\d{1,2}/)
          add_html_class("col-#{size}-#{m[:act]}-#{m[:num]}")
        end
      end
    end

    #
    # Contextual
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    module Contextual
      extend ActiveSupport::Concern
      included do
        enum :state, %i[active success warning danger], html_class_prefix: ''
      end
    end

    #
    # Activable
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    module Activable
      extend ActiveSupport::Concern
      included do
        switch :active, html_class: 'active'
      end
    end

    #
    # Disablable
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    module Disableable
      extend ActiveSupport::Concern
      included do
        switch :disabled, aliases: [:disable] do |value|
          if value
            if @tag == 'button'
              @options[:disabled] = 'disabled'
            else
              add_html_class('disabled')
            end
          else
            if @tag == 'button'
              @options.delete(:disabled)
            else
              remove_html_class('disabled')
            end
          end
        end
      end
    end

    #
    # Sizable
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    module Sizable
      extend ActiveSupport::Concern
      included do
        after_initialize do
          prefix = html_class_prefix
          re = prefix.empty? ? '' : "(#{prefix.gsub(/[-_]/, '[_-]')})?"
          skip = html_class?(/^#{html_class_prefix}(xs|sm|lg)$/)
          unless skip || @arguments.extract!(
            Symbol, and: [/^#{re}(sm|small)$/]
          ).empty?
            add_html_class("#{html_class_prefix}sm")
            skip = true
          end
          unless skip || @arguments.extract!(
            Symbol, and: [/^#{re}(lg|large)$/]
          ).empty?
            add_html_class("#{html_class_prefix}lg")
            skip = true
          end
          unless skip || @arguments.extract!(
            Symbol, and: [/^#{re}((xs)|(extra[-_]?small))$/]
          ).empty?
            add_html_class("#{html_class_prefix}xs")
            skip = true
          end
          if @options.key?(:size)
            size = @options.delete(:size)
            unless skip
              case size
              when /^#{re}(sm|small)$/
                add_html_class("#{html_class_prefix}sm")
              when /^#{re}(lg|large)$/
                add_html_class("#{html_class_prefix}lg")
              when /^#{re}((xs)|(extra[-_]?small))$/
                add_html_class("#{html_class_prefix}xs")
              end
            end
          end
        end
      end
    end

    #
    # Justifable
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    module Justifable
      extend ActiveSupport::Concern
      included do
        switch :justified, aliases: [:justify], html_class: true
      end
    end

    #
    # DropdownMenuWrapper
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    module DropdownMenuWrapper
      extend ActiveSupport::Concern

      included do |base|
        base <= WrapIt::Container || fail(
          TypeError, 'Can be included only into WrapIt::Container subclasses'
        )

        child :dropdown_menu, 'BootstrapIt::ViewHelpers::DropdownMenu'

        after_initialize do
          self.deffered_render = true
          dropdown_menu deffered_render: true
          @dropdown_menu = children.first
        end
      end

      def header(*args, &block)
        @dropdown_menu.header(*args, &block)
      end

      def divider(*args, &block)
        @dropdown_menu.divider(*args, &block)
      end

      def link_item(*args, &block)
        @dropdown_menu.link_item(*args, &block)
      end
    end

    protected

    COLUMN_SIZES = {'x' => 'xs', 'e' => 'xs', 's' => 'sm',
                    'm' => 'md', 'l' => 'lg'}
  end
end
