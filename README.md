# JRubyArt
[![Gem Version](https://badge.fury.io/rb/jruby_art.svg)](http://badge.fury.io/rb/jruby_art)

## Requirements
A clean start for `jruby_art` based on processing-3.0 alpha and jruby-9.0.0.0  [wiki](https://github.com/ruby-processing/JRubyArt/wiki/Building-latest-gem) for building gem from this repo.
## Requirements
 
A suitable version of ruby (MRI ruby > 2.1 or `jruby-9.0.0.0` to download gem. 

`processing-3.0a11+`

`jdk1.8.0_51+` can be openjdk with OpenJFX _a separate download works on ArchLinux_ probably safer to go with the Oracle version

### recommended installs (JRubyArt is currently hard-coded to expect them)

`processing video and sound libraries` _install from the processing-3.0a11 ide_


## Configuration

Config file is `config.yml` in `~/.jruby_art folder` so can co-exist with a ruby-processing install

```yaml
# YAML configuration file for jruby_art
# K9_HOME: "/home/ruby2.2.0 ... /jruby_art" #windows users may need to set this
PROCESSING_ROOT: /home/tux/processing-3.0a11
sketchbook_path: /home/tux/sketchbook
```

## Install Steps (assumes you have requirements above) 

```bash
 gem install jruby_art
 k9 setup install # installs jruby-complete-9.0.0.0
 k9 setup unpack_samples # downloads and installs samples to ~/k9_samples
 cd ~/k9_samples/contributed
 k9 --nojruby run jwishy.rb # unless you have jruby-9.0.0.0 installed or config JRUBY: 'false'
 k9 run jwishy.rb # if you have jruby-9.0.0.0 installed or config JRUBY: 'false'
```
## Create sketches from built in templates
```bash
k9 create fred 200, 200               # basic FX2D sketch fred.rb
k9 create fred 200, 200, p2d          # basic P2D sketch fred.rb
k9 create fred 200, 200 --wrap        # class wrapped FX2D sketch fred.rb
k9 create fred 200, 200, p2d --wrap   # class wrapped P2D sketch fred.rb
```

## Simple Sketch
```ruby
# :sketch_title belongs in setup it is a convenience method of jruby_art-3.0
def setup
  sketch_title 'My Sketch'
end

def draw
  background 0
  fill 200
  ellipse width / 2, height / 2, 300, 200
end

# size goes here since processing-3.0a10, the processing guys hide this
# by doing pre-processing on the pde file (check the java output).
# FX2D (is in the works but not 100%) default is still JAVA2D
def settings
  size 400, 300, FX2D
end
```
## Run Sketch
`k9 run sketch.rb`
or
`k9 --nojruby run sketch.rb`

be prepared to KILL the odd java process (that doesn't exit cleanly all the time), watch seems now to work

## Watch sketches
```bash
k9 watch sketch.rb # don't try and change render mode, or use the FX2D render mode during watch
```

## Example sketches

[Worked Examples](https://github.com/ruby-processing/samples4ruby-processing3) more to follow, feel free to add your own, especially ruby-2.1+ syntax now we can. These can now be downloaded using `k9 setup unpack_samples` please move existing k9_samples.

## Conversion Tool

I wrote this little script to convert sketches from ruby-processing (processing-2) to jruby_art (processing-3.0) [here](https://gist.github.com/monkstone/1a658bdda4ea21c204c5).

See The-Nature-of-Code-Examples-in-Ruby converted to [The-Nature-of-Code-Examples-for-JRubyArt](https://github.com/ruby-processing/The-Nature-of-Code-for-JRubyArt) using the script.
