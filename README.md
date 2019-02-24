# Git::Switcher

[![Build Status](https://secure.travis-ci.org/pvdb/git-switcher.png)](http://travis-ci.org/pvdb/git-switcher)

Visual CLI and REPL for easily switching between git tags and branches

## Installation

Add this line to your application's Gemfile:

    gem 'git-switcher'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git-switcher

## Usage

`cd` into your favourite git repo, and run `git switcher`

It will present you with a couple of submenus, one each for:

1. all **remote** branches
1. all **local** branches
1. all **reachable** tags

*(unless any of them are empty, in which case the corresponding submenu is omitted)*

            REMOTE BRANCHES

    [1]     origin/aaaaaa
    [2]     origin/bbbbbbb
    [3]     origin/cccccccc
    [4]     origin/ddddd
    [5]     origin/eeeeeee
    [6]     origin/master ***
    [7]     origin/ffffff
    [8]     origin/gggggggggg
    [9]     origin/pvandenb
    [10]    origin/hhhh

            LOCAL BRANCHES

    [11]    master ***
    [12]    pvandenb

            REACHABLE TAGS

    [a]     kernel_open_gets
    [b]     file_open_each
    [c]     file_foreach
    [d]     regexp_compile_match
    [e]     named_capture_group
    [f]     use_args_gets
    [g]     last_read_line
    [h]     ruby_minus_n
    [i]     ruby_minus_p

    Your selection > _

If the current git `HEAD` corresponds to any of the listed branches or tags, then the corresponding menu items are highlighted with `***`

Each menu item is prefixed with a shortcut key, either a *number* (for branches) or else a *letter* (for tags).

It will next prompt you for your selection as follows:

    Your selection > _

Enter one of the shortcut keys to quickly do a `git checkout` of the corresponding branch or tag.

It will then redraw the menu, so that the selected branch or tag is now highlighted, and so that the list of reachable tags is updated correspondingly.

`git switcher` will keep looping as described above, until you enter `quit` or else interrupt the script with either `^D` or `^C`.

## Default selection

To make it easy and convenient to sequentially loop through all branches or tags, `git switcher` will remember your previous selection, and offer the next menu item as the default.

For example, if you previously selected `11` to switch to the local `master` branch, then the next prompt presented by `git switcher` will be:

    ([12]   pvandenb) > _

To quickly switch to the `pvandenb` branch, just press `enter` *(without having to enter the corresponding shortcut key)*.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pvdb/git-switcher.
