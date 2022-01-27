# hubeau

This package gets data about watercourses from the **Hub'Eau hydrometric API**.

The address for the website associated to the package is (https://perso.ens-lyon.fr/lise.vaudor/Rpackages/hubeau)

For now the package **only allows to get hydrometric data** (functions `hm_xxx()` )

- data about a hydrometric station: `hm_station()`
- for one station, historic data about hydrometric values **QmJ (mean daily discharge)** and **QmM (mean monthly discharge)**: `hm_obs_elab()`
