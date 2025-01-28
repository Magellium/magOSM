<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.1.0/StyledLayerDescriptor.xsd" xmlns:se="http://www.opengis.net/se">
  <NamedLayer>
    <se:Name>railways_line</se:Name>
    <UserStyle>
      <se:Name>railways_line</se:Name>
      <se:FeatureTypeStyle>
        <se:Rule>
          <se:Name>Rails</se:Name>
          <se:Description>
            <se:Title>Rails</se:Title>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:And>
              <ogc:And>
                <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>railway</ogc:PropertyName>
                  <ogc:Literal>rail</ogc:Literal>
                </ogc:PropertyIsEqualTo>
                <ogc:Or>
                  <ogc:PropertyIsNull>
                    <ogc:PropertyName>bridge</ogc:PropertyName>
                  </ogc:PropertyIsNull>
                  <ogc:PropertyIsEqualTo>
                    <ogc:PropertyName>bridge</ogc:PropertyName>
                    <ogc:Literal>no</ogc:Literal>
                  </ogc:PropertyIsEqualTo>
                </ogc:Or>
              </ogc:And>
              <ogc:Or>
                <ogc:PropertyIsNull>
                  <ogc:PropertyName>tunnel</ogc:PropertyName>
                </ogc:PropertyIsNull>
                <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>tunnel</ogc:PropertyName>
                  <ogc:Literal>no</ogc:Literal>
                </ogc:PropertyIsEqualTo>
              </ogc:Or>
            </ogc:And>
          </ogc:Filter>
          <se:MinScaleDenominator>1</se:MinScaleDenominator>
          <se:MaxScaleDenominator>100000</se:MaxScaleDenominator>
          <se:LineSymbolizer>
            <se:Stroke>
              <se:SvgParameter name="stroke">#787878</se:SvgParameter>
              <se:SvgParameter name="stroke-width">2</se:SvgParameter>
              <se:SvgParameter name="stroke-linejoin">bevel</se:SvgParameter>
              <se:SvgParameter name="stroke-linecap">square</se:SvgParameter>
            </se:Stroke>
          </se:LineSymbolizer>
          <se:LineSymbolizer>
            <se:Stroke>
              <se:SvgParameter name="stroke">#ffffff</se:SvgParameter>
              <se:SvgParameter name="stroke-width">1</se:SvgParameter>
              <se:SvgParameter name="stroke-linejoin">bevel</se:SvgParameter>
              <se:SvgParameter name="stroke-linecap">square</se:SvgParameter>
              <se:SvgParameter name="stroke-dasharray">5 5</se:SvgParameter>
            </se:Stroke>
          </se:LineSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>Rails - Bridge</se:Name>
          <se:Description>
            <se:Title>Rails - Bridge</se:Title>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:And>
              <ogc:And>
                <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>railway</ogc:PropertyName>
                  <ogc:Literal>rail</ogc:Literal>
                </ogc:PropertyIsEqualTo>
                <ogc:Not>
                  <ogc:PropertyIsNull>
                    <ogc:PropertyName>bridge</ogc:PropertyName>
                  </ogc:PropertyIsNull>
                </ogc:Not>
              </ogc:And>
              <ogc:PropertyIsNotEqualTo>
                <ogc:PropertyName>bridge</ogc:PropertyName>
                <ogc:Literal>no</ogc:Literal>
              </ogc:PropertyIsNotEqualTo>
            </ogc:And>
          </ogc:Filter>
          <se:MinScaleDenominator>1</se:MinScaleDenominator>
          <se:MaxScaleDenominator>100000</se:MaxScaleDenominator>
          <se:LineSymbolizer>
            <se:Stroke>
              <se:SvgParameter name="stroke">#000000</se:SvgParameter>
              <se:SvgParameter name="stroke-width">4</se:SvgParameter>
              <se:SvgParameter name="stroke-linejoin">round</se:SvgParameter>
              <se:SvgParameter name="stroke-linecap">butt</se:SvgParameter>
            </se:Stroke>
          </se:LineSymbolizer>
          <se:LineSymbolizer>
            <se:Stroke>
              <se:SvgParameter name="stroke">#787878</se:SvgParameter>
              <se:SvgParameter name="stroke-width">2</se:SvgParameter>
              <se:SvgParameter name="stroke-linejoin">round</se:SvgParameter>
              <se:SvgParameter name="stroke-linecap">square</se:SvgParameter>
            </se:Stroke>
          </se:LineSymbolizer>
          <se:LineSymbolizer>
            <se:Stroke>
              <se:SvgParameter name="stroke">#ffffff</se:SvgParameter>
              <se:SvgParameter name="stroke-width">1</se:SvgParameter>
              <se:SvgParameter name="stroke-linejoin">round</se:SvgParameter>
              <se:SvgParameter name="stroke-linecap">square</se:SvgParameter>
              <se:SvgParameter name="stroke-dasharray">5 5</se:SvgParameter>
            </se:Stroke>
          </se:LineSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>Rails - Tunnel</se:Name>
          <se:Description>
            <se:Title>Rails - Tunnel</se:Title>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:Or>
              <ogc:And>
                <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>railway</ogc:PropertyName>
                  <ogc:Literal>rail</ogc:Literal>
                </ogc:PropertyIsEqualTo>
                <ogc:And>
                  <ogc:Not>
                    <ogc:PropertyIsNull>
                      <ogc:PropertyName>tunnel</ogc:PropertyName>
                    </ogc:PropertyIsNull>
                  </ogc:Not>
                  <ogc:PropertyIsNotEqualTo>
                    <ogc:PropertyName>tunnel</ogc:PropertyName>
                    <ogc:Literal>no</ogc:Literal>
                  </ogc:PropertyIsNotEqualTo>
                </ogc:And>
              </ogc:And>
              <ogc:Not>
                <ogc:PropertyIsNull>
                  <ogc:PropertyName>layer</ogc:PropertyName>
                </ogc:PropertyIsNull>
              </ogc:Not>
            </ogc:Or>
          </ogc:Filter>
          <se:MinScaleDenominator>1</se:MinScaleDenominator>
          <se:MaxScaleDenominator>100000</se:MaxScaleDenominator>
          <se:LineSymbolizer>
            <se:Stroke>
              <se:SvgParameter name="stroke">#787878</se:SvgParameter>
              <se:SvgParameter name="stroke-opacity">0.50</se:SvgParameter>
              <se:SvgParameter name="stroke-width">2</se:SvgParameter>
              <se:SvgParameter name="stroke-linejoin">bevel</se:SvgParameter>
              <se:SvgParameter name="stroke-linecap">square</se:SvgParameter>
              <se:SvgParameter name="stroke-dasharray">5 5</se:SvgParameter>
            </se:Stroke>
          </se:LineSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>Rails</se:Name>
          <se:Description>
            <se:Title>Rails</se:Title>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:And>
              <ogc:And>
                <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>railway</ogc:PropertyName>
                  <ogc:Literal>rail</ogc:Literal>
                </ogc:PropertyIsEqualTo>
                <ogc:Or>
                  <ogc:PropertyIsNull>
                    <ogc:PropertyName>bridge</ogc:PropertyName>
                  </ogc:PropertyIsNull>
                  <ogc:PropertyIsEqualTo>
                    <ogc:PropertyName>bridge</ogc:PropertyName>
                    <ogc:Literal>no</ogc:Literal>
                  </ogc:PropertyIsEqualTo>
                </ogc:Or>
              </ogc:And>
              <ogc:Or>
                <ogc:PropertyIsNull>
                  <ogc:PropertyName>tunnel</ogc:PropertyName>
                </ogc:PropertyIsNull>
                <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>tunnel</ogc:PropertyName>
                  <ogc:Literal>no</ogc:Literal>
                </ogc:PropertyIsEqualTo>
              </ogc:Or>
            </ogc:And>
          </ogc:Filter>
          <se:MinScaleDenominator>100000</se:MinScaleDenominator>
          <se:MaxScaleDenominator>200000</se:MaxScaleDenominator>
          <se:LineSymbolizer>
            <se:Stroke>
              <se:SvgParameter name="stroke">#666666</se:SvgParameter>
              <se:SvgParameter name="stroke-width">1</se:SvgParameter>
              <se:SvgParameter name="stroke-linejoin">bevel</se:SvgParameter>
              <se:SvgParameter name="stroke-linecap">square</se:SvgParameter>
            </se:Stroke>
          </se:LineSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>Rails - Bridge</se:Name>
          <se:Description>
            <se:Title>Rails - Bridge</se:Title>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:And>
              <ogc:And>
                <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>railway</ogc:PropertyName>
                  <ogc:Literal>rail</ogc:Literal>
                </ogc:PropertyIsEqualTo>
                <ogc:Not>
                  <ogc:PropertyIsNull>
                    <ogc:PropertyName>bridge</ogc:PropertyName>
                  </ogc:PropertyIsNull>
                </ogc:Not>
              </ogc:And>
              <ogc:PropertyIsNotEqualTo>
                <ogc:PropertyName>bridge</ogc:PropertyName>
                <ogc:Literal>no</ogc:Literal>
              </ogc:PropertyIsNotEqualTo>
            </ogc:And>
          </ogc:Filter>
          <se:MinScaleDenominator>100000</se:MinScaleDenominator>
          <se:MaxScaleDenominator>200000</se:MaxScaleDenominator>
          <se:LineSymbolizer>
            <se:Stroke>
              <se:SvgParameter name="stroke">#000000</se:SvgParameter>
              <se:SvgParameter name="stroke-width">4</se:SvgParameter>
              <se:SvgParameter name="stroke-linejoin">round</se:SvgParameter>
              <se:SvgParameter name="stroke-linecap">butt</se:SvgParameter>
            </se:Stroke>
          </se:LineSymbolizer>
          <se:LineSymbolizer>
            <se:Stroke>
              <se:SvgParameter name="stroke">#787878</se:SvgParameter>
              <se:SvgParameter name="stroke-width">2</se:SvgParameter>
              <se:SvgParameter name="stroke-linejoin">round</se:SvgParameter>
              <se:SvgParameter name="stroke-linecap">square</se:SvgParameter>
            </se:Stroke>
          </se:LineSymbolizer>
          <se:LineSymbolizer>
            <se:Stroke>
              <se:SvgParameter name="stroke">#ffffff</se:SvgParameter>
              <se:SvgParameter name="stroke-width">1</se:SvgParameter>
              <se:SvgParameter name="stroke-linejoin">round</se:SvgParameter>
              <se:SvgParameter name="stroke-linecap">square</se:SvgParameter>
              <se:SvgParameter name="stroke-dasharray">5 5</se:SvgParameter>
            </se:Stroke>
          </se:LineSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>Rails - Tunnel</se:Name>
          <se:Description>
            <se:Title>Rails - Tunnel</se:Title>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:Or>
              <ogc:And>
                <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>railway</ogc:PropertyName>
                  <ogc:Literal>rail</ogc:Literal>
                </ogc:PropertyIsEqualTo>
                <ogc:And>
                  <ogc:Not>
                    <ogc:PropertyIsNull>
                      <ogc:PropertyName>tunnel</ogc:PropertyName>
                    </ogc:PropertyIsNull>
                  </ogc:Not>
                  <ogc:PropertyIsNotEqualTo>
                    <ogc:PropertyName>tunnel</ogc:PropertyName>
                    <ogc:Literal>no</ogc:Literal>
                  </ogc:PropertyIsNotEqualTo>
                </ogc:And>
              </ogc:And>
              <ogc:Not>
                <ogc:PropertyIsNull>
                  <ogc:PropertyName>layer</ogc:PropertyName>
                </ogc:PropertyIsNull>
              </ogc:Not>
            </ogc:Or>
          </ogc:Filter>
          <se:MinScaleDenominator>100000</se:MinScaleDenominator>
          <se:MaxScaleDenominator>200000</se:MaxScaleDenominator>
          <se:LineSymbolizer>
            <se:Stroke>
              <se:SvgParameter name="stroke">#787878</se:SvgParameter>
              <se:SvgParameter name="stroke-opacity">0.50</se:SvgParameter>
              <se:SvgParameter name="stroke-width">2</se:SvgParameter>
              <se:SvgParameter name="stroke-linejoin">bevel</se:SvgParameter>
              <se:SvgParameter name="stroke-linecap">square</se:SvgParameter>
              <se:SvgParameter name="stroke-dasharray">5 5</se:SvgParameter>
            </se:Stroke>
          </se:LineSymbolizer>
        </se:Rule>
        <se:Rule>
          <se:Name>Rails</se:Name>
          <se:Description>
            <se:Title>Rails</se:Title>
          </se:Description>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
            <ogc:And>
              <ogc:And>
                <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>railway</ogc:PropertyName>
                  <ogc:Literal>rail</ogc:Literal>
                </ogc:PropertyIsEqualTo>
                <ogc:Or>
                  <ogc:PropertyIsNull>
                    <ogc:PropertyName>bridge</ogc:PropertyName>
                  </ogc:PropertyIsNull>
                  <ogc:PropertyIsEqualTo>
                    <ogc:PropertyName>bridge</ogc:PropertyName>
                    <ogc:Literal>no</ogc:Literal>
                  </ogc:PropertyIsEqualTo>
                </ogc:Or>
              </ogc:And>
              <ogc:Or>
                <ogc:PropertyIsNull>
                  <ogc:PropertyName>tunnel</ogc:PropertyName>
                </ogc:PropertyIsNull>
                <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>tunnel</ogc:PropertyName>
                  <ogc:Literal>no</ogc:Literal>
                </ogc:PropertyIsEqualTo>
              </ogc:Or>
            </ogc:And>
          </ogc:Filter>
          <se:MinScaleDenominator>200000</se:MinScaleDenominator>
          <se:MaxScaleDenominator>100000000</se:MaxScaleDenominator>
          <se:LineSymbolizer>
            <se:Stroke>
              <se:SvgParameter name="stroke">#666666</se:SvgParameter>
              <se:SvgParameter name="stroke-width">1</se:SvgParameter>
              <se:SvgParameter name="stroke-linejoin">bevel</se:SvgParameter>
              <se:SvgParameter name="stroke-linecap">square</se:SvgParameter>
            </se:Stroke>
          </se:LineSymbolizer>
        </se:Rule>
      </se:FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>