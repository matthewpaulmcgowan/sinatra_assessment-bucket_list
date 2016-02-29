require './config/environment'
use Rack::MethodOverride
use ItemController
use UserController
run ApplicationController