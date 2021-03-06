# -*- coding: utf-8 -*-

"""
***************************************************************************
    Buffer.py
    ---------------------
    Date                 : August 2012
    Copyright            : (C) 2012 by Victor Olaya
    Email                : volayaf at gmail dot com
***************************************************************************
*                                                                         *
*   This program is free software; you can redistribute it and/or modify  *
*   it under the terms of the GNU General Public License as published by  *
*   the Free Software Foundation; either version 2 of the License, or     *
*   (at your option) any later version.                                   *
*                                                                         *
***************************************************************************
"""

__author__ = 'Victor Olaya'
__date__ = 'August 2012'
__copyright__ = '(C) 2012, Victor Olaya'

# This will get replaced with a git SHA1 when you do a git archive

__revision__ = '$Format:%H$'

from qgis.core import QgsFeature, QgsGeometry, QgsProcessingUtils

from processing.tools import vector


def buffering(feedback, context, writer, distance, field, useField, layer, dissolve, segments, endCapStyle=1,
              joinStyle=1, mitreLimit=2):

    if useField:
        field = layer.fields().lookupField(field)

    outFeat = QgsFeature()

    current = 0
    features = QgsProcessingUtils.getFeatures(layer, context)
    total = 100.0 / QgsProcessingUtils.featureCount(layer, context)

    # With dissolve
    if dissolve:
        buffered_geometries = []
        for inFeat in features:
            attrs = inFeat.attributes()
            if useField:
                value = attrs[field]
            else:
                value = distance

            inGeom = inFeat.geometry()

            buffered_geometries.append(inGeom.buffer(float(value), segments, endCapStyle, joinStyle, mitreLimit))

            current += 1
            feedback.setProgress(int(current * total))

        final_geometry = QgsGeometry.unaryUnion(buffered_geometries)
        outFeat.setGeometry(final_geometry)
        outFeat.setAttributes(attrs)
        writer.addFeature(outFeat)
    else:
        # Without dissolve
        for inFeat in features:
            attrs = inFeat.attributes()
            if useField:
                value = attrs[field]
            else:
                value = distance
            inGeom = inFeat.geometry()
            outFeat = QgsFeature()
            outGeom = inGeom.buffer(float(value), segments, endCapStyle, joinStyle, mitreLimit)
            outFeat.setGeometry(outGeom)
            outFeat.setAttributes(attrs)
            writer.addFeature(outFeat)
            current += 1
            feedback.setProgress(int(current * total))

    del writer
