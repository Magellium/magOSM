<?xml version="1.0" encoding="UTF-8"?>

    <StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:se="http://www.opengis.net/se" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.1.0/StyledLayerDescriptor.xsd" version="1.1.0">

      <NamedLayer>

        <se:Name>Exchange-20190202 - point</se:Name>

        <UserStyle>

          <se:Name>Exchange-20190202 - point</se:Name>

          <se:FeatureTypeStyle>

            <se:Rule>

              <se:Name>Noeud de raccordement</se:Name>
                
              <se:Description>

                <se:Title>Noeud de raccordement</se:Title>

              </se:Description>

              <se:PointSymbolizer>

                <se:Graphic>

                  <se:Mark>

                    <se:WellKnownName>diamond</se:WellKnownName>

                    <se:Fill>

                      <se:SvgParameter name="fill">#487bb6</se:SvgParameter>

                    </se:Fill>

                    <se:Stroke>

                      <se:SvgParameter name="stroke">#325780</se:SvgParameter>

                      <se:SvgParameter name="stroke-width">1</se:SvgParameter>

                    </se:Stroke>

                  </se:Mark>

                  <se:Size>12</se:Size>

                </se:Graphic>

              </se:PointSymbolizer>

            </se:Rule>

            <se:Rule>
              
			        <se:MaxScaleDenominator>10000</se:MaxScaleDenominator>
              
              <se:TextSymbolizer>

                <se:Label>

                  <ogc:PropertyName>ref</ogc:PropertyName>

                </se:Label>

                <se:Font>

                  <se:SvgParameter name="font-family">MS Shell Dlg 2</se:SvgParameter>

                  <se:SvgParameter name="font-size">13</se:SvgParameter>

                </se:Font>

                <se:LabelPlacement>

                  <se:PointPlacement>

                    <se:AnchorPoint>

                      <se:AnchorPointX>0</se:AnchorPointX>

                      <se:AnchorPointY>0.5</se:AnchorPointY>

                    </se:AnchorPoint>

                  </se:PointPlacement>

                </se:LabelPlacement>

                <se:Fill>

                  <se:SvgParameter name="fill">#000000</se:SvgParameter>

                </se:Fill>

                <se:VendorOption name="maxDisplacement">1</se:VendorOption>

              </se:TextSymbolizer>

            </se:Rule>

            <se:Rule>

              <se:MaxScaleDenominator>10000</se:MaxScaleDenominator>
              
              <se:TextSymbolizer>

                <se:Label>

                  <ogc:PropertyName>ref-FR-PTT</ogc:PropertyName>

                </se:Label>

                <se:Font>

                  <se:SvgParameter name="font-family">MS Shell Dlg 2</se:SvgParameter>

                  <se:SvgParameter name="font-size">13</se:SvgParameter>

                </se:Font>

                <se:LabelPlacement>

                  <se:PointPlacement>

                    <se:AnchorPoint>

                      <se:AnchorPointX>0</se:AnchorPointX>

                      <se:AnchorPointY>0.5</se:AnchorPointY>

                    </se:AnchorPoint>

                  </se:PointPlacement>

                </se:LabelPlacement>

                <se:Fill>

                  <se:SvgParameter name="fill">#000000</se:SvgParameter>

                </se:Fill>

                <se:VendorOption name="maxDisplacement">1</se:VendorOption>

              </se:TextSymbolizer>

            </se:Rule>

          </se:FeatureTypeStyle>

        </UserStyle>

      </NamedLayer>

    </StyledLayerDescriptor>
