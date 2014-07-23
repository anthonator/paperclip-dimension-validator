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
  has_attached_file :image

  validates_attachment :image, dimensions: { height: 30, width: 30 }
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
