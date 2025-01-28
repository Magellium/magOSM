<?xml version="1.0" encoding="UTF-8"?><sld:StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc" version="1.0.0">
  <sld:NamedLayer>
    <sld:Name>proposed</sld:Name>
    <sld:UserStyle>
      <sld:Name>proposed</sld:Name>
            <sld:FeatureTypeStyle>  
      <!-- symbolisation des points -->
        <sld:Rule> <!--règle pour visualisation à échelle worldwide, [MIN:zoom4 et +-->
        <Title>Projet de construction ponctuelle</Title>
          <ogc:Filter>
           <ogc:Or> 
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>osm_type</ogc:PropertyName>
              <ogc:Literal>node</ogc:Literal>
            </ogc:PropertyIsEqualTo>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>osm_type</ogc:PropertyName>
              <ogc:Literal>polygon</ogc:Literal> <!--permet de visualiser les relations qui sont des osm_type=polygon-->
            </ogc:PropertyIsEqualTo>
           </ogc:Or>
          </ogc:Filter> 
          <MinScaleDenominator>20000000</MinScaleDenominator>
          <MaxScaleDenominator>70000000</MaxScaleDenominator>
          <sld:PointSymbolizer>
            <sld:Graphic>
               <sld:Mark>
                <sld:WellKnownName>triangle</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter  name="fill">#a6aff2</sld:CssParameter>
                </sld:Fill>
                <Stroke>
                  <CssParameter name="stroke">#6373e8</CssParameter>
                  <CssParameter name="stroke-width">0.25</CssParameter>
                </Stroke>
              </sld:Mark>
              <sld:Size>5.000000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
        <sld:Rule> <!--règle pour visualisation à échelle nationale, [MIN:zoom6-MAX:zoom5]-->
        <Title>Projet de construction ponctuelle</Title>
          <ogc:Filter>
           <ogc:Or> 
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>osm_type</ogc:PropertyName>
              <ogc:Literal>node</ogc:Literal>
            </ogc:PropertyIsEqualTo>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>osm_type</ogc:PropertyName>
              <ogc:Literal>polygon</ogc:Literal> 
            </ogc:PropertyIsEqualTo>
           </ogc:Or>
          </ogc:Filter> 
          <MinScaleDenominator>5000000</MinScaleDenominator>
          <MaxScaleDenominator>20000000</MaxScaleDenominator>
          <sld:PointSymbolizer>
            <sld:Graphic>
               <sld:Mark>
                <sld:WellKnownName>triangle</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter  name="fill">#a6aff2</sld:CssParameter>
                </sld:Fill>
                <Stroke>
                  <CssParameter name="stroke">#6373e8</CssParameter>
                  <CssParameter name="stroke-width">0.50</CssParameter>
                </Stroke>
              </sld:Mark>
              <sld:Size>10.000000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
        <sld:Rule> <!--règle pour visualisation à échelle regionale, [MIN:zoom8-MAX:zoom7]-->
        <Title>Projet de construction ponctuelle</Title>
          <ogc:Filter>
           <ogc:Or> 
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>osm_type</ogc:PropertyName>
              <ogc:Literal>node</ogc:Literal>
            </ogc:PropertyIsEqualTo>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>osm_type</ogc:PropertyName>
              <ogc:Literal>polygon</ogc:Literal> 
            </ogc:PropertyIsEqualTo>
           </ogc:Or>
          </ogc:Filter> 
          <MinScaleDenominator>2000000</MinScaleDenominator>
          <MaxScaleDenominator>5000000</MaxScaleDenominator>
          <sld:PointSymbolizer>
            <sld:Graphic>
               <sld:Mark>
                <sld:WellKnownName>triangle</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter  name="fill">#a6aff2</sld:CssParameter>
                </sld:Fill>
                <Stroke>
                  <CssParameter name="stroke">#6373e8</CssParameter>
                  <CssParameter name="stroke-width">0.75</CssParameter>
                </Stroke>
              </sld:Mark>
              <sld:Size>15.000000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
        <sld:Rule> <!--règle pour visualisation à échelle départementale, ]MIN:zoom11-MAX:zoom9]-->
        <Title>Projet de construction ponctuelle</Title>
          <ogc:Filter>
           <ogc:Or> 
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>osm_type</ogc:PropertyName>
              <ogc:Literal>node</ogc:Literal>
            </ogc:PropertyIsEqualTo>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>osm_type</ogc:PropertyName>
              <ogc:Literal>polygon</ogc:Literal> 
            </ogc:PropertyIsEqualTo>
           </ogc:Or>
          </ogc:Filter> 
          <MinScaleDenominator>200000</MinScaleDenominator>
          <MaxScaleDenominator>2000000</MaxScaleDenominator>
          <sld:PointSymbolizer>
            <sld:Graphic>
               <sld:Mark>
                <sld:WellKnownName>triangle</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter  name="fill">#a6aff2</sld:CssParameter>
                </sld:Fill>
                <Stroke>
                  <CssParameter name="stroke">#6373e8</CssParameter>
                  <CssParameter name="stroke-width">1</CssParameter>
                </Stroke>
              </sld:Mark>
              <sld:Size>20.000000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
        <sld:Rule> <!--règle pour visualisation à échelle locale, MAX:zoom12] et - -->
        <Title>Projet de construction ponctuelle</Title>
          <ogc:Filter>
           <ogc:Or> 
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>osm_type</ogc:PropertyName>
              <ogc:Literal>node</ogc:Literal>
            </ogc:PropertyIsEqualTo>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>osm_type</ogc:PropertyName>
              <ogc:Literal>polygon</ogc:Literal> 
            </ogc:PropertyIsEqualTo>
           </ogc:Or>
          </ogc:Filter> 
          <MaxScaleDenominator>200000</MaxScaleDenominator>
          <sld:PointSymbolizer>
            <sld:Graphic>
               <sld:Mark>
                <sld:WellKnownName>triangle</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter  name="fill">#a6aff2</sld:CssParameter>
                </sld:Fill>
                <Stroke>
                  <CssParameter name="stroke">#6373e8</CssParameter>
                  <CssParameter name="stroke-width">1</CssParameter>
                </Stroke>
              </sld:Mark>
              <sld:Size>25.000000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>      
      </sld:FeatureTypeStyle>
      <sld:FeatureTypeStyle>
       <!-- symbolisation des lignes, filtrage par géométrie pour ne pas prendre en compte les points (geom) des chemins qui sont différents des POI-->
          <sld:Rule> <!--scale: europe/monde-->
          <Title>Projet de construction linéaire</Title>
            <ogc:Filter> <!--obligation de répéter le même filtrage sur les way pour chaque règle d'échelle-->
              <ogc:PropertyIsEqualTo>
                <ogc:PropertyName>osm_type</ogc:PropertyName>
                <ogc:Literal>way</ogc:Literal>
              </ogc:PropertyIsEqualTo>
            </ogc:Filter> 
            <MinScaleDenominator>20000000</MinScaleDenominator>
            <MaxScaleDenominator>70000000</MaxScaleDenominator>
              <sld:LineSymbolizer>
                  <sld:Stroke>
                      <sld:CssParameter name="stroke">#6373e8</sld:CssParameter>
                      <sld:CssParameter name="stroke-width">1</sld:CssParameter>
                      <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>
                  </sld:Stroke>
              </sld:LineSymbolizer>
          </sld:Rule>
          <sld:Rule> <!--scale: nationale-->
          <Title>Projet de construction linéaire</Title>
            <ogc:Filter>
              <ogc:PropertyIsEqualTo>
                <ogc:PropertyName>osm_type</ogc:PropertyName>
                <ogc:Literal>way</ogc:Literal>
              </ogc:PropertyIsEqualTo>
            </ogc:Filter> 
            <MinScaleDenominator>5000000</MinScaleDenominator>
            <MaxScaleDenominator>20000000</MaxScaleDenominator>
              <sld:LineSymbolizer>
                  <sld:Stroke>
                      <sld:CssParameter name="stroke">#6373e8</sld:CssParameter>
                      <sld:CssParameter name="stroke-width">2</sld:CssParameter>
                      <sld:CssParameter name="stroke-dasharray">4 3</sld:CssParameter>
                      <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>
                  </sld:Stroke>
              </sld:LineSymbolizer>
          </sld:Rule>
          <sld:Rule> <!--scale: régionale-->
          <Title>Projet de construction linéaire</Title>
            <ogc:Filter>
              <ogc:PropertyIsEqualTo>
                <ogc:PropertyName>osm_type</ogc:PropertyName>
                <ogc:Literal>way</ogc:Literal>
              </ogc:PropertyIsEqualTo>
            </ogc:Filter> 
            <MinScaleDenominator>2000000</MinScaleDenominator>
            <MaxScaleDenominator>5000000</MaxScaleDenominator>
              <sld:LineSymbolizer>
                  <sld:Stroke>
                      <sld:CssParameter name="stroke">#6373e8</sld:CssParameter>
                      <sld:CssParameter name="stroke-width">2.5</sld:CssParameter>
                      <sld:CssParameter name="stroke-dasharray">5 4</sld:CssParameter>
                      <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>    
                      <sld:CssParameter name="stroke-linejoin">round</sld:CssParameter>
                  </sld:Stroke>
              </sld:LineSymbolizer>
          </sld:Rule>
          <sld:Rule> <!--scale: départementale-->
          <Title>Projet de construction linéaire</Title>
            <ogc:Filter>
              <ogc:PropertyIsEqualTo>
                <ogc:PropertyName>osm_type</ogc:PropertyName>
                <ogc:Literal>way</ogc:Literal>
              </ogc:PropertyIsEqualTo>
            </ogc:Filter> 
            <MinScaleDenominator>200000</MinScaleDenominator>
            <MaxScaleDenominator>2000000</MaxScaleDenominator>
              <sld:LineSymbolizer>
                  <sld:Stroke>
                      <sld:CssParameter name="stroke">#6373e8</sld:CssParameter>
                      <sld:CssParameter name="stroke-width">3</sld:CssParameter>
                      <sld:CssParameter name="stroke-dasharray">7 5</sld:CssParameter>
                      <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>    
                      <sld:CssParameter name="stroke-linejoin">round</sld:CssParameter>
                  </sld:Stroke>
              </sld:LineSymbolizer>
          </sld:Rule>
          <sld:Rule> <!--scale: locale-->
          <Title>Projet de construction linéaire</Title>
            <ogc:Filter>
              <ogc:PropertyIsEqualTo>
                <ogc:PropertyName>osm_type</ogc:PropertyName>
                <ogc:Literal>way</ogc:Literal>
              </ogc:PropertyIsEqualTo>
            </ogc:Filter> 
            <MinScaleDenominator>50000</MinScaleDenominator>
            <MaxScaleDenominator>200000</MaxScaleDenominator>
              <sld:LineSymbolizer>
                  <sld:Stroke>
                      <sld:CssParameter name="stroke">#6373e8</sld:CssParameter>
                      <sld:CssParameter name="stroke-width">2</sld:CssParameter>
                      <sld:CssParameter name="stroke-dasharray">6 4</sld:CssParameter>
                      <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>    
                      <sld:CssParameter name="stroke-linejoin">round</sld:CssParameter>
                  </sld:Stroke>
              </sld:LineSymbolizer>
          </sld:Rule>
          <sld:Rule> <!--scale: ultra locale-->
          <Title>Projet de construction linéaire</Title>
            <ogc:Filter>
              <ogc:PropertyIsEqualTo>
                <ogc:PropertyName>osm_type</ogc:PropertyName>
                <ogc:Literal>way</ogc:Literal>
              </ogc:PropertyIsEqualTo>
            </ogc:Filter> 
            <MaxScaleDenominator>50000</MaxScaleDenominator>
              <sld:LineSymbolizer>
                  <sld:Stroke>
                      <sld:CssParameter name="stroke">#6373e8</sld:CssParameter>
                      <sld:CssParameter name="stroke-width">2</sld:CssParameter>
                      <sld:CssParameter name="stroke-dasharray">6 4</sld:CssParameter>
                      <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>    
                      <sld:CssParameter name="stroke-linejoin">round</sld:CssParameter>
                  </sld:Stroke>
              </sld:LineSymbolizer>
          </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </sld:NamedLayer>
</sld:StyledLayerDescriptor>