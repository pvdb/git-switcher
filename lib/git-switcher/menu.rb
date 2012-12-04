class Menu

  Struct.new("Submenu", :label, :menu_items) do
    def to_s
      "\n\t#{label}\n\n" + menu_items.join("\n")
    end
  end

  Struct.new("MenuItem", :shortcut, :label, :highlight, :command, :next) do
    def to_s
      "[%s]\t%s%s" % [shortcut.key, label, highlight ? ' ***' : '']
    end
  end

  Struct.new("Shortcut", :key, :calc_next_key) do
    def next
      self.class.new(self.calc_next_key.call(self.key), self.calc_next_key)
    end
  end

  attr_accessor :submenus
  attr_accessor :menu_items

  def initialize repo
    @repo = repo     # a git repository!
    @submenus = []   # addition-ordered!
    @menu_items = {} # keyed on shortcut
  end

  def to_s
    @submenus.join("\n")
  end

  def [] key
    @menu_items[key]
  end

  def shortcut_keys
    @menu_items.keys
  end

  def self.for repo
    self.new(repo).tap { |menu|

      shortcut = Struct::Shortcut.new('1', lambda { |key| (key.to_i + 1).to_s })
      menu.add_submenu_for("REMOTE BRANCHES", repo.remote_branches, shortcut) unless repo.remote_branches.empty?

      shortcut = Struct::Shortcut.new((repo.remote_branches.count + 1).to_s, lambda { |key| (key.to_i + 1).to_s })
      menu.add_submenu_for("LOCAL BRANCHES", repo.local_branches, shortcut) unless repo.local_branches.empty?

      shortcut = Struct::Shortcut.new('a', lambda { |key| (key.ord + 1).chr })
      menu.add_submenu_for("REACHABLE TAGS", repo.reachable_tags, shortcut) unless repo.reachable_tags.empty?

    }
  end

  def add_submenu_for label, refs, shortcut

    # calculate the new submenu: one menu item for each one of the refs
    submenu = Struct::Submenu.new(label, menu_items_for(refs, shortcut))

    # add the submenu to the main menu
    self.submenus << submenu

    # register each menu item of the new submenu via its shortcut key
    submenu.menu_items.each do |menu_item|
      self.menu_items[menu_item.shortcut.key] = menu_item
    end

  end

  def menu_items_for refs, shortcut

    previous_menu_item = nil
    next_shortcut = shortcut

    refs.map { |ref|

      menu_item = Struct::MenuItem.new(
        next_shortcut,
        abbreviated_name = @repo.abbreviated_name(ref),
        @repo.current_head?(ref),
        "git checkout #{abbreviated_name}",
        nil
      )

      # link the menu items together, to enable default selection
      previous_menu_item and previous_menu_item.next = menu_item

      previous_menu_item = menu_item
      next_shortcut = next_shortcut.next

      menu_item

    }

  end

end