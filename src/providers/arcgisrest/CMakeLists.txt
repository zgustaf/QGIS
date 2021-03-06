INCLUDE_DIRECTORIES(
  ../../core
  ../../core/auth
  ../../core/geometry
  ../../core/raster
  ../../gui
  ../../gui/auth
  ${GEOS_INCLUDE_DIR}
  ${QSCINTILLA_INCLUDE_DIR}
  ${CMAKE_CURRENT_BINARY_DIR}/../../ui
  ${CMAKE_BINARY_DIR}/src/core
  ${CMAKE_BINARY_DIR}/src/gui
)

###############################################################################

SET (AFS_SRCS
  qgsarcgisrestutils.cpp
  qgsafsdataitems.cpp
  qgsafsfeatureiterator.cpp
  qgsafsprovider.cpp
  qgsafsproviderextern.cpp
  qgsafssourceselect.cpp
)
SET (AFS_MOC_HDRS
  qgsarcgisrestutils.h
  qgsafsdataitems.h
  qgsafsprovider.h
  qgsafssourceselect.h
)

QT5_WRAP_CPP (AFS_MOC_SRCS ${AFS_MOC_HDRS})

ADD_LIBRARY(arcgisfeatureserverprovider MODULE ${AFS_SRCS} ${AFS_MOC_SRCS})

TARGET_LINK_LIBRARIES(arcgisfeatureserverprovider
  qgis_core
  qgis_gui
)

INSTALL (TARGETS arcgisfeatureserverprovider
  RUNTIME DESTINATION ${QGIS_PLUGIN_DIR}
  LIBRARY DESTINATION ${QGIS_PLUGIN_DIR})

###############################################################################

SET (AMS_SRCS
  qgsarcgisrestutils.cpp
  qgsamsdataitems.cpp
  qgsamsprovider.cpp
  qgsamsproviderextern.cpp
  qgsamssourceselect.cpp
)
SET (AMS_MOC_HDRS
  qgsarcgisrestutils.h
  qgsamsdataitems.h
  qgsamsprovider.h
  qgsamssourceselect.h
)

QT5_WRAP_CPP (AMS_MOC_SRCS ${AMS_MOC_HDRS})

ADD_LIBRARY(arcgismapserverprovider MODULE ${AMS_SRCS} ${AMS_MOC_SRCS})

TARGET_LINK_LIBRARIES(arcgismapserverprovider
  qgis_core
  qgis_gui
)

INSTALL (TARGETS arcgismapserverprovider
  RUNTIME DESTINATION ${QGIS_PLUGIN_DIR}
  LIBRARY DESTINATION ${QGIS_PLUGIN_DIR})
