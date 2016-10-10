# chbuild

## Requirements
* Ruby 2.3.0+
* Docker (for Mac see [this](https://docs.docker.com/engine/installation/mac/#/docker-for-mac))

## Installation
1. Download the latest release of chbuild from [Cheppers GitLab](https://gitlab.cheppers.com/chbuild/chbuild)
2. `gem install --local path/to/chbuild.gem`

## Usage
```bash
$ chbuild help
Commands:
  chbuild --version, -V          # Current version
  chbuild build                  # Build the container image
  chbuild delete [-C] [-I] [-M]  # Delete container, image or MySQL container(s)
  chbuild help [COMMAND]         # Describe available commands or one specific command
  chbuild log                    # Get container log
  chbuild runc                   # Create and start the container
  chbuild up                     # Build and start everything
  chbuild validate               # Validate build definition file

Options:
  -v, [--verbose], [--no-verbose]
  -f, [--force]
```

### PHP
Current default PHP version: **5.6.25**

### MySQL connection
* no username
* password is 'admin'
* host: $MYSQL_PORT_3306_TCP_ADDR

## Development

After checking out the repo, run `bin/setup` to install dependencies.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

TODO: Figure out contribution with GitLab


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT). See more in LICENSE.txt
