<?xml version="1.0" encoding="UTF-8"?><!--File Generated by symbo.xsl from Excel VCR Symbology StyleSheet--><!--Geometry Type LINE--><sld:StyledLayerDescriptor version="1.0.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ogc="http://www.opengis.net/ogc" xmlns:gml="http://www.opengis.net/gml" xmlns:sld="http://www.opengis.net/sld">
  <sld:NamedLayer>
    <sld:Name>highways_line
     Style
    </sld:Name>
    <sld:UserStyle>
      <sld:Name>highways_line
      Style
     </sld:Name>
      <sld:Title/>
      <sld:FeatureTypeStyle>
        <sld:Name>highways_line
       Style
      </sld:Name>
        
        
        
        
        <sld:Rule>
          <sld:Name>Living Street</sld:Name>
          <sld:Title>Living Street</sld:Title>
          <ogc:Filter>
<ogc:PropertyIsEqualTo>
                    <ogc:PropertyName>highway</ogc:PropertyName>
                    <ogc:Literal>living_street</ogc:Literal>
</ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <sld:MaxScaleDenominator>50000.0</sld:MaxScaleDenominator>
          <sld:LineSymbolizer uom="http://www.opengeospatial.org/se/units/metre">
            <sld:Stroke>
              <sld:CssParameter name="stroke">#303030</sld:CssParameter>
              <sld:CssParameter name="stroke-width">2</sld:CssParameter>
              <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>
            </sld:Stroke>
          </sld:LineSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>Pedestrian</sld:Name>
          <sld:Title>Pedestrian</sld:Title>
          <ogc:Filter>
<ogc:PropertyIsEqualTo>
                    <ogc:PropertyName>highway</ogc:PropertyName>
                    <ogc:Literal>pedestrian</ogc:Literal>
</ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <sld:MaxScaleDenominator>50000.0</sld:MaxScaleDenominator>
          <sld:LineSymbolizer uom="http://www.opengeospatial.org/se/units/metre">
            <sld:Stroke>
              <sld:CssParameter name="stroke">#bfbfbf</sld:CssParameter>
              <sld:CssParameter name="stroke-width">2</sld:CssParameter>
              <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>
            </sld:Stroke>
          </sld:LineSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>Service</sld:Name>
          <sld:Title>Service</sld:Title>
          <ogc:Filter>
<ogc:PropertyIsEqualTo>
                    <ogc:PropertyName>highway</ogc:PropertyName>
                    <ogc:Literal>service</ogc:Literal>
</ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <sld:MaxScaleDenominator>50000.0</sld:MaxScaleDenominator>
          <sld:LineSymbolizer uom="http://www.opengeospatial.org/se/units/metre">
            <sld:Stroke>
              <sld:CssParameter name="stroke">#bfbfbf</sld:CssParameter>
              <sld:CssParameter name="stroke-width">2</sld:CssParameter>
              <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>
            </sld:Stroke>
          </sld:LineSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>Road Background</sld:Name>
          <sld:Title>Road Background</sld:Title>
          <ogc:Filter>
<ogc:Or>
                    <ogc:Or>
                                        <ogc:PropertyIsEqualTo>
                                                            <ogc:PropertyName>highway</ogc:PropertyName>
                                                            <ogc:Literal>residential</ogc:Literal>
                                        </ogc:PropertyIsEqualTo>
                                        <ogc:PropertyIsEqualTo>
                                                            <ogc:PropertyName>highway</ogc:PropertyName>
                                                            <ogc:Literal>road</ogc:Literal>
                                        </ogc:PropertyIsEqualTo>
                    </ogc:Or>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>highway</ogc:PropertyName>
                                        <ogc:Literal>unclassified</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
</ogc:Or>
          </ogc:Filter>
          <sld:MaxScaleDenominator>50000.0</sld:MaxScaleDenominator>
          <sld:LineSymbolizer uom="http://www.opengeospatial.org/se/units/metre">
            <sld:Stroke>
              <sld:CssParameter name="stroke">#bfbfbf</sld:CssParameter>
              <sld:CssParameter name="stroke-width">6</sld:CssParameter>
              <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>
            </sld:Stroke>
          </sld:LineSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>Tertiary Road Background</sld:Name>
          <sld:Title>Tertiary Road Background</sld:Title>
          <ogc:Filter>
<ogc:Or>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>highway</ogc:PropertyName>
                                        <ogc:Literal>tertiary_link</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>highway</ogc:PropertyName>
                                        <ogc:Literal>tertiary</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
</ogc:Or>
          </ogc:Filter>
          <sld:MaxScaleDenominator>150000.0</sld:MaxScaleDenominator>
          <sld:LineSymbolizer uom="http://www.opengeospatial.org/se/units/metre">
            <sld:Stroke>
              <sld:CssParameter name="stroke">#bfbfbf</sld:CssParameter>
              <sld:CssParameter name="stroke-width">8</sld:CssParameter>
              <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>
            </sld:Stroke>
          </sld:LineSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>Secondary Road Background</sld:Name>
          <sld:Title>Secondary Road Background</sld:Title>
          <ogc:Filter>
<ogc:Or>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>highway</ogc:PropertyName>
                                        <ogc:Literal>secondary_link</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>highway</ogc:PropertyName>
                                        <ogc:Literal>secondary</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
</ogc:Or>
          </ogc:Filter>
          <sld:MaxScaleDenominator>300000.0</sld:MaxScaleDenominator>
          <sld:LineSymbolizer uom="http://www.opengeospatial.org/se/units/metre">
            <sld:Stroke>
              <sld:CssParameter name="stroke">#b1b389</sld:CssParameter>
              <sld:CssParameter name="stroke-width">10</sld:CssParameter>
              <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>
            </sld:Stroke>
          </sld:LineSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>Primary Road Background</sld:Name>
          <sld:Title>Primary Road Background</sld:Title>
          <ogc:Filter>
<ogc:Or>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>highway</ogc:PropertyName>
                                        <ogc:Literal>primary_link</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>highway</ogc:PropertyName>
                                        <ogc:Literal>primary</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
</ogc:Or>
          </ogc:Filter>
          <sld:LineSymbolizer uom="http://www.opengeospatial.org/se/units/metre">
            <sld:Stroke>
              <sld:CssParameter name="stroke">#b38347</sld:CssParameter>
              <sld:CssParameter name="stroke-width">10</sld:CssParameter>
              <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>
            </sld:Stroke>
          </sld:LineSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>trunk Background</sld:Name>
          <sld:Title>trunk Background</sld:Title>
          <ogc:Filter>
<ogc:Or>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>highway</ogc:PropertyName>
                                        <ogc:Literal>trunk_link</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>highway</ogc:PropertyName>
                                        <ogc:Literal>trunk</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
</ogc:Or>
          </ogc:Filter>
          <sld:LineSymbolizer uom="http://www.opengeospatial.org/se/units/metre">
            <sld:Stroke>
              <sld:CssParameter name="stroke">#b36147</sld:CssParameter>
              <sld:CssParameter name="stroke-width">14</sld:CssParameter>
              <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>
            </sld:Stroke>
          </sld:LineSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>motorway Background</sld:Name>
          <sld:Title>motorway Background</sld:Title>
          <ogc:Filter>
<ogc:Or>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>highway</ogc:PropertyName>
                                        <ogc:Literal>motorway_link</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>highway</ogc:PropertyName>
                                        <ogc:Literal>motorway</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
</ogc:Or>
          </ogc:Filter>
          <sld:LineSymbolizer uom="http://www.opengeospatial.org/se/units/metre">
            <sld:Stroke>
              <sld:CssParameter name="stroke">#b3475d</sld:CssParameter>
              <sld:CssParameter name="stroke-width">12</sld:CssParameter>
              <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>
            </sld:Stroke>
          </sld:LineSymbolizer>
        </sld:Rule>
     </sld:FeatureTypeStyle>
      <sld:FeatureTypeStyle>
   
        <sld:Rule>
          <sld:Name>Private</sld:Name>
          <sld:Title>Private</sld:Title>
          <ogc:Filter>
<ogc:And>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>private</ogc:PropertyName>
                                        <ogc:Literal>yes</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
                    <ogc:Not>
                                        <ogc:PropertyIsNull>
                                                            <ogc:PropertyName>highway</ogc:PropertyName>
                                        </ogc:PropertyIsNull>
                    </ogc:Not>
</ogc:And>
          </ogc:Filter>
          <sld:MaxScaleDenominator>50000.0</sld:MaxScaleDenominator>
          <sld:LineSymbolizer uom="http://www.opengeospatial.org/se/units/metre">
            <sld:Stroke>
              <sld:CssParameter name="stroke">#ff0004</sld:CssParameter>
              <sld:CssParameter name="stroke-width">1</sld:CssParameter>
              <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>
              <sld:CssParameter name="stroke-dasharray">3 2</sld:CssParameter>
            </sld:Stroke>
          </sld:LineSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>Track</sld:Name>
          <sld:Title>Track</sld:Title>
          <ogc:Filter>
<ogc:PropertyIsEqualTo>
                    <ogc:PropertyName>highway</ogc:PropertyName>
                    <ogc:Literal>track</ogc:Literal>
</ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <sld:MaxScaleDenominator>50000.0</sld:MaxScaleDenominator>
          <sld:LineSymbolizer uom="http://www.opengeospatial.org/se/units/metre">
            <sld:Stroke>
              <sld:CssParameter name="stroke">#ab8332</sld:CssParameter>
              <sld:CssParameter name="stroke-width">1</sld:CssParameter>
              <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>
              <sld:CssParameter name="stroke-dasharray">3 2</sld:CssParameter>
            </sld:Stroke>
          </sld:LineSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>Living Street</sld:Name>
          <sld:Title>Living Street</sld:Title>
          <ogc:Filter>
<ogc:PropertyIsEqualTo>
                    <ogc:PropertyName>highway</ogc:PropertyName>
                    <ogc:Literal>living_street</ogc:Literal>
</ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <sld:MaxScaleDenominator>50000.0</sld:MaxScaleDenominator>
          <sld:LineSymbolizer uom="http://www.opengeospatial.org/se/units/metre">
            <sld:Stroke>
              <sld:CssParameter name="stroke">#dddde8</sld:CssParameter>
              <sld:CssParameter name="stroke-width">1</sld:CssParameter>
              <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>
            </sld:Stroke>
          </sld:LineSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>Pedestrian</sld:Name>
          <sld:Title>Pedestrian</sld:Title>
          <ogc:Filter>
<ogc:PropertyIsEqualTo>
                    <ogc:PropertyName>highway</ogc:PropertyName>
                    <ogc:Literal>pedestrian</ogc:Literal>
</ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <sld:MaxScaleDenominator>50000.0</sld:MaxScaleDenominator>
          <sld:LineSymbolizer uom="http://www.opengeospatial.org/se/units/metre">
            <sld:Stroke>
              <sld:CssParameter name="stroke">#dddde8</sld:CssParameter>
              <sld:CssParameter name="stroke-width">1</sld:CssParameter>
              <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>
            </sld:Stroke>
          </sld:LineSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>Service</sld:Name>
          <sld:Title>Service</sld:Title>
          <ogc:Filter>
<ogc:PropertyIsEqualTo>
                    <ogc:PropertyName>highway</ogc:PropertyName>
                    <ogc:Literal>service</ogc:Literal>
</ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <sld:MaxScaleDenominator>50000.0</sld:MaxScaleDenominator>
          <sld:LineSymbolizer uom="http://www.opengeospatial.org/se/units/metre">
            <sld:Stroke>
              <sld:CssParameter name="stroke">#ffffff</sld:CssParameter>
              <sld:CssParameter name="stroke-width">1</sld:CssParameter>
              <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>
            </sld:Stroke>
          </sld:LineSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>Road</sld:Name>
          <sld:Title>Road</sld:Title>
          <ogc:Filter>
<ogc:Or>
                    <ogc:Or>
                                        <ogc:PropertyIsEqualTo>
                                                            <ogc:PropertyName>highway</ogc:PropertyName>
                                                            <ogc:Literal>residential</ogc:Literal>
                                        </ogc:PropertyIsEqualTo>
                                        <ogc:PropertyIsEqualTo>
                                                            <ogc:PropertyName>highway</ogc:PropertyName>
                                                            <ogc:Literal>road</ogc:Literal>
                                        </ogc:PropertyIsEqualTo>
                    </ogc:Or>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>highway</ogc:PropertyName>
                                        <ogc:Literal>unclassified</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
</ogc:Or>
          </ogc:Filter>
          <sld:MaxScaleDenominator>50000.0</sld:MaxScaleDenominator>
          <sld:LineSymbolizer uom="http://www.opengeospatial.org/se/units/metre">
            <sld:Stroke>
              <sld:CssParameter name="stroke">#ffffff</sld:CssParameter>
              <sld:CssParameter name="stroke-width">3</sld:CssParameter>
              <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>
            </sld:Stroke>
          </sld:LineSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>Tertiary Road</sld:Name>
          <sld:Title>Tertiary Road</sld:Title>
          <ogc:Filter>
<ogc:Or>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>highway</ogc:PropertyName>
                                        <ogc:Literal>tertiary_link</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>highway</ogc:PropertyName>
                                        <ogc:Literal>tertiary</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
</ogc:Or>
          </ogc:Filter>
          <sld:MaxScaleDenominator>150000.0</sld:MaxScaleDenominator>
          <sld:LineSymbolizer uom="http://www.opengeospatial.org/se/units/metre">
            <sld:Stroke>
              <sld:CssParameter name="stroke">#ffffff</sld:CssParameter>
              <sld:CssParameter name="stroke-width">5</sld:CssParameter>
              <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>
            </sld:Stroke>
          </sld:LineSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>Secondary Road</sld:Name>
          <sld:Title>Secondary Road</sld:Title>
          <ogc:Filter>
<ogc:Or>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>highway</ogc:PropertyName>
                                        <ogc:Literal>secondary_link</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>highway</ogc:PropertyName>
                                        <ogc:Literal>secondary</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
</ogc:Or>
          </ogc:Filter>
          <sld:MaxScaleDenominator>300000.0</sld:MaxScaleDenominator>
          <sld:LineSymbolizer uom="http://www.opengeospatial.org/se/units/metre">
            <sld:Stroke>
              <sld:CssParameter name="stroke">#f6f9be</sld:CssParameter>
              <sld:CssParameter name="stroke-width">7</sld:CssParameter>
              <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>
            </sld:Stroke>
          </sld:LineSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>Primary Road</sld:Name>
          <sld:Title>Primary Road</sld:Title>
          <ogc:Filter>
<ogc:Or>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>highway</ogc:PropertyName>
                                        <ogc:Literal>primary_link</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>highway</ogc:PropertyName>
                                        <ogc:Literal>primary</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
</ogc:Or>
          </ogc:Filter>
          <sld:LineSymbolizer uom="http://www.opengeospatial.org/se/units/metre">
            <sld:Stroke>
              <sld:CssParameter name="stroke">#fbd5a4</sld:CssParameter>
              <sld:CssParameter name="stroke-width">7</sld:CssParameter>
              <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>
            </sld:Stroke>
          </sld:LineSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>Trunk</sld:Name>
          <sld:Title>Trunk</sld:Title>
          <ogc:Filter>
<ogc:Or>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>highway</ogc:PropertyName>
                                        <ogc:Literal>trunk_link</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>highway</ogc:PropertyName>
                                        <ogc:Literal>trunk</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
</ogc:Or>
          </ogc:Filter>
          <sld:LineSymbolizer uom="http://www.opengeospatial.org/se/units/metre">
            <sld:Stroke>
              <sld:CssParameter name="stroke">#f9b29c</sld:CssParameter>
              <sld:CssParameter name="stroke-width">12</sld:CssParameter>
              <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>
            </sld:Stroke>
          </sld:LineSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>Motorway</sld:Name>
          <sld:Title>Motorway</sld:Title>
          <ogc:Filter>
<ogc:Or>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>highway</ogc:PropertyName>
                                        <ogc:Literal>motorway_link</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>highway</ogc:PropertyName>
                                        <ogc:Literal>motorway</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
</ogc:Or>
          </ogc:Filter>
          <sld:LineSymbolizer uom="http://www.opengeospatial.org/se/units/metre">
            <sld:Stroke>
              <sld:CssParameter name="stroke">#e892a2</sld:CssParameter>
              <sld:CssParameter name="stroke-width">9</sld:CssParameter>
              <sld:CssParameter name="stroke-linecap">round</sld:CssParameter>
            </sld:Stroke>
          </sld:LineSymbolizer>
        </sld:Rule>
        
        <sld:Rule>
          <sld:Name>Motorway Road Label TextSymbolizer
    </sld:Name>
          <sld:Title>Motorway Road Label TextSymbolizer
    </sld:Title>
          <ogc:Filter>
<ogc:PropertyIsEqualTo>
                    <ogc:PropertyName>highway</ogc:PropertyName>
                    <ogc:Literal>motorway</ogc:Literal>
</ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <sld:MaxScaleDenominator>5000000.0</sld:MaxScaleDenominator>
          <sld:TextSymbolizer>
            <sld:Label>
              <ogc:PropertyName>ref</ogc:PropertyName>
            </sld:Label>
            <sld:Font>
              <sld:CssParameter name="font-family">Arial</sld:CssParameter>
              <sld:CssParameter name="font-size">11</sld:CssParameter>
              <sld:CssParameter name="font-style">normal </sld:CssParameter>
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
            <sld:Fill>
              <sld:CssParameter name="fill">#b36147</sld:CssParameter>
            </sld:Fill>
            <sld:Graphic>
              <sld:Mark>
                <sld:WellKnownName>square</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter name="fill">#e892a2</sld:CssParameter>
                </sld:Fill>
                <sld:Stroke>
                  <sld:CssParameter name="stroke">#b36147</sld:CssParameter>
                </sld:Stroke>
              </sld:Mark>
            </sld:Graphic>
            <sld:VendorOption name="graphic-resize">stretch</sld:VendorOption>
            <sld:VendorOption name="graphic-margin">2</sld:VendorOption>
            <sld:VendorOption name="repeat">150</sld:VendorOption>
            <sld:VendorOption name="group">yes</sld:VendorOption>
          </sld:TextSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>trunk Road Label TextSymbolizer
    </sld:Name>
          <sld:Title>trunk Road Label TextSymbolizer
    </sld:Title>
          <ogc:Filter>
<ogc:PropertyIsEqualTo>
                    <ogc:PropertyName>highway</ogc:PropertyName>
                    <ogc:Literal>trunk</ogc:Literal>
</ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <sld:MaxScaleDenominator>800000.0</sld:MaxScaleDenominator>
          <sld:TextSymbolizer>
            <sld:Label>
              <ogc:PropertyName>ref</ogc:PropertyName>
            </sld:Label>
            <sld:Font>
              <sld:CssParameter name="font-family">Arial</sld:CssParameter>
              <sld:CssParameter name="font-size">11</sld:CssParameter>
              <sld:CssParameter name="font-style">normal </sld:CssParameter>
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
            <sld:Fill>
              <sld:CssParameter name="fill">#b38347</sld:CssParameter>
            </sld:Fill>
            <sld:Graphic>
              <sld:Mark>
                <sld:WellKnownName>square</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter name="fill">#f9b29c</sld:CssParameter>
                </sld:Fill>
                <sld:Stroke>
                  <sld:CssParameter name="stroke">#b38347</sld:CssParameter>
                </sld:Stroke>
              </sld:Mark>
            </sld:Graphic>
            <sld:VendorOption name="graphic-resize">stretch</sld:VendorOption>
            <sld:VendorOption name="graphic-margin">2</sld:VendorOption>
            <sld:VendorOption name="repeat">150</sld:VendorOption>
            <sld:VendorOption name="group">yes</sld:VendorOption>
          </sld:TextSymbolizer>
        </sld:Rule>

        <sld:Rule>
          <sld:Name>Primary Road Label TextSymbolizer
    </sld:Name>
          <sld:Title>Primary Road Label TextSymbolizer
    </sld:Title>
          <ogc:Filter>
<ogc:PropertyIsEqualTo>
                    <ogc:PropertyName>highway</ogc:PropertyName>
                    <ogc:Literal>primary</ogc:Literal>
</ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <sld:MaxScaleDenominator>500000.0</sld:MaxScaleDenominator>
          <sld:TextSymbolizer>
            <sld:Label>
              <ogc:PropertyName>ref</ogc:PropertyName>
            </sld:Label>
            <sld:Font>
              <sld:CssParameter name="font-family">Arial</sld:CssParameter>
              <sld:CssParameter name="font-size">11</sld:CssParameter>
              <sld:CssParameter name="font-style">normal </sld:CssParameter>
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
              <sld:CssParameter name="fill">#b38347</sld:CssParameter>
            </sld:Fill>
            <sld:Graphic>
              <sld:Mark>
                <sld:WellKnownName>square</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter name="fill">#fbd5a4</sld:CssParameter>
                </sld:Fill>
                <sld:Stroke>
                  <sld:CssParameter name="stroke">#b38347</sld:CssParameter>
                </sld:Stroke>
              </sld:Mark>
            </sld:Graphic>
            <sld:VendorOption name="graphic-resize">stretch</sld:VendorOption>
            <sld:VendorOption name="graphic-margin">2</sld:VendorOption>
            <sld:VendorOption name="repeat">150</sld:VendorOption>
            <sld:VendorOption name="group">yes</sld:VendorOption>
          </sld:TextSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>Secondary Road label TextSymbolizer
    </sld:Name>
          <sld:Title>Secondary Road label TextSymbolizer
    </sld:Title>
          <ogc:Filter>
<ogc:PropertyIsEqualTo>
                    <ogc:PropertyName>highway</ogc:PropertyName>
                    <ogc:Literal>secondary</ogc:Literal>
</ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <sld:MaxScaleDenominator>500000.0</sld:MaxScaleDenominator>
          <sld:TextSymbolizer>
            <sld:Label>
              <ogc:PropertyName>ref</ogc:PropertyName>
            </sld:Label>
            <sld:Font>
              <sld:CssParameter name="font-family">Arial</sld:CssParameter>
              <sld:CssParameter name="font-size">10</sld:CssParameter>
              <sld:CssParameter name="font-style">normal </sld:CssParameter>
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
              <sld:CssParameter name="fill">#b1b389</sld:CssParameter>
            </sld:Fill>
            <sld:Graphic>
              <sld:Mark>
                <sld:WellKnownName>square</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter name="fill">#f6f9be</sld:CssParameter>
                </sld:Fill>
                <sld:Stroke>
                  <sld:CssParameter name="stroke">#b1b389</sld:CssParameter>
                </sld:Stroke>
              </sld:Mark>
            </sld:Graphic>
            <sld:VendorOption name="graphic-resize">stretch</sld:VendorOption>
            <sld:VendorOption name="graphic-margin">2</sld:VendorOption>
            <sld:VendorOption name="maxAngleDelta">90</sld:VendorOption>
            <sld:VendorOption name="spaceAround">5</sld:VendorOption>
            <sld:VendorOption name="repeat">150</sld:VendorOption>
            <sld:VendorOption name="group">yes</sld:VendorOption>
            <sld:VendorOption name="maxDisplacement">400</sld:VendorOption>
          </sld:TextSymbolizer>
        </sld:Rule>

        <sld:Rule>
          <sld:Name>Tertiary Road label TextSymbolizer
    </sld:Name>
          <sld:Title>Tertiary Road label TextSymbolizer
    </sld:Title>
          <ogc:Filter>
<ogc:Or>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>highway</ogc:PropertyName>
                                        <ogc:Literal>tertiary_link</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>highway</ogc:PropertyName>
                                        <ogc:Literal>tertiary</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
</ogc:Or>
          </ogc:Filter>
          <sld:MaxScaleDenominator>100000.0</sld:MaxScaleDenominator>
          <sld:TextSymbolizer>
            <sld:Label>
              <ogc:PropertyName>ref</ogc:PropertyName>
            </sld:Label>
            <sld:Font>
              <sld:CssParameter name="font-family">Arial</sld:CssParameter>
              <sld:CssParameter name="font-size">9</sld:CssParameter>
              <sld:CssParameter name="font-style">normal </sld:CssParameter>
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
              <sld:CssParameter name="fill">#bfbfbf</sld:CssParameter>
            </sld:Fill>
            <sld:Graphic>
              <sld:Mark>
                <sld:WellKnownName>square</sld:WellKnownName>
                <sld:Fill>
                  <sld:CssParameter name="fill">#ffffff</sld:CssParameter>
                </sld:Fill>
                <sld:Stroke>
                  <sld:CssParameter name="stroke">#bfbfbf</sld:CssParameter>
                </sld:Stroke>
              </sld:Mark>
            </sld:Graphic>
            <sld:VendorOption name="graphic-resize">stretch</sld:VendorOption>
            <sld:VendorOption name="graphic-margin">2</sld:VendorOption>
            <sld:VendorOption name="maxAngleDelta">90</sld:VendorOption>
            <sld:VendorOption name="spaceAround">5</sld:VendorOption>
            <sld:VendorOption name="repeat">150</sld:VendorOption>
            <sld:VendorOption name="group">yes</sld:VendorOption>
            <sld:VendorOption name="maxDisplacement">400</sld:VendorOption>
          </sld:TextSymbolizer>
        </sld:Rule>
        <sld:Rule>
          <sld:Name>Quaternary Road label TextSymbolizer
    </sld:Name>
          <sld:Title>Quaternary Road label TextSymbolizer
    </sld:Title>
          <ogc:Filter>
<ogc:Or>
                    <ogc:Or>
                                        <ogc:PropertyIsEqualTo>
                                                            <ogc:PropertyName>highway</ogc:PropertyName>
                                                            <ogc:Literal>residential</ogc:Literal>
                                        </ogc:PropertyIsEqualTo>
                                        <ogc:PropertyIsEqualTo>
                                                            <ogc:PropertyName>highway</ogc:PropertyName>
                                                            <ogc:Literal>road</ogc:Literal>
                                        </ogc:PropertyIsEqualTo>
                    </ogc:Or>
                    <ogc:PropertyIsEqualTo>
                                        <ogc:PropertyName>highway</ogc:PropertyName>
                                        <ogc:Literal>unclassified</ogc:Literal>
                    </ogc:PropertyIsEqualTo>
</ogc:Or>
          </ogc:Filter>
          <sld:MaxScaleDenominator>50000.0</sld:MaxScaleDenominator>
          <sld:TextSymbolizer>
            <sld:Label>
              <ogc:PropertyName>name</ogc:PropertyName>
            </sld:Label>
            <sld:Font>
              <sld:CssParameter name="font-family">Arial</sld:CssParameter>
              <sld:CssParameter name="font-size">10</sld:CssParameter>
              <sld:CssParameter name="font-style">normal </sld:CssParameter>
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
            <sld:Priority>
              <ogc:Literal>200</ogc:Literal>
            </sld:Priority>
            <sld:VendorOption name="maxAngleDelta">90</sld:VendorOption>
            <sld:VendorOption name="followLine">true</sld:VendorOption>
            <sld:VendorOption name="spaceAround">5</sld:VendorOption>
            <sld:VendorOption name="repeat">150</sld:VendorOption>
            <sld:VendorOption name="group">yes</sld:VendorOption>
            <sld:VendorOption name="maxDisplacement">400</sld:VendorOption>
          </sld:TextSymbolizer>
        </sld:Rule>
        <sld:Rule>
                   <sld:Name>Living Street</sld:Name>
          <sld:Title>Living Street</sld:Title>
<ogc:Filter>

<ogc:PropertyIsEqualTo>
<ogc:PropertyName>oneway</ogc:PropertyName>
<ogc:Literal>yes</ogc:Literal>
</ogc:PropertyIsEqualTo>
</ogc:Filter>
          <sld:MaxScaleDenominator>5000.0</sld:MaxScaleDenominator>
<sld:LineSymbolizer>
<sld:Stroke>
<sld:CssParameter name="stroke">#6c70d5</sld:CssParameter>
<sld:CssParameter name="stroke-width">1</sld:CssParameter>
<sld:CssParameter name="stroke-linejoin">bevel</sld:CssParameter>
<sld:CssParameter name="stroke-dasharray">0 12 10 152</sld:CssParameter>
</sld:Stroke>
</sld:LineSymbolizer>
<sld:LineSymbolizer>
<sld:Stroke>
<sld:CssParameter name="stroke">#6c70d5</sld:CssParameter>
<sld:CssParameter name="stroke-width">2</sld:CssParameter>
<sld:CssParameter name="stroke-linejoin">bevel</sld:CssParameter>
<sld:CssParameter name="stroke-dasharray">0 12 9 153</sld:CssParameter>
</sld:Stroke>
</sld:LineSymbolizer>
<sld:LineSymbolizer>
<sld:Stroke>
<sld:CssParameter name="stroke">#6c70d5</sld:CssParameter>
<sld:CssParameter name="stroke-width">3</sld:CssParameter>
<sld:CssParameter name="stroke-linejoin">bevel</sld:CssParameter>
<sld:CssParameter name="stroke-dasharray">0 18 2 154</sld:CssParameter>
</sld:Stroke>
</sld:LineSymbolizer>
<sld:LineSymbolizer>
<sld:Stroke>
<sld:CssParameter name="stroke">#6c70d5</sld:CssParameter>
<sld:CssParameter name="stroke-width">4</sld:CssParameter>
<sld:CssParameter name="stroke-linejoin">bevel</sld:CssParameter>
<sld:CssParameter name="stroke-dasharray">0 18 1 155</sld:CssParameter>
</sld:Stroke>
</sld:LineSymbolizer>
</sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </sld:NamedLayer>
</sld:StyledLayerDescriptor>