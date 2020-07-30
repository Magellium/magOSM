<?xml version="1.0" encoding="UTF-8"?><sld:StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc" version="1.0.0">
  <sld:NamedLayer>
    <sld:Name>france_social_amenity_point</sld:Name>
    <sld:UserStyle>
      <sld:Name>france_social_amenity_point</sld:Name>
      <sld:FeatureTypeStyle>
        <sld:Name>SVG_Symbolizer</sld:Name>
        <sld:Rule> <!--règle pour visualisation à échelle locale, MAX:zoom12] et - -->
          <sld:Name>Service social -local</sld:Name>
          <Title>Service social</Title>
          <ogc:Filter>
          <ogc:And>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>amenity</ogc:PropertyName>
              <ogc:Literal>social_facility</ogc:Literal>
            </ogc:PropertyIsEqualTo>
            <!--Add social_facility=* who are not tagged with any amenity=social_facily-->
            <ogc:Not>
              <ogc:PropertyIsNull>
                <ogc:PropertyName>social_facility</ogc:PropertyName>
              </ogc:PropertyIsNull>
            </ogc:Not>
          </ogc:And>  
          </ogc:Filter>
          <MaxScaleDenominator>200000</MaxScaleDenominator>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:ExternalGraphic>
                <sld:OnlineResource xmlns:xlink="http://www.w3.org/1999/xlink" xlink:type="simple" xlink:href="images/wikiosm/social/social_facility-762141.svg"/>
                <sld:Format>image/svg+xml</sld:Format>
              </sld:ExternalGraphic>
              <sld:Size>20.000000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
        <sld:Rule> <!--règle pour visualisation à échelle departementale, ]MIN:zoom11-MAX:zoom9]-->
          <sld:Name>Service social - dep</sld:Name>
          <Title>Service social</Title>
          <ogc:Filter>
          <ogc:And>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>amenity</ogc:PropertyName>
              <ogc:Literal>social_facility</ogc:Literal>
            </ogc:PropertyIsEqualTo>
            <!--Add social_facility=* who are not tagged with any amenity=social_facily-->
            <ogc:Not>
              <ogc:PropertyIsNull>
                <ogc:PropertyName>social_facility</ogc:PropertyName>
              </ogc:PropertyIsNull>
            </ogc:Not>
          </ogc:And>  
          </ogc:Filter>
          <MinScaleDenominator>200000</MinScaleDenominator>
          <MaxScaleDenominator>2000000</MaxScaleDenominator>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:ExternalGraphic>
                <sld:OnlineResource xmlns:xlink="http://www.w3.org/1999/xlink" xlink:type="simple" xlink:href="images/wikiosm/social/social_facility-762141.svg"/>
                <sld:Format>image/svg+xml</sld:Format>
              </sld:ExternalGraphic>
              <sld:Size>15.000000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
        <sld:Rule> <!--règle pour visualisation à échelle regionale, [MIN:zoom8-MAX:zoom7]-->
          <sld:Name>Service social - regional</sld:Name>
          <Title>Service social</Title>
          <ogc:Filter>
          <ogc:And>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>amenity</ogc:PropertyName>
              <ogc:Literal>social_facility</ogc:Literal>
            </ogc:PropertyIsEqualTo>
            <!--Add social_facility=* who are not tagged with any amenity=social_facily-->
            <ogc:Not>
              <ogc:PropertyIsNull>
                <ogc:PropertyName>social_facility</ogc:PropertyName>
              </ogc:PropertyIsNull>
            </ogc:Not>
          </ogc:And>  
          </ogc:Filter>
          <MinScaleDenominator>2000000</MinScaleDenominator>
          <MaxScaleDenominator>5000000</MaxScaleDenominator>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:ExternalGraphic>
                <sld:OnlineResource xmlns:xlink="http://www.w3.org/1999/xlink" xlink:type="simple" xlink:href="images/wikiosm/social/social_facility-762141.svg"/>
                <sld:Format>image/svg+xml</sld:Format>
              </sld:ExternalGraphic>
              <sld:Size>10.000000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
        <sld:Rule> <!--règle pour visualisation à échelle national, [MIN:zoom6-MAX:zoom5]-->
          <sld:Name>Service social - national</sld:Name>
          <Title>Service social</Title>
          <ogc:Filter>
          <ogc:And>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>amenity</ogc:PropertyName>
              <ogc:Literal>social_facility</ogc:Literal>
            </ogc:PropertyIsEqualTo>
            <!--Add social_facility=* who are not tagged with any amenity=social_facily-->
            <ogc:Not>
              <ogc:PropertyIsNull>
                <ogc:PropertyName>social_facility</ogc:PropertyName>
              </ogc:PropertyIsNull>
            </ogc:Not>
          </ogc:And>  
          </ogc:Filter>
          <MinScaleDenominator>5000000</MinScaleDenominator>
          <MaxScaleDenominator>20000000</MaxScaleDenominator>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:ExternalGraphic>
                <sld:OnlineResource xmlns:xlink="http://www.w3.org/1999/xlink" xlink:type="simple" xlink:href="images/wikiosm/social/social_facility-762141.svg"/>
                <sld:Format>image/svg+xml</sld:Format>
              </sld:ExternalGraphic>
              <sld:Size>5.000000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
        <sld:Rule> <!--règle pour visualisation à échelle worldwide, [MIN:zoom4 et +-->
          <sld:Name>Service social - worldwide</sld:Name>
          <Title>Service social</Title>
          <ogc:Filter>
          <ogc:And>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>amenity</ogc:PropertyName>
              <ogc:Literal>social_facility</ogc:Literal>
            </ogc:PropertyIsEqualTo>
            <!--Add social_facility=* who are not tagged with any amenity=social_facily-->
            <ogc:Not>
              <ogc:PropertyIsNull>
                <ogc:PropertyName>social_facility</ogc:PropertyName>
              </ogc:PropertyIsNull>
            </ogc:Not>
          </ogc:And>  
          </ogc:Filter>
          <MinScaleDenominator>20000000</MinScaleDenominator>
          <MaxScaleDenominator>70000000</MaxScaleDenominator>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:ExternalGraphic>
                <sld:OnlineResource xmlns:xlink="http://www.w3.org/1999/xlink" xlink:type="simple" xlink:href="images/wikiosm/social/social_facility-762141.svg"/>
                <sld:Format>image/svg+xml</sld:Format>
              </sld:ExternalGraphic>
              <sld:Size>2.000000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
        <sld:Rule> <!--règle pour visualisation à échelle locale, MAX:zoom11] et - -->
          <sld:Name>Centre communautaire -local</sld:Name>
          <Title>Centre communautaire</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>amenity</ogc:PropertyName>
              <ogc:Literal>community_centre</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <MaxScaleDenominator>200000</MaxScaleDenominator>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:ExternalGraphic>
                <sld:OnlineResource xmlns:xlink="http://www.w3.org/1999/xlink" xlink:type="simple" xlink:href="images/wikiosm/social/community_centre-14.svg"/>
                <sld:Format>image/svg+xml</sld:Format>
              </sld:ExternalGraphic>
              <sld:Size>20.000000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
        <sld:Rule> <!--règle pour visualisation à échelle departementale, [MIN:zoom11-MAX:zoom9]-->
          <sld:Name>Centre communautaire - dep</sld:Name>
          <Title>Centre communautaire</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>amenity</ogc:PropertyName>
              <ogc:Literal>community_centre</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <MinScaleDenominator>200000</MinScaleDenominator>
          <MaxScaleDenominator>2000000</MaxScaleDenominator>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:ExternalGraphic>
                <sld:OnlineResource xmlns:xlink="http://www.w3.org/1999/xlink" xlink:type="simple" xlink:href="images/wikiosm/social/community_centre-14.svg"/>
                <sld:Format>image/svg+xml</sld:Format>
              </sld:ExternalGraphic>
              <sld:Size>15.000000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
        <sld:Rule> <!--règle pour visualisation à échelle regionale, [MIN:zoom8-MAX:zoom7]-->
          <sld:Name>Centre communautaire - regional</sld:Name>
          <Title>Centre communautaire</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>amenity</ogc:PropertyName>
              <ogc:Literal>community_centre</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <MinScaleDenominator>2000000</MinScaleDenominator>
          <MaxScaleDenominator>5000000</MaxScaleDenominator>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:ExternalGraphic>
                <sld:OnlineResource xmlns:xlink="http://www.w3.org/1999/xlink" xlink:type="simple" xlink:href="images/wikiosm/social/community_centre-14.svg"/>
                <sld:Format>image/svg+xml</sld:Format>
              </sld:ExternalGraphic>
              <sld:Size>10.000000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
        <sld:Rule> <!--règle pour visualisation à échelle nationale, [MIN:zoom6-MAX:zoom5]-->
          <sld:Name>Centre communautaire - national</sld:Name>
          <Title>Centre communautaire</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>amenity</ogc:PropertyName>
              <ogc:Literal>community_centre</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <MinScaleDenominator>5000000</MinScaleDenominator>
          <MaxScaleDenominator>20000000</MaxScaleDenominator>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:ExternalGraphic>
                <sld:OnlineResource xmlns:xlink="http://www.w3.org/1999/xlink" xlink:type="simple" xlink:href="images/wikiosm/social/community_centre-14.svg"/>
                <sld:Format>image/svg+xml</sld:Format>
              </sld:ExternalGraphic>
              <sld:Size>5.000000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
        <sld:Rule> <!--règle pour visualisation à échelle worldwide, [MIN:zoom4 et +-->
          <sld:Name>Centre communautaire - worldwide</sld:Name>
          <Title>Centre communautaire</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>amenity</ogc:PropertyName>
              <ogc:Literal>community_centre</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <MinScaleDenominator>20000000</MinScaleDenominator>
          <MaxScaleDenominator>70000000</MaxScaleDenominator>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:ExternalGraphic>
                <sld:OnlineResource xmlns:xlink="http://www.w3.org/1999/xlink" xlink:type="simple" xlink:href="images/wikiosm/social/community_centre-14.svg"/>
                <sld:Format>image/svg+xml</sld:Format>
              </sld:ExternalGraphic>
              <sld:Size>2.000000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
        <sld:Rule> <!--règle pour visualisation à échelle locale, MAX:zoom12] et - -->
          <sld:Name>Centre associatif - local</sld:Name>
          <Title>Centre associatif</Title>
          <ogc:Filter>
          <ogc:Or>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>amenity</ogc:PropertyName>
              <ogc:Literal>social_centre</ogc:Literal>
            </ogc:PropertyIsEqualTo>
            <ogc:Or>
              <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>office</ogc:PropertyName>
                  <ogc:Literal>association</ogc:Literal>
              </ogc:PropertyIsEqualTo>
              <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>office</ogc:PropertyName>
                  <ogc:Literal>ngo</ogc:Literal>
              </ogc:PropertyIsEqualTo>
              <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>office</ogc:PropertyName>
                  <ogc:Literal>union</ogc:Literal>
              </ogc:PropertyIsEqualTo>
            </ogc:Or> 
          </ogc:Or>  
          </ogc:Filter>
          <MaxScaleDenominator>200000</MaxScaleDenominator>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:Mark>
                <sld:WellKnownName>circle</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter name="fill">#216b76</sld:CssParameter>
                </sld:Fill>
              </sld:Mark>
              <sld:Size>10.000000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
        <sld:Rule> <!--règle pour visualisation à échelle departementale, [MIN:zoom11-MAX:zoom9]-->
          <sld:Name>Centre associatif - dep</sld:Name>
          <Title>Centre associatif</Title>
          <ogc:Filter>
          <ogc:Or>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>amenity</ogc:PropertyName>
              <ogc:Literal>social_centre</ogc:Literal>
            </ogc:PropertyIsEqualTo>
            <ogc:Or>
              <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>office</ogc:PropertyName>
                  <ogc:Literal>association</ogc:Literal>
              </ogc:PropertyIsEqualTo>
              <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>office</ogc:PropertyName>
                  <ogc:Literal>ngo</ogc:Literal>
              </ogc:PropertyIsEqualTo>
              <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>office</ogc:PropertyName>
                  <ogc:Literal>union</ogc:Literal>
              </ogc:PropertyIsEqualTo>
            </ogc:Or> 
          </ogc:Or>  
          </ogc:Filter>
          <MinScaleDenominator>200000</MinScaleDenominator>
          <MaxScaleDenominator>2000000</MaxScaleDenominator>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:Mark>
                <sld:WellKnownName>circle</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter name="fill">#216b76</sld:CssParameter>
                </sld:Fill>
              </sld:Mark>
              <sld:Size>7.50000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
        <sld:Rule> <!--règle pour visualisation à échelle regionale, [MIN:zoom8-MAX:zoom7]-->
          <sld:Name>Centre associatif - regional</sld:Name>
          <Title>Centre associatif</Title>
          <ogc:Filter>
          <ogc:Or>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>amenity</ogc:PropertyName>
              <ogc:Literal>social_centre</ogc:Literal>
            </ogc:PropertyIsEqualTo>
            <ogc:Or>
              <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>office</ogc:PropertyName>
                  <ogc:Literal>association</ogc:Literal>
              </ogc:PropertyIsEqualTo>
              <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>office</ogc:PropertyName>
                  <ogc:Literal>ngo</ogc:Literal>
              </ogc:PropertyIsEqualTo>
              <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>office</ogc:PropertyName>
                  <ogc:Literal>union</ogc:Literal>
              </ogc:PropertyIsEqualTo>
            </ogc:Or> 
          </ogc:Or>  
          </ogc:Filter>
          <MinScaleDenominator>2000000</MinScaleDenominator>
          <MaxScaleDenominator>5000000</MaxScaleDenominator>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:Mark>
                <sld:WellKnownName>circle</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter name="fill">#216b76</sld:CssParameter>
                </sld:Fill>
              </sld:Mark>
              <sld:Size>5.000000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
        <sld:Rule> <!--règle pour visualisation à échelle nationale, [MIN:zoom6-MAX:zoom5]-->
          <sld:Name>Centre associatif - national</sld:Name>
          <Title>Centre associatif</Title>
          <ogc:Filter>
          <ogc:Or>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>amenity</ogc:PropertyName>
              <ogc:Literal>social_centre</ogc:Literal>
            </ogc:PropertyIsEqualTo>
            <ogc:Or>
              <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>office</ogc:PropertyName>
                  <ogc:Literal>association</ogc:Literal>
              </ogc:PropertyIsEqualTo>
              <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>office</ogc:PropertyName>
                  <ogc:Literal>ngo</ogc:Literal>
              </ogc:PropertyIsEqualTo>
              <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>office</ogc:PropertyName>
                  <ogc:Literal>union</ogc:Literal>
              </ogc:PropertyIsEqualTo>
            </ogc:Or> 
          </ogc:Or>  
          </ogc:Filter>
          <MinScaleDenominator>5000000</MinScaleDenominator>
          <MaxScaleDenominator>20000000</MaxScaleDenominator>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:Mark>
                <sld:WellKnownName>circle</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter name="fill">#216b76</sld:CssParameter>
                </sld:Fill>
              </sld:Mark>
              <sld:Size>2.500000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
        <sld:Rule> <!--règle pour visualisation à échelle worldwide, [MIN:zoom4 et +-->
          <sld:Name>Centre associatif - worldwide</sld:Name>
          <Title>Centre associatif</Title>
          <ogc:Filter>
          <ogc:Or>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>amenity</ogc:PropertyName>
              <ogc:Literal>social_centre</ogc:Literal>
            </ogc:PropertyIsEqualTo>
            <ogc:Or>
              <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>office</ogc:PropertyName>
                  <ogc:Literal>association</ogc:Literal>
              </ogc:PropertyIsEqualTo>
              <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>office</ogc:PropertyName>
                  <ogc:Literal>ngo</ogc:Literal>
              </ogc:PropertyIsEqualTo>
              <ogc:PropertyIsEqualTo>
                  <ogc:PropertyName>office</ogc:PropertyName>
                  <ogc:Literal>union</ogc:Literal>
              </ogc:PropertyIsEqualTo>
            </ogc:Or> 
          </ogc:Or>  
          </ogc:Filter>
          <MinScaleDenominator>20000000</MinScaleDenominator>
          <MaxScaleDenominator>70000000</MaxScaleDenominator>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:Mark>
                <sld:WellKnownName>circle</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter name="fill">#216b76</sld:CssParameter>
                </sld:Fill>
              </sld:Mark>
              <sld:Size>1.000000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </sld:NamedLayer>
</sld:StyledLayerDescriptor>
