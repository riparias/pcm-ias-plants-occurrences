/*
Created by Damiano Oldoni (INBO)
*/

SELECT
-- RECORD-LEVEL
  'Event'                               AS type,
  'en'                                  AS language,
  'https://creativecommons.org/licenses/by-nc/4.0/legalcode' AS license,
  'POV'                                 AS rightsHolder,
  'http://www.inbo.be/en/norms-for-data-use' AS accessRights,
  ''     AS datasetID,
  'POV'                                 AS institutionCode,
  '' AS datasetName,
  'HumanObservation'                    AS basisOfRecord,
  o."SamplingProtocol"                  AS samplingProtocol,

-- OCCURRENCE
  o."Registratie ID" || ':' || AS occurrenceID,
  'Team ' || o."Team Naam"              AS recordedBy,
  CASE
    WHEN o."Vangst Aantal" IS NULL AND o."ScientificName" = '11 waterschildpadden' THEN 11
    WHEN o."Vangst Aantal" IS NULL AND o."ScientificName" = '100  canadese ganzen' THEN 100
    WHEN o."Vangst Aantal" IS NULL AND o."ScientificName" = 'Eendensterfte circa 25 st' THEN 25
    WHEN o."Vangst Aantal" IS NOT NULL THEN CAST(o."Vangst Aantal" AS INT)
    ELSE NULL
  END                                   AS individualCount,
END                                   AS occurrenceRemarks,
-- EVENT
o."Registratie ID"                    AS eventID,
date(o.Dag)                           AS eventDate,
-- LOCATION
o."Locatie ID"                        AS locationID,
'Europe'                              AS continent,
CASE
WHEN o.Land_Regio = 'Nederland'     THEN 'NL'
WHEN o.Land_Regio = 'Frankrijk'     THEN 'FR'
WHEN o.Land_Regio = 'Vlaanderen'    THEN 'BE'
 -- observations have no Land_Regio field and are assumed to be taken in Belgium
WHEN o.Land_Regio IS NULL           THEN 'BE'
ELSE NULL
END                                   AS countryCode,
CASE
WHEN o."VHA Gewestelijke Waterloop Omschrijving" = 'Onbekend' THEN NULL
ELSE o."VHA Gewestelijke Waterloop Omschrijving"
END                                   AS waterBody,
CASE
WHEN o."Provincie Omschrijving" = 'Antwerpen' THEN 'Antwerp'
WHEN o."Provincie Omschrijving" = 'Limburg' THEN 'Limburg'
WHEN o."Provincie Omschrijving" = 'Onbekend' THEN NULL
WHEN o."Provincie Omschrijving" = 'Oost-Vlaanderen' THEN 'East Flanders'
WHEN o."Provincie Omschrijving" = 'Vlaams-Brabant' THEN 'Flemish Brabant'
WHEN o."Provincie Omschrijving" = 'West-Vlaanderen' THEN 'West Flanders'
END                                   AS stateProvince,
CASE
WHEN o."Gemeente Naam" = 'Onbekend' THEN NULL
ELSE  o."Gemeente Naam"
END                                   AS municipality,
CASE
WHEN o."VHA Categorie Omschrijving" = 'Baangracht' THEN NULL
WHEN o."VHA Categorie Omschrijving" = 'Bevaarbaar' THEN 'BEV - waterway navigable'
WHEN o."VHA Categorie Omschrijving" = 'Grachten algemeen belang' THEN NULL
WHEN o."VHA Categorie Omschrijving" = 'Niet geklasseerd' THEN NULL
WHEN o."VHA Categorie Omschrijving" = 'Onbekend' THEN NULL
WHEN o."VHA Categorie Omschrijving" = 'Onbevaarbaar cat. 1' THEN 'CAT1 - waterway not navigable cat. 1'
WHEN o."VHA Categorie Omschrijving" = 'Onbevaarbaar cat. 2' THEN 'CAT2 - waterway not navigable cat. 2'
WHEN o."VHA Categorie Omschrijving" = 'Onbevaarbaar cat. 3' THEN 'CAT3 - waterway not navigable cat. 3'
WHEN o."VHA Categorie Omschrijving" = 'Polder of wateringgracht' THEN NULL
ELSE NULL
END                                   AS locationRemarks,
printf('%.5f', ROUND(o."Locatie GPS Breedte", 5)) AS decimalLatitude,
printf('%.5f', ROUND(o."Locatie GPS Lengte", 5)) AS decimalLongitude,
'WGS84'                               AS geodeticDatum,
30                                    AS coordinateUncertaintyInMeters,
-- TAXON
CASE
WHEN o."ScientificName" = 'Cabomba caroliniana' THEN 'Cabomba caroliniana'
WHEN o."ScientificName" = 'Eichhornia crassipes' THEN 'Eichhornia crassipes'
WHEN o."ScientificName" = 'Elodea nuttallii' THEN 'Elodea nuttallii'
WHEN o."ScientificName" = 'Eriocheir sinensis' THEN 'Eriocheir sinensis'
WHEN o."ScientificName" = 'Gunnera tinctoria' THEN 'Gunnera tinctoria'
WHEN o."ScientificName" = 'Heracleum mantegazzianum' THEN 'Heracleum mantegazzianum'
WHEN o."ScientificName" = 'Hydrocotyle ranunculoides' THEN 'Hydrocotyle ranunculoides'
WHEN o."ScientificName" = 'Impatiens glandulifera' THEN 'Impatiens glandulifera'
WHEN o."ScientificName" = 'Lagarosiphon major' THEN 'Lagarosiphon major'
WHEN o."ScientificName" = 'Lithobates catesbeianus' THEN 'Lithobates catesbeianus'
WHEN o."ScientificName" = 'Ludwigia grandiflora' THEN 'Ludwigia grandiflora'
WHEN o."ScientificName" = 'Ludwigia peploides montevidensis' THEN 'Ludwigia peploides montevidensis'
WHEN o."ScientificName" = 'Lysichiton americanus' THEN 'Lysichiton americanus'
WHEN o."ScientificName" = 'Microstegium vimineum' THEN 'Microstegium vimineum'
WHEN o."ScientificName" = 'Myriophyllum aquaticum' THEN 'Myriophyllum aquaticum'
WHEN o."ScientificName" = 'Myriophyllum heterophyllum' THEN 'Myriophyllum heterophyllum'
WHEN o."ScientificName" = 'Trachemys scripta' THEN 'Trachemys scripta'
WHEN o."ScientificName" = 'Ailanthus altissima' THEN 'Ailanthus altissima'
WHEN o."ScientificName" = 'Robinia spec.' THEN 'Robinia'
WHEN o."ScientificName" = 'Lepomis gibbosus' THEN 'Lepomis gibbosus'
WHEN o."ScientificName" = 'Fallopia / Reynoutria' THEN 'Reynoutria'
WHEN o."ScientificName" = 'Crassula helmsii' THEN 'Crassula helmsii'
WHEN o."ScientificName" = 'Prunus Serotina' THEN 'Prunus serotina'
WHEN o."ScientificName" = 'Fargesia' THEN 'Fargesia'
WHEN o."ScientificName" = 'Lamiastrum galeobdolon subsp. argentatum' THEN 'Lamiastrum galeobdolon subsp. argentatum'
WHEN o."ScientificName" = 'Solidago canadensis' THEN 'Solidago canadensis'
WHEN o."ScientificName" = 'Rhus typhina' THEN 'Rhus typhina'
WHEN o."ScientificName" = 'Rosa rugosa' THEN 'Rosa rugosa'
WHEN o."ScientificName" = 'Rosa multiflora' THEN 'Rosa multiflora'
WHEN o."ScientificName" = 'Phytolacca americana' THEN 'Phytolacca americana'
WHEN o."ScientificName" = 'Helianthus tuberosus' THEN 'Helianthus tuberosus'
WHEN o."ScientificName" = 'Fallopia  baldschuanica' THEN 'Fallopia  baldschuanica'
WHEN o."ScientificName" = 'Azolla filiculoides' THEN 'Azolla filiculoides'
WHEN o."ScientificName" = 'Harmonia axyridis' THEN 'Harmonia axyridis'
WHEN o."ScientificName" = 'Pistia statiotes' THEN 'Pistia statiotes'
ELSE NULL
END                                   AS scientificName,
o."Kingdom"                           AS kingdom,
FROM occurrences AS o
WHERE
  -- Remove observations of multiple unidentified taxa
  o."ScientificName" != 'Meerdere soorten'
