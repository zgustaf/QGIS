/************************************************************************
 * This file has been generated automatically from                      *
 *                                                                      *
 * src/core/qgscolorschemeregistry.h                                    *
 *                                                                      *
 * Do not edit manually ! Edit header and run scripts/sipify.pl again   *
 ************************************************************************/




class QgsColorSchemeRegistry
{
%Docstring
 Registry of color schemes

 A registry of QgsColorScheme color schemes. This class can be created directly, or
 accessed via a QgsApplication.colorSchemeRegistry().
.. versionadded:: 2.5
%End

%TypeHeaderCode
#include "qgscolorschemeregistry.h"
%End
  public:

    QgsColorSchemeRegistry();
%Docstring
 Constructor for an empty color scheme registry
%End

    virtual ~QgsColorSchemeRegistry();

    void populateFromInstance();
%Docstring
 Adds all color schemes from the global instance to this color scheme.
 \see addDefaultSchemes
 \see addColorScheme
%End

    void addDefaultSchemes();
%Docstring
 Adds all default color schemes to this color scheme.
 \see populateFromInstance
 \see addColorScheme
 \see addUserSchemes
%End

    void addUserSchemes();
%Docstring
 Creates schemes for all gpl palettes in the user's palettes folder.
 \see populateFromInstance
 \see addDefaultSchemes
 \see addColorScheme
%End

    void addColorScheme( QgsColorScheme *scheme /Transfer/ );
%Docstring
 Adds a color scheme to the registry. Ownership of the scheme is transferred
 to the registry.
 \param scheme color scheme to add
 \see populateFromInstance
 \see removeColorScheme
%End

    bool removeColorScheme( QgsColorScheme *scheme );
%Docstring
 Removes all matching color schemes from the registry
 \param scheme color scheme to remove
 :return: true if scheme was found and removed
 \see addColorScheme
 :rtype: bool
%End

    QList<QgsColorScheme *> schemes() const;
%Docstring
 Returns all color schemes in the registry
 :return: list of color schemes
 :rtype: list of QgsColorScheme
%End

    QList<QgsColorScheme *> schemes( const QgsColorScheme::SchemeFlag flag ) const;
%Docstring
 Returns all color schemes in the registry which have a specified flag set
 \param flag flag to match
 :return: list of color schemes with flag set
 :rtype: list of QgsColorScheme
%End



};



/************************************************************************
 * This file has been generated automatically from                      *
 *                                                                      *
 * src/core/qgscolorschemeregistry.h                                    *
 *                                                                      *
 * Do not edit manually ! Edit header and run scripts/sipify.pl again   *
 ************************************************************************/
