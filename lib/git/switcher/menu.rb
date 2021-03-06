module Git
  module Switcher

    Submenu = Struct.new(:label, :menu_items) do
      def to_s
        header = Rainbow(label).steelblue
        "\n\t#{header}\n\n" + menu_items.join("\n")
      end
    end

    MenuItem = Struct.new(:repo, :shortcut, :reference, :next) do
      HEAD = Rainbow(' <- HEAD ***').bold.aquamarine.freeze

      def head?
        reference.targets?(repo.head)
      end

      def to_s
        name = reference.name
        label = format('[%2s]', shortcut)
        format(
          "  %<label>s\t%<name>s%<head>s",
          label: head? ? Rainbow(label).bold : label,
          name: head? ? Rainbow(name).inverse : name,
          head: head? ? HEAD : '',
        )
      end
    end

    class Menu
      def self.for(repo)
        new(repo)
      end

      def initialize(repo)
        @repo = repo
        @submenus = submenus
        @menu_items = @submenus.map(&:menu_items).flatten
        @lookup = Hash[@menu_items.map(&:shortcut).zip(@menu_items)]
      end

      def [](shortcut)
        @lookup[shortcut]
      end

      def head_menu_item
        @menu_items.find(&:head?)
      end

      def default_menu_item
        head_menu_item&.next
      end

      def to_s
        @submenus.join("\n")
      end

      private

      def remote_branches
        @repo.branches.find_all(&:remote?)
      end

      def local_branches
        @repo.branches.find_all(&:local?)
      end

      def tags
        @repo.tags # TODO: distinguish between annotated and lightweight tags
      end

      def submenus
        shortcuts = (1..Float::INFINITY).each

        [
          submenu_for('REMOTE BRANCHES', remote_branches, shortcuts),
          submenu_for('LOCAL BRANCHES', local_branches, shortcuts),
          submenu_for('TAGS', tags, shortcuts),
        ].compact
      end

      def submenu_for(label, references, shortcuts)
        return unless references.any?

        Submenu.new(label, menu_items_for(references, shortcuts))
      end

      def menu_items_for(references, shortcuts)
        previous_menu_item = nil
        references.sort_by(&:time).map { |reference|
          shortcut = shortcuts.next.to_s
          next_menu_item = MenuItem.new(@repo, shortcut, reference, nil)
          previous_menu_item&.next = next_menu_item
          previous_menu_item = next_menu_item
          next_menu_item
        }
      end

    end
  end
end
