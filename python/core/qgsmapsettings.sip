
class QgsMapSettings
{
%TypeHeaderCode
#include <qgsmapsettings.h>
%End

  public:
    QgsMapSettings();

    //! Return geographical coordinates of the rectangle that should be rendered.
    //! The actual visible extent used for rendering could be slightly different
    //! since the given extent may be expanded in order to fit the aspect ratio
    //! of output size. Use visibleExtent() to get the resulting extent.
    QgsRectangle extent() const;
    //! Set coordinates of the rectangle which should be rendered.
    //! The actual visible extent used for rendering could be slightly different
    //! since the given extent may be expanded in order to fit the aspect ratio
    //! of output size. Use visibleExtent() to get the resulting extent.
    void setExtent( const QgsRectangle& rect, bool magnified = true );

    //! Return the size of the resulting map image
    QSize outputSize() const;
    //! Set the size of the resulting map image
    void setOutputSize( QSize size );

    //! Return the rotation of the resulting map image
    //! Units are clockwise degrees
    //! @note added in 2.8
    double rotation() const;
    //! Set the rotation of the resulting map image
    //! Units are clockwise degrees
    //! @note added in 2.8
    void setRotation( double degrees );

    //! Return DPI used for conversion between real world units (e.g. mm) and pixels
    //! Default value is 96
    double outputDpi() const;
    //! Set DPI used for conversion between real world units (e.g. mm) and pixels
    void setOutputDpi( double dpi );

    /**
     * Set the magnification factor.
     * @param factor the factor of magnification
     * @note added in 2.16
     * @see magnificationFactor()
     */
    void setMagnificationFactor( double factor );

    //! Return the magnification factor.
    //! @note added in 2.16
    //! @see setMagnificationFactor()
    double magnificationFactor() const;

    //! Get list of layer IDs for map rendering
    //! The layers are stored in the reverse order of how they are rendered (layer with index 0 will be on top)
    QStringList layerIds() const;
    //! Get list of layers for map rendering
    //! The layers are stored in the reverse order of how they are rendered (layer with index 0 will be on top)
    QList<QgsMapLayer*> layers();
    //! Set list of layers for map rendering. The layers must be registered in QgsProject.
    //! The layers are stored in the reverse order of how they are rendered (layer with index 0 will be on top)
    void setLayers( const QList<QgsMapLayer*>& layers );

    //! Get map of map layer style overrides (key: layer ID, value: style name) where a different style should be used instead of the current one
    //! @note added in 2.8
    QMap<QString, QString> layerStyleOverrides() const;
    //! Set map of map layer style overrides (key: layer ID, value: style name) where a different style should be used instead of the current one
    //! @note added in 2.8
    void setLayerStyleOverrides( const QMap<QString, QString>& overrides );

    /** Get custom rendering flags. Layers might honour these to alter their rendering.
     *  @returns custom flags strings, separated by ';'
     * @note added in QGIS 2.16
     * @see setCustomRenderFlags()
     */
    QString customRenderFlags() const;

    /** Sets the custom rendering flags. Layers might honour these to alter their rendering.
     * @param customRenderFlags custom flags strings, separated by ';'
     * @note added in QGIS 2.16
     * @see customRenderFlags()
     */
    void setCustomRenderFlags( const QString& customRenderFlags );

    //! sets destination coordinate reference system
    void setDestinationCrs( const QgsCoordinateReferenceSystem& crs );
    //! returns CRS of destination coordinate reference system
    QgsCoordinateReferenceSystem destinationCrs() const;

    //! Get units of map's geographical coordinates - used for scale calculation
    QgsUnitTypes::DistanceUnit mapUnits() const;

    //! Set the background color of the map
    void setBackgroundColor( const QColor& color );
    //! Get the background color of the map
    QColor backgroundColor() const;

    //! Set color that is used for drawing of selected vector features
    void setSelectionColor( const QColor& color );
    //! Get color that is used for drawing of selected vector features
    QColor selectionColor() const;

    //! Enumeration of flags that adjust the way the map is rendered
    enum Flag
    {
      Antialiasing,               //!< Enable anti-aliasing for map rendering
      DrawEditingInfo,            //!< Enable drawing of vertex markers for layers in editing mode
      ForceVectorOutput,          //!< Vector graphics should not be cached and drawn as raster images
      UseAdvancedEffects,         //!< Enable layer transparency and blending effects
      DrawLabeling,               //!< Enable drawing of labels on top of the map
      UseRenderingOptimization,   //!< Enable vector simplification and other rendering optimizations
      DrawSelection,              //!< Whether vector selections should be shown in the rendered map
      DrawSymbolBounds,           //!< Draw bounds of symbols (for debugging/testing)
      RenderMapTile,              //!< Draw map such that there are no problems between adjacent tiles
      RenderPartialOutput,        //!< Whether to make extra effort to update map image with partially rendered layers (better for interactive map canvas). Added in QGIS 3.0
    };
    typedef QFlags<QgsMapSettings::Flag> Flags;

    //! Set combination of flags that will be used for rendering
    void setFlags( Flags flags );
    //! Enable or disable a particular flag (other flags are not affected)
    void setFlag( Flag flag, bool on = true );
    //! Return combination of flags used for rendering
    Flags flags() const;
    //! Check whether a particular flag is enabled
    bool testFlag( Flag flag ) const;

    //! sets format of internal QImage
    void setOutputImageFormat( QImage::Format format );
    //! format of internal QImage, default QImage::Format_ARGB32_Premultiplied
    QImage::Format outputImageFormat() const;

    //! Check whether the map settings are valid and can be used for rendering
    bool hasValidSettings() const;
    //! Return the actual extent derived from requested extent that takes takes output image size into account
    QgsRectangle visibleExtent() const;
    //! Return the visible area as a polygon (may be rotated)
    //! @note added in 2.8
    QPolygonF visiblePolygon() const;
    //! Return the distance in geographical coordinates that equals to one pixel in the map
    double mapUnitsPerPixel() const;
    //! Return the calculated scale of the map
    double scale() const;

    /** Sets the expression context. This context is used for all expression evaluation
     * associated with this map settings.
     * @see expressionContext()
     * @note added in QGIS 2.12
     */
    void setExpressionContext( const QgsExpressionContext& context );

    /** Gets the expression context. This context should be used for all expression evaluation
     * associated with this map settings.
     * @see setExpressionContext()
     * @note added in QGIS 2.12
     */
    const QgsExpressionContext& expressionContext() const;

    // -- utility functions --

    //! @note not available in python bindings
    //const QgsDatumTransformStore& datumTransformStore() const;
    QgsDatumTransformStore& datumTransformStore();

    const QgsMapToPixel& mapToPixel() const;

    /** Computes an *estimated* conversion factor between layer and map units: layerUnits * layerToMapUnits = mapUnits
     * @param layer The layer
     * @param referenceExtent A reference extent based on which to perform the computation. If not specified, the layer extent is used
     * @note added in QGIS 2.12
     */
    double layerToMapUnits( const QgsMapLayer* layer, const QgsRectangle& referenceExtent = QgsRectangle() ) const;

    /**
     * @brief transform bounding box from layer's CRS to output CRS
     * @see layerToMapCoordinates( QgsMapLayer* layer, QgsRectangle rect ) if you want to transform a rectangle
     * @return a bounding box (aligned rectangle) containing the transformed extent
     */
    QgsRectangle layerExtentToOutputExtent( const QgsMapLayer* layer, QgsRectangle extent ) const;

    /**
     * @brief transform bounding box from output CRS to layer's CRS
     * @see mapToLayerCoordinates( QgsMapLayer* layer,QgsRectangle rect ) if you want to transform a rectangle
     * @return a bounding box (aligned rectangle) containing the transformed extent
     */
    QgsRectangle outputExtentToLayerExtent( const QgsMapLayer* layer, QgsRectangle extent ) const;

    /**
     * @brief transform point coordinates from layer's CRS to output CRS
     * @return the transformed point
     */
    QgsPoint layerToMapCoordinates( const QgsMapLayer* layer, QgsPoint point ) const;

    /**
     * @brief transform rectangle from layer's CRS to output CRS
     * @see layerExtentToOutputExtent() if you want to transform a bounding box
     * @return the transformed rectangle
     */
    QgsRectangle layerToMapCoordinates( const QgsMapLayer* layer, QgsRectangle rect ) const;

    /**
     * @brief transform point coordinates from output CRS to layer's CRS
     * @return the transformed point
     */
    QgsPoint mapToLayerCoordinates( const QgsMapLayer* layer, QgsPoint point ) const;

    /**
     * @brief transform rectangle from output CRS to layer's CRS
     * @see outputExtentToLayerExtent() if you want to transform a bounding box
     * @return the transformed rectangle
     */
    QgsRectangle mapToLayerCoordinates( const QgsMapLayer* layer, QgsRectangle rect ) const;

    /**
     * @brief Return coordinate transform from layer's CRS to destination CRS
     * @param layer
     * @return transform - may be invalid if the transform is not needed
     */
    QgsCoordinateTransform layerTransform( const QgsMapLayer *layer ) const;

    //! returns current extent of layer set
    QgsRectangle fullExtent() const;

    /* serialization */

    void readXml( QDomNode& node );

    void writeXml( QDomNode& node, QDomDocument& doc );

    /** Sets the segmentation tolerance applied when rendering curved geometries
    @param tolerance the segmentation tolerance*/
    void setSegmentationTolerance( double tolerance );
    /** Gets the segmentation tolerance applied when rendering curved geometries*/
    double segmentationTolerance() const;
    /** Sets segmentation tolerance type (maximum angle or maximum difference between curve and approximation)
    @param type the segmentation tolerance typename*/
    void setSegmentationToleranceType( QgsAbstractGeometry::SegmentationToleranceType type );
    /** Gets segmentation tolerance type (maximum angle or maximum difference between curve and approximation)*/
    QgsAbstractGeometry::SegmentationToleranceType segmentationToleranceType() const;

    /**
     * Sets global configuration of the labeling engine
     * \since QGIS 3.0
     */
    void setLabelingEngineSettings( const QgsLabelingEngineSettings &settings );

    /**
     * Returns global configuration of the labeling engine
     * \since QGIS 3.0
     */
    const QgsLabelingEngineSettings &labelingEngineSettings() const;

  protected:

    void updateDerived();
};

QFlags<QgsMapSettings::Flag> operator|(QgsMapSettings::Flag f1, QFlags<QgsMapSettings::Flag> f2);
