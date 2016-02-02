require 'sii_chile'
require 'sinatra'
require 'dalli'
require 'rack/contrib/jsonp'
require 'multi_json'
require 'newrelic_rpm'

module SIIChile
  class Application < Sinatra::Base

    set :cache, Dalli::Client.new(ENV["MEMCACHIER_SERVERS"].split(","),
                    {:username => ENV["MEMCACHIER_USERNAME"],
                     :password => ENV["MEMCACHIER_PASSWORD"]})
    use Rack::JSONP

    get '/' do
      redirect 'https://github.com/sagmor/sii_chile'
    end

    get '/consulta' do
      @consulta = Consulta.new(params[:rut])

      @cache_key = [
        SIIChile::VERSION,
        @consulta.rut.format,
        Time.now.strftime('%Y%m%d')
      ].join('/')

      @resultado = settings.cache.get(@cache_key)
      cached = true

      unless @resultado
        cached = false
        @resultado = @consulta.resultado
        settings.cache.set(@cache_key, @resultado)
      end

      [
        200,
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
