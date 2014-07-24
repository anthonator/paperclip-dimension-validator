# paperclip-dimension-validator

Validate them dimensions!

## Installation

Add this line to your application's Gemfile:

    gem 'paperclip-dimension-validator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install paperclip-dimension-validator

## Usage

This gem introduces the ```dimensions``` validator for Paperclip's
```validates_attachment```. ```dimensions``` accepts a hash of ```height``` and
``` width``` integer pixel values.

**Example**
```ruby
class Image < ActiveRecord::Base
  has_attached_file :avatar

  validates_attachment :avatar, dimensions: { height: 30, width: 30 }
end
```

## Testing

paperclip-dimension-validator includes rspec-compatible matchers for testing.

**Note** In order to use these matchers make sure to include either [chunky_png](https://github.com/wvanbergen/chunky_png) or
[oily_png](https://github.com/wvanbergen/oily_png) as a dependency in your Gemfile.

**Gemfile**

```ruby
group :test do
  gem 'chunky_png'
end
```

**RSpec**

In spec_helper.rb, you'll need to require the matchers:

```ruby
require 'paperclip/matchers/validate_attachment_dimesions_matcher'
```

And include the paperclip matchers module:

```ruby
RSpec.configure do |config|
  config.include Paperclip::Shoulda::Matchers
end
```

**Example**

```ruby
it { should validate_attachment_dimensions(:avatar).height(30).width(30) }
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
