require 'faraday'
require 'nokogiri'
require File.expand_path('gem/lib/sii_chile/version')
require File.expand_path('gem/lib/sii_chile/rut')
require File.expand_path('gem/lib/sii_chile/consulta')

describe "Materialización del objeto y resultados" do
  before do
    @sii_chile_rut = "76.118.195-5"
    @sii_chile = SIIChile::Consulta.new(@sii_chile_rut)
    @sii_chile_resultado = @sii_chile.resultado
  end
  it "Retornar el rut desde el objecto" do
    expect(@sii_chile_rut).to eq(@sii_chile.rut.to_s)
  end

  it "Retornar el rut desde el servicio" do
    expect(@sii_chile_resultado[:rut]).to eq(@sii_chile_rut)
  end

  it "Retornar la razón social desde el servicio" do
    expect(@sii_chile_resultado[:razon_social]).to eq("WELCU CHILE SPA")
  end

  it "Retornar las actividades desde el servicio" do
    expect(@sii_chile_resultado[:actividades]).to_not eq(nil)
    expect(@sii_chile_resultado[:actividades].length).to be > 0
  end

  it "La primera actividad debiera ser 'EMPRESAS DE SERVICIOS INTEGRALES DE INFORMATICA'" do
    expect(@sii_chile_resultado[:actividades][0][:giro]).to eq("EMPRESAS DE SERVICIOS INTEGRALES DE INFORMATICA")
  end

  it "La primera actividad debiera ser 'EMPRESAS DE SERVICIOS INTEGRALES DE INFORMATICA'" do
    expect(@sii_chile_resultado[:actividades][0][:giro]).to eq("EMPRESAS DE SERVICIOS INTEGRALES DE INFORMATICA")
  end

  it "El primer codigo debiera ser '726000'" do
    expect(@sii_chile_resultado[:actividades][0][:codigo]).to eq(726000)
  end

  it "La primera categoría debiera ser 'Primera'" do
    expect(@sii_chile_resultado[:actividades][0][:categoria]).to eq("Primera")
  end

  it "La actividad debiera ser afecta" do
    expect(@sii_chile_resultado[:actividades][0][:afecta]).to eq(true)
  end

end
