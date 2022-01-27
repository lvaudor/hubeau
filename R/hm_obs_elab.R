#' Get the data corresponding to elaborate observations of a hydrometric station (max 20000 observations)
#' @param code_entite the station/entity code
#' @param variables the list of variables to get as response. Defaults to c("code_site","code_station","date_obs_elab","grandeur_hydro_elab").
#' @param grandeur_hydro_elab the type of hydrometric value ("QmJ" -default- for average daily discharge or "QmM" for average monthly discharge)
hm_obs_elab_slice=function(code_entite,
                           date_debut,
                           date_fin,
                           grandeur_hydro_elab="QmJ"){
  date_debut_raw=as.Date(date_debut,"%Y-%m-%d")
  date_fin_raw=as.Date(date_fin,"%Y-%m-%d")
  date_debut=format(date_debut_raw,"%Y-%m-%dT00:00:00Z")
  date_fin=format(date_fin_raw,"%Y-%m-%dT00:00:00Z")
  res=jsonlite::read_json(paste0("https://hubeau.eaufrance.fr/api/v1/hydrometrie/obs_elab",
                                 "?code_entite=",code_entite,
                                 "&date_debut_obs_elab=",date_debut,
                                 "&date_fin_obs_elab=",date_fin,
                                 "&size=20000",
                                 "&grandeur_hydro_elab=",grandeur_hydro_elab,
                                 "&format=json&pretty"))
  result_slice=purrr::map_df(res$data,tibble::as_tibble)
  return(result_slice)
}
#' Get the data corresponding to elaborate observations of a hydrometric station
#' @param code_entite the station/entity code
#' @param variables the list of variables to get as response. Defaults to c("code_site","code_station","date_obs_elab","grandeur_hydro_elab").
#' @param grandeur_hydro_elab the type of hydrometric value ("QmJ" -default- for average daily discharge or "QmM" for average monthly discharge)
#' @export
#' @examples
#' hm_obs_elab("K340081001",date_debut="2015-12-15",date_fin="2016-01-27")
#' hm_obs_elab("Y251002001",date_debut="2015-12-15",date_fin="2016-01-27")
hm_obs_elab=function(code_entite,
                     date_debut,
                     date_fin,
                     grandeur_hydro_elab="QmJ",
                     variables=c("code_site",
                                 "code_station",
                                 "date_obs_elab",
                                 "resultat_obs_elab",
                                 "grandeur_hydro_elab")){

  date_debut=as.Date(date_debut,"%Y-%m-%d")
  date_fin=as.Date(date_fin,"%Y-%m-%d")

  diff=as.numeric(difftime(date_fin,date_debut,units="days"))

  if(diff>20000){
      seqdates_debut=seq(date_debut,date_fin,by=20001)
      seqdates_fin=seqdates_debut+20000
      date_debut=seqdates_debut
      date_fin=seqdates_fin
  }


  result=purrr::map2_df(.x=date_debut,
                        .y=date_fin,
                        ~ hubeau:::hm_obs_elab_slice(code_entite=code_entite,
                                            date_debut=.x,
                                            date_fin=.y,
                                            grandeur_hydro_elab=grandeur_hydro_elab
                                            )) %>%
    dplyr::select_at(variables) %>%
    dplyr::mutate(date_obs_elab=lubridate::ymd(date_obs_elab))
  return(result)
}
