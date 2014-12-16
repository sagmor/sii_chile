# API SII Chile

API para acceder a algunos de los servicios del
servicio de impuestos internos de chile.

## Uso

### Servicio web

Basta con realizar una consulta a `https://siichile.herokuapp.com/consulta`
con el parametro rut para obtener un resultado.

Por ejemplo usando jQuery basta con:

```javascript
jQuery.getJSON('https://siichile.herokuapp.com/consulta', {rut: '76.118.195-5'}, function(result) {
  console.log(result);
})
```

### Ruby

También se puede utilizar directamente desde ruby instalando la gema sii_chile
y realizando la consulta:

```ruby
SIIChile::Consulta.new('76.118.195-5').resultado
```

## Contribuír

1. Fork
2. Branch (`git checkout -b my-new-feature`)
3. Commit (`git commit -am 'Add some feature'`)
4. Push (`git push origin my-new-feature`)
5. Y envía un Pull Request

## Legal

### Descargos

Este desarrollo no está respaldado ni afiliado de ningúna forma al
Servicio de Impuestos Internos de Chile.

Este servicio es solo una interfaz para la obtencíon de datos publicos
disponibles desde el sitio http://www.sii.cl y no se garantiza la disponibilidad
del servicio

### Licencia

```text
Copyright (c) 2013 Seba Gamboa

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/sagmor/sii_chile/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

