<?xml version="1.0" encoding="UTF-8"?><sld:StyledLayerDescriptor version="1.0.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ogc="http://www.opengis.net/ogc" xmlns:gml="http://www.opengis.net/gml" xmlns:sld="http://www.opengis.net/sld">
  <sld:NamedLayer>
    <sld:Name>pnr_polygon</sld:Name>
    <sld:UserStyle>
      <sld:Name>pnr_polygon</sld:Name>
      <sld:Title/>
      <sld:FeatureTypeStyle>
        <sld:Name>pnr_polygon</sld:Name>
        <sld:Rule>
          <sld:Name>Parcs Naturels Regionaux</sld:Name>
          <sld:Title>Parcs Naturels Regionaux</sld:Title>
          <ogc:Filter>
             <ogc:And>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>boundary</ogc:PropertyName>
                                        <ogc:Literal>protected_area</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>protection_title</ogc:PropertyName>
                                        <ogc:Literal>parc naturel régional</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
              </ogc:And>
          </ogc:Filter>
          <sld:PolygonSymbolizer uom="http://www.opengeospatial.org/se/units/pixel">
            <sld:Fill>
              <sld:CssParameter name="fill">#98BC88</sld:CssParameter>
            </sld:Fill>
            <sld:Stroke>
              <sld:CssParameter name="stroke">#ACD09C</sld:CssParameter>
              <sld:CssParameter name="stroke-width">1</sld:CssParameter>
            </sld:Stroke>
          </sld:PolygonSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <MaxScaleDenominator>3000000</MaxScaleDenominator>
          <!--sld:Name>Parcs Naturels Regionaux Label</sld:Name-->
          <sld:TextSymbolizer>
              <sld:Geometry>
               <ogc:Function name="Centroid">
                <ogc:PropertyName>the_geom</ogc:PropertyName>
               </ogc:Function>
              </sld:Geometry>
            <sld:Label>
              <ogc:PropertyName>name</ogc:PropertyName>
            </sld:Label>
            <sld:Font>
              <sld:CssParameter name="font-family">DejaVu Sans</sld:CssParameter>
              <sld:CssParameter name="font-size">20</sld:CssParameter>
              <sld:CssParameter name="font-style">normal</sld:CssParameter>
              <sld:CssParameter name="font-weight">normal</sld:CssParameter>
            </sld:Font>
            <sld:LabelPlacement>
              <sld:PointPlacement>
                <sld:AnchorPoint>
                  <sld:AnchorPointX>0.5</sld:AnchorPointX>
                  <sld:AnchorPointY>0.5</sld:AnchorPointY>
                </sld:AnchorPoint>
                <sld:Displacement>
                  <sld:DisplacementX>0.0</sld:DisplacementX>
                  <sld:DisplacementY>-0.0</sld:DisplacementY>
                </sld:Displacement>
                <sld:Rotation>-0.0</sld:Rotation>
              </sld:PointPlacement>
            </sld:LabelPlacement>
            <sld:Fill>
              <sld:CssParameter name="fill">#000000</sld:CssParameter>
            </sld:Fill>
              <sld:VendorOption name="spaceAround">60</sld:VendorOption>
               <sld:VendorOption name="autoWrap">100</sld:VendorOption>
            <sld:VendorOption name="maxDisplacement">5</sld:VendorOption>
          </sld:TextSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </sld:NamedLayer>
</sld:StyledLayerDescriptor>