/***************************************************************************
  qgscrashreport.cpp - QgsCrashReport

 ---------------------
 begin                : 16.4.2017
 copyright            : (C) 2017 by Nathan Woodrow
 email                : woodrow.nathan@gmail.com
 ***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
#include "qgscrashreport.h"

#include <QSysInfo>
#include <QFileInfo>
#include <QCryptographicHash>

#include "qgis.h"
#include "gdal_version.h"
#include "ogr_core.h"

QgsCrashReport::QgsCrashReport()
{
  setFlags( QgsCrashReport::All );
}

void QgsCrashReport::setFlags( QgsCrashReport::Flags flags )
{
  mFlags = flags;
}

const QString QgsCrashReport::toString() const
{
  QStringList reportData;
  reportData.append( "Crash ID: " + crashID() );

  if ( flags().testFlag( QgsCrashReport::Stack ) )
  {
    reportData.append( "\n" );
    reportData.append( "Stack Trace" );
    reportData.append( "===========" );
    if ( mStackTrace.isEmpty() )
    {
      reportData.append( "Stack trace unable to be generated." );
    }
    else
    {
      Q_FOREACH ( const QgsStackTrace::StackLine &line, mStackTrace )
      {
        QFileInfo fileInfo( line.fileName );
        QString filename( fileInfo.fileName() );
        reportData.append( QString( "(%1) %2 %3:%4" ).arg( line.moduleName, line.symbolName, filename, line.lineNumber ) );
      }
    }
  }

  if ( flags().testFlag( QgsCrashReport::Plugins ) )
  {
    reportData.append( "\n" );
    reportData.append( "Plugins" );
    reportData.append( "=======" );
    // TODO Get plugin info
  }

  if ( flags().testFlag( QgsCrashReport::ProjectDetails ) )
  {
    reportData.append( "\n" );
    reportData.append( "Project Info" );
    reportData.append( "============" );
    // TODO Get project details
  }

  if ( flags().testFlag( QgsCrashReport::QgisInfo ) )
  {
    reportData.append( "\n" );
    reportData.append( "QGIS Info" );
    reportData.append( "=========" );
    reportData.append( QString( "QGIS Version: %1" ).arg( Qgis::QGIS_VERSION ) );

    if ( QString( Qgis::QGIS_DEV_VERSION ) == QLatin1String( "exported" ) )
    {
      reportData.append( QString( "QGIS code branch: Release %1.%2" )
                         .arg( Qgis::QGIS_VERSION_INT / 10000 ).arg( Qgis::QGIS_VERSION_INT / 100 % 100 ) );
    }
    else
    {
      reportData.append( QString( "QGIS code revision: %1" ).arg( Qgis::QGIS_DEV_VERSION ) );
    }

    reportData.append( QString( "Compiled against Qt: %1" ).arg( QT_VERSION_STR ) );
    reportData.append( QString( "Running against Qt: %1" ).arg( qVersion() ) );

    reportData.append( QString( "Compiled against GDAL: %1" ).arg( GDAL_RELEASE_NAME ) );
    reportData.append( QString( "Running against GDAL: %1" ).arg( GDALVersionInfo( "RELEASE_NAME" ) ) );
  }

  if ( flags().testFlag( QgsCrashReport::SystemInfo ) )
  {
    reportData.append( "\n" );
    reportData.append( "System Info" );
    reportData.append( "===========" );
    reportData.append( QString( "CPU Type: %1" ).arg( QSysInfo::currentCpuArchitecture() ) );
    reportData.append( QString( "Kernel Type: %1" ).arg( QSysInfo::kernelType() ) );
    reportData.append( QString( "Kernel Version: %1" ).arg( QSysInfo::kernelVersion() ) );
  }

  QString report;
  Q_FOREACH ( QString line, reportData )
  {
    report += line + "\n";
  }
  return report;
}

const QString QgsCrashReport::crashID() const
{
  if ( mStackTrace.isEmpty() )
    return "ID not generated due to missing information\n\n Your version of QGIS install might not have debug information included.";

  QString data = QString::null;

  // Hashes the full stack.
  Q_FOREACH ( const QgsStackTrace::StackLine &line, mStackTrace )
  {
    QFileInfo fileInfo( line.fileName );
    QString filename( fileInfo.fileName() );
    data += line.symbolName;
  }

  if ( data.isNull() )
    return "ID not generated due to missing information";

  QString hash = QString( QCryptographicHash::hash( data.toAscii(), QCryptographicHash::Sha1 ).toHex() );
  return hash;
}
