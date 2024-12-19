<?xml version="1.0" encoding="UTF-8"?><sld:StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc" version="1.0.0">
  <sld:NamedLayer>
    <sld:Name>bus_routes_line</sld:Name>
    <sld:UserStyle>
      <sld:Name>bus_routes_line</sld:Name>
      <sld:FeatureTypeStyle>
        <sld:Name>name</sld:Name>
          <sld:Rule>
            <sld:Name>bus</sld:Name>
            <sld:MinScaleDenominator>1</sld:MinScaleDenominator>
          	<sld:MaxScaleDenominator>75000</sld:MaxScaleDenominator>
            <sld:LineSymbolizer>
              <sld:Stroke>
                <sld:CssParameter name="stroke">
                  <ogc:PropertyName>colour</ogc:PropertyName>
                </sld:CssParameter>
                <sld:CssParameter name="stroke-linecap">square</sld:CssParameter>
                <sld:CssParameter name="stroke-linejoin">bevel</sld:CssParameter>
                <sld:CssParameter name="stroke-width">4.000000</sld:CssParameter>
              </sld:Stroke>
            </sld:LineSymbolizer>
            <sld:TextSymbolizer>
              <sld:Label>
                <ogc:PropertyName>ref</ogc:PropertyName>
              </sld:Label>
              <sld:Font>
                <sld:CssParameter name="font-family">MS Shell Dlg 2</sld:CssParameter>
                <sld:CssParameter name="font-size">13.0</sld:CssParameter>
                <sld:CssParameter name="font-style">normal</sld:CssParameter>
                <sld:CssParameter name="font-weight">bold</sld:CssParameter>
              </sld:Font>
 <sld:LabelPlacement>
              <sld:PointPlacement>
                <sld:AnchorPoint>
                  <sld:AnchorPointX>0.5</sld:AnchorPointX>
                  <sld:AnchorPointY>0.5</sld:AnchorPointY>
                </sld:AnchorPoint>
              </sld:PointPlacement>
            </sld:LabelPlacement>
            <sld:Halo>
              <sld:Radius>
                <ogc:Literal>1</ogc:Literal>
              </sld:Radius>
               <sld:Fill>
                <sld:CssParameter name="fill">#FFFFFF</sld:CssParameter>
              </sld:Fill>
            </sld:Halo>
              <sld:Fill>
                 <sld:CssParameter name="fill">#000000</sld:CssParameter>
              </sld:Fill>
              <sld:Graphic>
                <sld:Mark>
                  <sld:Fill>
                     <sld:CssParameter name="fill"><ogc:PropertyName>colour</ogc:PropertyName></sld:CssParameter>
                    
                  </sld:Fill>
                </sld:Mark>
                <sld:Size>10</sld:Size>
              </sld:Graphic>
              <sld:VendorOption name="graphic-resize">stretch</sld:VendorOption>
              <sld:VendorOption name="graphic-margin">2</sld:VendorOption>
            </sld:TextSymbolizer>
          </sld:Rule>
        
          <sld:Rule>
            <sld:Name>bus</sld:Name>
            <sld:MinScaleDenominator>75000</sld:MinScaleDenominator>
            <sld:MaxScaleDenominator>200000</sld:MaxScaleDenominator>
            <sld:LineSymbolizer>
              <sld:Stroke>
                <sld:CssParameter name="stroke">
                  <ogc:PropertyName>colour</ogc:PropertyName>
                </sld:CssParameter>
                <sld:CssParameter name="stroke-linecap">square</sld:CssParameter>
                <sld:CssParameter name="stroke-linejoin">bevel</sld:CssParameter>
                <sld:CssParameter name="stroke-width">2</sld:CssParameter>
              </sld:Stroke>
            </sld:LineSymbolizer>
          </sld:Rule>
        
          <sld:Rule>
            <sld:Name>bus</sld:Name>
            <sld:MinScaleDenominator>200000</sld:MinScaleDenominator>
            <sld:MaxScaleDenominator>600000</sld:MaxScaleDenominator>
            <sld:LineSymbolizer>
              <sld:Stroke>
                <sld:CssParameter name="stroke">
                  <ogc:PropertyName>colour</ogc:PropertyName>
                </sld:CssParameter>
                <sld:CssParameter name="stroke-linecap">square</sld:CssParameter>
                <sld:CssParameter name="stroke-linejoin">bevel</sld:CssParameter>
                <sld:CssParameter name="stroke-width">1</sld:CssParameter>
              </sld:Stroke>
            </sld:LineSymbolizer>
          </sld:Rule>
        
          <sld:Rule>
            <sld:Name>bus</sld:Name>
            <sld:MinScaleDenominator>600000</sld:MinScaleDenominator>
            <sld:MaxScaleDenominator>100000000</sld:MaxScaleDenominator>
            <sld:LineSymbolizer>
              <sld:Stroke>
                <sld:CssParameter name="stroke">
                  <ogc:PropertyName>colour</ogc:PropertyName>
                </sld:CssParameter>
                <sld:CssParameter name="stroke-linecap">square</sld:CssParameter>
                <sld:CssParameter name="stroke-linejoin">bevel</sld:CssParameter>
                <sld:CssParameter name="stroke-width">0.1</sld:CssParameter>
              </sld:Stroke>
            </sld:LineSymbolizer>
          </sld:Rule>


        
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </sld:NamedLayer>
</sld:StyledLayerDescriptor>