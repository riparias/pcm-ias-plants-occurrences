# load libraries
library(testthat)
library(readr)
library(dplyr)

# read proposed new version of the DwC mapping
occs_path <- here::here("data", "processed", "occurrence.csv")
dwc_occurrence_update <- readr::read_csv(occs_path, guess_max = 10000)

# tests
testthat::test_that("Right columns in right order", {
  columns <- c(
    "type",
    "language",
    "license",
    "rightsHolder",
    "accessRights",
    "datasetID",
    "institutionCode",
    "datasetName",
    "basisOfRecord",
    "samplingProtocol",
    "occurrenceID",
    "eventDate",
    "organismQuantity",
    "organismQuantityType",
    "continent",
    "countryCode",
    "stateProvince",
    "decimalLatitude",
    "decimalLongitude",
    "geodeticDatum",
    "coordinateUncertaintyInMeters",
    "verbatimLatitude",
    "verbatimLongitude",
    "verbatimSRS",
    "scientificName",
    "kingdom"
  )
  testthat::expect_equal(names(dwc_occurrence_update), columns)
})

testthat::test_that("occurrenceID is always present and is unique", {
  testthat::expect_true(all(!is.na(dwc_occurrence_update$occurrenceID)))
  testthat::expect_equal(length(unique(dwc_occurrence_update$occurrenceID)),
                         nrow(dwc_occurrence_update))
})

testthat::test_that("samplingProtocol is always Casual Observation", {
  testthat::expect_equal(
    dwc_occurrence_update %>%
      dplyr::distinct(samplingProtocol) %>%
      dplyr::pull(samplingProtocol),
    "casual observation"
  )
})

testthat::test_that(
  "organismQuantity is always an integer greater than 0 if present", {
    organismQuantity_values <-
      dwc_occurrence_update %>%
      dplyr::filter(!is.na(.data$organismQuantity)) %>%
      dplyr::distinct(.data$organismQuantity) %>%
      dplyr::pull(.data$organismQuantity)
    testthat::expect_equal(
      organismQuantity_values, as.integer(organismQuantity_values)
    )
})

testthat::test_that("coordinates and uncertainties are always filled in", {
  # decimalLatitude
  testthat::expect_true(
    all(!is.na(unique(dwc_occurrence_update$decimalLatitude)))
  )
  # decimalLongitude
  testthat::expect_true(
    all(!is.na(unique(dwc_occurrence_update$decimalLongitude)))
  )
  # verbatimLatitude
  testthat::expect_true(
    all(!is.na(unique(dwc_occurrence_update$verbatimLatitude)))
  )
  # verbatimLongitude
  testthat::expect_true(
    all(!is.na(unique(dwc_occurrence_update$verbatimLongitude)))
  )
  # coordinateUncertaintyInMeters
  testthat::expect_true(
    all(!is.na(unique(dwc_occurrence_update$coordinateUncertaintyInMeters)))
  )
})

testthat::test_that("eventDate is always filled in", {
  testthat::expect_true(all(!is.na(dwc_occurrence_update$eventDate)))
})

testthat::test_that("scientificName is never NA and one of the list", {
  species <- c(
    "Cabomba caroliniana",
    "Eichhornia crassipes",
    "Elodea nuttallii",
    "Eriocheir sinensis",
    "Gunnera tinctoria",
    "Heracleum mantegazzianum",
    "Hydrocotyle ranunculoides",
    "Impatiens glandulifera",
    "Lagarosiphon major",
    "Lithobates catesbeianus",
    "Ludwigia grandiflora",
    "Ludwigia peploides montevidensis",
    "Lysichiton americanus",
    "Microstegium vimineum",
    "Myriophyllum aquaticum",
    "Myriophyllum heterophyllum",
    "Trachemys scripta",
    "Ailanthus altissima",
    "Robinia",
    "Lepomis gibbosus",
    "Reynoutria",
    "Crassula helmsii",
    "Prunus serotina",
    "Fargesia",
    "Lamiastrum galeobdolon subsp. argentatum",
    "Solidago canadensis",
    "Rhus typhina",
    "Rosa rugosa",
    "Rosa multiflora",
    "Phytolacca americana",
    "Helianthus tuberosus",
    "Fallopia  baldschuanica",
    "Azolla filiculoides",
    "Harmonia axyridis",
    "Pistia statiotes"
  )
  testthat::expect_true(all(!is.na(dwc_occurrence_update$scientificName)))
  testthat::expect_true(all(dwc_occurrence_update$scientificName %in% species))
})

testthat::test_that("kingdom is always equal to Plantae or Animalia", {
  testthat::expect_true(all(!is.na(dwc_occurrence_update$kingdom)))
  testthat::expect_true(
    all(dwc_occurrence_update$kingdom %in% c("Plantae", "Animalia"))
  )
})

testthat::test_that(
  "vernacularName is one of the list and NA only for specific cases", {
    vernacular_names <- c(
      "waterwaaier",
      "waterhyacint",
      "smalle waterpest",
      "Chinese wolhandkrab",
      "gewone gunnera",
      "reuzenberenklauw",
      "grote waternavel",
      "reuzenbalsemien",
      "verspreidbladige waterpest",
      "Amerikaanse stierkikker",
      "waterteunisbloem",
      "postelein-waterlepeltje",
      "moerasaronskelk",
      "Japans steltgras",
      "parelvederkruid",
      "ongelijkbladig vederkruid",
      "lettersierschildpad",
      "hemelboom",
      "robinia",
      "zonnebaars",
      "watercrassula",
      "Amerikaanse vogelkers",
      "bonte gele dovenetel",
      "Canadese guldenroede",
      "fluweelboom",
      "rimpelroos",
      "veelbloemige roos",
      "westerse karmozijnbes",
      "aardpeer",
      "Chinese bruidssluier",
      "grote kroosvaren",
      "Veelkleurig Aziatisch lieveheersbeestje",
      "watersla"
    )
    species_to_exclude <- c("Fargesia", "Reynoutria")
    occs_with_valid_vernacular_names <-
      dwc_occurrence_update %>%
      dplyr::filter(!.data$scientificName %in% species_to_exclude)
    testthat::expect_true(
      all(!is.na(occs_with_valid_vernacular_names$vernacularName))
    )
    testthat::expect_true(
      all(occs_with_valid_vernacular_names$vernacularName %in% vernacular_names)
    )
})
