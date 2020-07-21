<?xml version="1.0" encoding="UTF-8"?><sld:StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc" version="1.0.0">
  <sld:NamedLayer>
    <sld:Name>france_hospitals_point</sld:Name>
    <sld:UserStyle>
      <sld:Name>france_hospitals_point</sld:Name>
      <sld:FeatureTypeStyle>
        <sld:Name>name</sld:Name>
        <sld:Rule> <!--règle pour visualisation à échelle locale, MAX:zoom12] et - -->
          <sld:Name>hôpital</sld:Name>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>amenity</ogc:PropertyName>
              <ogc:Literal>hospital</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <MaxScaleDenominator>200000</MaxScaleDenominator>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:ExternalGraphic>
                <sld:OnlineResource xmlns:xlink="http://www.w3.org/1999/xlink" xlink:type="simple" xlink:href="images/mag/health_pharmacy_-1377382206.svg"/>
                <sld:Format>image/svg+xml</sld:Format>
              </sld:ExternalGraphic>
              <sld:Size>20.000000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:Mark>
                <sld:WellKnownName>circle</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter name="fill">#ffffff</sld:CssParameter>
                  <sld:CssParameter name="fill-opacity">0.00</sld:CssParameter> 
                </sld:Fill>
                <sld:Stroke>
                  <sld:CssParameter name="stroke">#d31f8b</sld:CssParameter>
                </sld:Stroke>
              </sld:Mark>
              <sld:Size>20.000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
        <sld:Rule> <!--règle pour visualisation à échelle departementale, ]MIN:zoom11-MAX:zoom9]-->
          <sld:Name>hôpital</sld:Name>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>amenity</ogc:PropertyName>
              <ogc:Literal>hospital</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <MinScaleDenominator>200000</MinScaleDenominator>
          <MaxScaleDenominator>2000000</MaxScaleDenominator>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:ExternalGraphic>
                <sld:OnlineResource xmlns:xlink="http://www.w3.org/1999/xlink" xlink:type="simple" xlink:href="images/mag/health_pharmacy_-1377382206.svg"/>
                <sld:Format>image/svg+xml</sld:Format>
              </sld:ExternalGraphic>
              <sld:Size>15.000000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:Mark>
                <sld:WellKnownName>circle</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter name="fill">#ffffff</sld:CssParameter>
                  <sld:CssParameter name="fill-opacity">0.00</sld:CssParameter> 
                </sld:Fill>
                <sld:Stroke>
                  <sld:CssParameter name="stroke">#d31f8b</sld:CssParameter>
                </sld:Stroke>
              </sld:Mark>
              <sld:Size>15.000000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
        <sld:Rule> <!--règle pour visualisation à échelle regionale, [MIN:zoom8-MAX:zoom7]-->
          <sld:Name>hôpital</sld:Name>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>amenity</ogc:PropertyName>
              <ogc:Literal>hospital</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <MinScaleDenominator>2000000</MinScaleDenominator>
          <MaxScaleDenominator>5000000</MaxScaleDenominator>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:ExternalGraphic>
                <sld:OnlineResource xmlns:xlink="http://www.w3.org/1999/xlink" xlink:type="simple" xlink:href="images/mag/health_pharmacy_-1377382206.svg"/>
                <sld:Format>image/svg+xml</sld:Format>
              </sld:ExternalGraphic>
              <sld:Size>10.000000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:Mark>
                <sld:WellKnownName>circle</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter name="fill">#ffffff</sld:CssParameter>
                  <sld:CssParameter name="fill-opacity">0.00</sld:CssParameter> 
                </sld:Fill>
                <sld:Stroke>
                  <sld:CssParameter name="stroke">#d31f8b</sld:CssParameter>
                </sld:Stroke>
              </sld:Mark>
              <sld:Size>10.00000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
        <sld:Rule> <!--règle pour visualisation à échelle national, [MIN:zoom6-MAX:zoom5]-->
          <sld:Name>hôpital</sld:Name>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>amenity</ogc:PropertyName>
              <ogc:Literal>hospital</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <MinScaleDenominator>5000000</MinScaleDenominator>
          <MaxScaleDenominator>20000000</MaxScaleDenominator>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:ExternalGraphic>
                <sld:OnlineResource xmlns:xlink="http://www.w3.org/1999/xlink" xlink:type="simple" xlink:href="images/mag/health_pharmacy_-1377382206.svg"/>
                <sld:Format>image/svg+xml</sld:Format>
              </sld:ExternalGraphic>
              <sld:Size>5.000000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:Mark>
                <sld:WellKnownName>circle</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter name="fill">#ffffff</sld:CssParameter>
                  <sld:CssParameter name="fill-opacity">0.00</sld:CssParameter> 
                </sld:Fill>
                <sld:Stroke>
                  <sld:CssParameter name="stroke">#d31f8b</sld:CssParameter>
                </sld:Stroke>
              </sld:Mark>
              <sld:Size>5.000000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
        <sld:Rule> <!--règle pour visualisation à échelle worldwide, [MIN:zoom4 et +-->
          <sld:Name>hôpital</sld:Name>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>amenity</ogc:PropertyName>
              <ogc:Literal>hospital</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <MinScaleDenominator>20000000</MinScaleDenominator>
          <MaxScaleDenominator>70000000</MaxScaleDenominator>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:ExternalGraphic>
                <sld:OnlineResource xmlns:xlink="http://www.w3.org/1999/xlink" xlink:type="simple" xlink:href="images/mag/health_pharmacy_-1377382206.svg"/>
                <sld:Format>image/svg+xml</sld:Format>
              </sld:ExternalGraphic>
              <sld:Size>1.500000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
          <sld:PointSymbolizer>
            <sld:Graphic>
              <sld:Mark>
                <sld:WellKnownName>circle</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter name="fill">#ffffff</sld:CssParameter>
                  <sld:CssParameter name="fill-opacity">0.00</sld:CssParameter> 
                </sld:Fill>
                <sld:Stroke>
                  <sld:CssParameter name="stroke">#d31f8b</sld:CssParameter>
                </sld:Stroke>
              </sld:Mark>
              <sld:Size>1.500000</sld:Size>
            </sld:Graphic>
          </sld:PointSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
      <sld:FeatureTypeStyle>
         <sld:Rule>
          <MaxScaleDenominator>100000</MaxScaleDenominator>
           <sld:TextSymbolizer>
            <sld:Label>
              <ogc:PropertyName>name</ogc:PropertyName>
            </sld:Label>
            <sld:Font>
              <sld:CssParameter name="font-family">Arial</sld:CssParameter>
              <sld:CssParameter name="font-size">8.5</sld:CssParameter>
              <sld:CssParameter name="font-style">normal</sld:CssParameter>
              <sld:CssParameter name="font-weight">bold</sld:CssParameter>
            </sld:Font>
            <sld:LabelPlacement>
              <sld:PointPlacement>
                <sld:AnchorPoint>
                  <sld:AnchorPointX>0.5</sld:AnchorPointX>
                  <sld:AnchorPointY>0.5</sld:AnchorPointY>
                </sld:AnchorPoint>
                <sld:Displacement>
                  <sld:DisplacementX>0.0</sld:DisplacementX>
                  <sld:DisplacementY>-15.0</sld:DisplacementY>
                </sld:Displacement>
                <sld:Rotation>-0.0</sld:Rotation>
              </sld:PointPlacement>
            </sld:LabelPlacement>
            <sld:Halo>
               <sld:Radius>
                  <ogc:Literal>1</ogc:Literal>
               </sld:Radius>
               <sld:Fill>
                  <sld:CssParameter name="fill">#ffffff</sld:CssParameter>
               </sld:Fill>
            </sld:Halo>
            <sld:Fill>
              <sld:CssParameter name="fill">#d31f8b</sld:CssParameter>
            </sld:Fill>
          </sld:TextSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </sld:NamedLayer>
</sld:StyledLayerDescriptor>
