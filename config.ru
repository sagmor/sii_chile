$LOAD_PATH.unshift(File.expand_path('../app', __FILE__))
require 'sii_chile/application'

run SIIChile::Application
