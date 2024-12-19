<?xml version="1.0" encoding="UTF-8"?><sld:StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc" version="1.0.0">
  <sld:NamedLayer>
    <sld:Name>social_facility_cluster</sld:Name>
    <sld:UserStyle>
      <sld:Name>social_facility_cluster</sld:Name>
      <sld:FeatureTypeStyle>
        <Transformation>
            <ogc:Function name="gs:PointStacker">
                <ogc:Function name="parameter">
                <ogc:Literal>data</ogc:Literal>
                </ogc:Function>
                <ogc:Function name="parameter">
                <ogc:Literal>cellSize</ogc:Literal>
                <ogc:Literal>150</ogc:Literal>
                </ogc:Function>
                <ogc:Function name="parameter">
                <ogc:Literal>outputBBOX</ogc:Literal>
                <ogc:Function name="env">
                <ogc:Literal>wms_bbox</ogc:Literal>
                </ogc:Function>
                </ogc:Function>
                <ogc:Function name="parameter">
                <ogc:Literal>outputWidth</ogc:Literal>
                <ogc:Function name="env">
                <ogc:Literal>wms_width</ogc:Literal>
                </ogc:Function>
                </ogc:Function>
                <ogc:Function name="parameter">
                <ogc:Literal>outputHeight</ogc:Literal>
                <ogc:Function name="env">
                    <ogc:Literal>wms_height</ogc:Literal>
                </ogc:Function>
                </ogc:Function>
            </ogc:Function>
        </Transformation>
        <Rule>
          <Name>Entre 5 et 25 structures sociales</Name>
          <ogc:Filter>
            <ogc:PropertyIsBetween>
              <ogc:PropertyName>count</ogc:PropertyName>
              <ogc:LowerBoundary>
                <ogc:Literal>5</ogc:Literal>
              </ogc:LowerBoundary>
              <ogc:UpperBoundary>
                <ogc:Literal>25</ogc:Literal>
              </ogc:UpperBoundary>
            </ogc:PropertyIsBetween>
          </ogc:Filter>
          <!-- <MinScaleDenominator>1000000</MinScaleDenominator> -->
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>circle</WellKnownName>
                <Fill>
                  <CssParameter name="fill">#9bd8ce</CssParameter>
                </Fill>
              </Mark>
              <Size>15</Size>
            </Graphic>
          </PointSymbolizer>
          <TextSymbolizer>
            <Label>
              <ogc:PropertyName>count</ogc:PropertyName>
            </Label>
            <Font>
              <CssParameter name="font-family">Arial</CssParameter>
              <CssParameter name="font-size">9</CssParameter>
              <CssParameter name="font-weight">bold</CssParameter>
            </Font>
            <LabelPlacement>
              <PointPlacement>
                <AnchorPoint>
                  <AnchorPointX>0.5</AnchorPointX>
                  <AnchorPointY>0.8</AnchorPointY>
                </AnchorPoint>
              </PointPlacement>
            </LabelPlacement>
            <Halo>
               <Radius>1</Radius>
               <Fill>
                 <CssParameter name="fill">#71c8b9</CssParameter>
                 <CssParameter name="fill-opacity">0.9</CssParameter>
               </Fill>
            </Halo>
            <Fill>
              <CssParameter name="fill">#FFFFFF</CssParameter>
              <CssParameter name="fill-opacity">1.0</CssParameter>
            </Fill>
          </TextSymbolizer>
        </Rule>
        <Rule>
          <Name>Entre 25 et 50 structures sociales</Name>
          <ogc:Filter>
            <ogc:PropertyIsBetween>
              <ogc:PropertyName>count</ogc:PropertyName>
              <ogc:LowerBoundary>
                <ogc:Literal>25</ogc:Literal>
              </ogc:LowerBoundary>
              <ogc:UpperBoundary>
                <ogc:Literal>50</ogc:Literal>
              </ogc:UpperBoundary>
            </ogc:PropertyIsBetween>
          </ogc:Filter>
          <!-- <MinScaleDenominator>XXX</MinScaleDenominator> -->
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>circle</WellKnownName>
                <Fill>
                  <CssParameter name="fill">#8dd3c7</CssParameter>
                </Fill>
              </Mark>
              <Size>20</Size>
            </Graphic>
          </PointSymbolizer>
           <TextSymbolizer>
            <Label>
              <ogc:PropertyName>count</ogc:PropertyName>
            </Label>
            <Font>
              <CssParameter name="font-family">Arial</CssParameter>
              <CssParameter name="font-size">10</CssParameter>
              <CssParameter name="font-weight">bold</CssParameter>
            </Font>
            <LabelPlacement>
              <PointPlacement>
                <AnchorPoint>
                  <AnchorPointX>0.5</AnchorPointX>
                  <AnchorPointY>0.8</AnchorPointY>
                </AnchorPoint>
              </PointPlacement>
            </LabelPlacement>
            <Halo>
               <Radius>1</Radius>
               <Fill>
                 <CssParameter name="fill">#71c8b9</CssParameter>
                 <CssParameter name="fill-opacity">0.9</CssParameter>
               </Fill>
            </Halo>
            <Fill>
              <CssParameter name="fill">#FFFFFF</CssParameter>
              <CssParameter name="fill-opacity">1.0</CssParameter>
            </Fill>
          </TextSymbolizer>
        </Rule>
        <Rule>
          <Name>Entre 50 et 100 structures sociales</Name>
          <ogc:Filter>
            <ogc:PropertyIsBetween>
              <ogc:PropertyName>count</ogc:PropertyName>
              <ogc:LowerBoundary>
                <ogc:Literal>50</ogc:Literal>
              </ogc:LowerBoundary>
              <ogc:UpperBoundary>
                <ogc:Literal>100</ogc:Literal>
              </ogc:UpperBoundary>
            </ogc:PropertyIsBetween>
          </ogc:Filter>
          <!-- <MinScaleDenominator>XXX</MinScaleDenominator> -->
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>circle</WellKnownName>
                <Fill>
                  <CssParameter name="fill">#7fcec0</CssParameter>
                </Fill>
              </Mark>
              <Size>30</Size>
            </Graphic>
          </PointSymbolizer>
           <TextSymbolizer>
            <Label>
              <ogc:PropertyName>count</ogc:PropertyName>
            </Label>
            <Font>
              <CssParameter name="font-family">Arial</CssParameter>
              <CssParameter name="font-size">11</CssParameter>
              <CssParameter name="font-weight">bold</CssParameter>
            </Font>
            <LabelPlacement>
              <PointPlacement>
                <AnchorPoint>
                  <AnchorPointX>0.5</AnchorPointX>
                  <AnchorPointY>0.8</AnchorPointY>
                </AnchorPoint>
              </PointPlacement>
            </LabelPlacement>
            <Halo>
               <Radius>1</Radius>
               <Fill>
                 <CssParameter name="fill">#71c8b9</CssParameter>
                 <CssParameter name="fill-opacity">0.9</CssParameter>
               </Fill>
            </Halo>
            <Fill>
              <CssParameter name="fill">#FFFFFF</CssParameter>
              <CssParameter name="fill-opacity">1.0</CssParameter>
            </Fill>
          </TextSymbolizer>
        </Rule>
        <Rule>
          <Name>Plus de 100 structures sociales</Name>
          <ogc:Filter>
            <ogc:PropertyIsGreaterThan>
              <ogc:PropertyName>count</ogc:PropertyName>
              <ogc:Literal>100</ogc:Literal>
            </ogc:PropertyIsGreaterThan>
          </ogc:Filter>
          <!-- <MinScaleDenominator>XXX</MinScaleDenominator> -->
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>circle</WellKnownName>
                <Fill>
                  <CssParameter name="fill">#71c8b9</CssParameter>
                </Fill>
              </Mark>
              <Size>35</Size>
            </Graphic>
          </PointSymbolizer>
           <TextSymbolizer>
            <Label>
              <ogc:PropertyName>count</ogc:PropertyName>
            </Label>
            <Font>
              <CssParameter name="font-family">Arial</CssParameter>
              <CssParameter name="font-size">12</CssParameter>
              <CssParameter name="font-weight">bold</CssParameter>
            </Font>
            <LabelPlacement>
              <PointPlacement>
                <AnchorPoint>
                  <AnchorPointX>0.5</AnchorPointX>
                  <AnchorPointY>0.8</AnchorPointY>
                </AnchorPoint>
              </PointPlacement>
            </LabelPlacement>
            <Halo>
               <Radius>1</Radius>
               <Fill>
                 <CssParameter name="fill">#71c8b9</CssParameter>
                 <CssParameter name="fill-opacity">0.9</CssParameter>
               </Fill>
            </Halo>
            <Fill>
              <CssParameter name="fill">#FFFFFF</CssParameter>
              <CssParameter name="fill-opacity">1.0</CssParameter>
            </Fill>
          </TextSymbolizer>
        </Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </sld:NamedLayer>
</sld:StyledLayerDescriptor>