require 'sii_chile'
require 'sinatra'
require 'dalli'
require 'rack/contrib/jsonp'
require 'multi_json'

module SIIChile
  class Application < Sinatra::Base
    set :cache, Dalli::Client.new()
    use Rack::JSONP

    get '/' do
      redirect 'https://github.com/sagmor/sii_chile'
    end

    get '/consulta' do
      @consulta = Consulta.new(params[:rut])

      @resultado = settings.cache.get(@consulta.rut.format)

      unless @resultado
        @resultado = @consulta.resultado
        settings.cache.set(@consulta.rut.format, @resultado)
      end

      [
        @resultado[:error] ? 404 : 200,
        {
          'Content-Type' => 'application/json',
          'Access-Control-Allow-Origin' => '*',
          'X-Version' => SIIChile::VERSION
        },
        MultiJson.dump(@resultado)
      ]
    end
  end
end
