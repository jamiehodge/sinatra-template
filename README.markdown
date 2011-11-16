# Sinatra Template #

This template is intended as a starting point for medium to large-scale Sinatra
projects. It serves html using html authentication, as well as an api using
http basic authentication.

* Ruby 1.9
* Sinatra
* Sinatra Reloader
* Rack Flash
* Rack Cache
* Rack Parser
* Sequel
* Warden
* R18n
* Coffeescript
* Compass
* Sass
* Slim
* Susy responsive grid layout (based upon https://github.com/ericam/320-susy)
* Formalize
* MiniTest
* Guard

Get Started
-----------

    bundle install
    
    rackup
    
    http://localhost:9292
    
Or

    brew install pow
    
    ln -s $pwd ~/.pow/sinatra-template
    
    bundle install
    
    http://sinatra-template.dev
    
    
You will need to populate the database with users if you wish to login.
    
TODO
----

All Sinatra classes currently share a common layout. This layout includes
hardcoded asset paths. This will need to be fixed.

Credits
-------

Originally based on DarrenN's [Stretchy Pants](https://github.com/DarrenN/stretchy_pants).
