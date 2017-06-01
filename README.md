# Verb

VERB is the simple build tool for ERB-described Verilog project.
You can use VERB to initialize ERB-Verilog project,
create module and testbench templates, and build the rtl sources.

## Installation

First, you have to install `bundle` and `rake` by `gem install bundler rake`.
(To use `gem` for local install,
you should setup your own ruby environment using rbenv.)

And then execute:

  $ ./bin/setup

Or install it yourself as:

  $ bundle install
  $ rake build
  $ gem install -l pkg/verb-0.1.0.gem -V

## Usage

Start your project by setting up VERB project templates:

  $ verb init <project name>

Then, you can create RTL sources in the `rtl` sub-directory by:

  $ verb new <module name>

`new` command also create the testbench template in `test` sub-directory.

To build RTL sources, VERB simply uses Make as aliased sub-command like:

  $ verb (build)  # same as `make`

  $ verb test     # same as `make test`

  $ verb dist     # same as `make dist`



Project template also provides sample Vivado tcl scripts.

These tcl scripts have to be modified for fitting your project.

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake test` to run the tests.
You can also run `bin/console` for an interactive prompt
that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`,
and then run `bundle exec rake release`,
which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on
local GitLab at http://karafuto/gitlab/takau/verb.

## License

This tool is available under the terms of
the [MIT License](http://opensource.org/licenses/MIT).

