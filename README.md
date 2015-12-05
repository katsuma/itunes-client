# itunes-client [![Build Status](https://travis-ci.org/katsuma/itunes-client.png?branch=master)](https://travis-ci.org/katsuma/itunes-client) [![Coverage Status](https://coveralls.io/repos/katsuma/itunes-client/badge.png)](https://coveralls.io/r/katsuma/itunes-client)

`itunes-client` provides a high level API (like ActiveRecord style) to control your iTunes.


## Installation

Add this line to your application's Gemfile:

```sh
gem 'itunes-client'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install itunes-client
```

## Supported OS
- OSX Yosemite
- OSX Mavericks


## Supported Ruby
- 2.2.0
- 2.1.3
- 2.0.0
- 1.9.3

## Usage

```ruby
require 'itunes-client'
include Itunes

# Add a track to player
track = Itunes::Player.add(path_to_your_sound_file)

# Convert by default encoder
encoded_track = track.convert

# Find all tracks
tracks = Track.find_by(name: "Hello, Goodbye")
# => [#<Itunes::Track:0x007fdd38a1d430 @persistent_id="571B6412CDADBC93", @name="Hello, Goodbye", @album="1", @artist="The Beatles", @track_count="27", @track_number="19">]

track = tracks.first

# Play track
track.play

# Stop track
track.stop

# Control volume
volume = Itunes::Volume

# Decrease and increase the volume
volume.down(20)
volume.down      # default 10
volume.up(20)
volume.up       # default 10

# Mute and unmute the volume
volume.mute
volume.unmute

# Return volume value
volume.value
```

## License
`itunes-client` is released under the MIT License.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/katsuma/itunes-client/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
