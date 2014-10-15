module SIIChile
  class Consulta
    attr_reader :rut

    def initialize(rut)
      @rut = Rut.new(rut)
    end

    def resultado
      @resultado ||= self.fetch!
    end

    protected
      XPATH_RAZON_SOCIAL = '/html/body/div/div[4]'
      XPATH_ACTIVIDADES = '/html/body/div/table/tr'

      def fetch!
        raise 'Rut invalido' unless @rut.valid?

        response = Faraday.post('https://zeus.sii.cl/cvc_cgi/stc/getstc', {
          'RUT' => @rut.number,
          'DV' => @rut.code,
          'PRG' => 'STC',
          'OPC' => 'NOR',
          'txt_code' => '8344',
          'txt_captcha' => 'bWRMcWRNWUpmU1kyMDE0MTAxNTE5NTMzMWhQZVczVk9FRGU2ODM0NGNNQmlSaHVJRlZFMDAwTjVZVWwxQWRoLlFVSjFSVTVNU2paNlIwWk5WUT09Z2FndUpMclY0cC4='
        })

        data = Nokogiri::HTML(response.body)

        actividades = data.xpath(XPATH_ACTIVIDADES)[1..-1].map do |node|
          {
            :giro => node.xpath('./td[1]/font').text.strip,
            :codigo => node.xpath('./td[2]/font').text.strip.to_i,
            :categoria => node.xpath('./td[3]/font').text.strip,
            :afecta =>  node.xpath('./td[4]/font').text.strip == 'Si'
          }
        end rescue []

        {
          :rut => @rut.format,
          :razon_social => data.xpath(XPATH_RAZON_SOCIAL).text.strip,
          :actividades => actividades
        }
      rescue StandardError => e
        {
          :rut => @rut.format,
          :error => e.message
        }
      end
  end
end
