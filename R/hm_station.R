#' Get the information about one hydrometric station
#' @param code_station the station code
#' @export
#' @examples
#' hm_station("K340081001")

hm_station=function(code_station){
  result=jsonlite::read_json(paste0("http://hubeau.eaufrance.fr/api/v1/hydrometrie/referentiel/stations",
                                    "?code_station=",code_station,
                                    "&size=1",
                                    "&format=json&pretty"))
  result=result$data[[1]]
  return(result)
}

