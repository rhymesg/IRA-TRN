# Terrain data and experiment inputs

This guide defines the terrain inputs used by [main.m](../main.m) and the preparation and plotting scripts. No research terrain MAT files or saved simulation results are included.

## Terrain structure

`main.m` loads `../DTED/DB_SRTM.mat` relative to the current working directory. Run from the repository root and provide both `DB` (truth terrain) and `DB_e` (filter terrain) in that file.

| Field | Meaning |
|---|---|
| `data` | Finite real matrix of terrain heights in metres; rows increase with latitude, columns with longitude |
| `LAT_MAX_index`, `LONG_MAX_index` | Row and column counts, matching `size(data)` |
| `MIN_LAT`, `MAX_LAT` | Increasing latitude bounds in degrees |
| `MIN_LONG`, `MAX_LONG` | Increasing longitude bounds in degrees |

Grid endpoints are inclusive, with uniform spacing `(MAX - MIN)/(count - 1)`. Each grid needs at least three rows and columns for search refinement, and the search winner must have neighbors on every side.

- Use spherical latitude and longitude consistent with [coordinate conversion](measurement-model.md#data-and-function-contracts).
- Keep the flight path, particle spread, and measurement footprint inside both grids with an interior margin.
- `get_height` requires coordinates below the maximum row and column endpoints; it reads the next cell without clipping.
- `Search` clips its coarse window, but fails when no point passes its gate or the selected point lies on an edge.
- There is no input validation, void filling, geoid correction, or missing-value handling in these functions.

## Original terrain preparation

The paper's Simulation Set-up describes virtual terrain made by compressing SRTM heights and horizontal distances. [generate_DB.m](../generate_DB.m) expects `../DTED/SRTM_N35_to_39_E127_to_129.mat` containing `SRTM_N35_to_39_E127_to_129`.

The script selects the first 801 columns, divides heights by four with `ceil`, clamps negative heights to zero, changes geographic bounds, downsamples, and adds Gaussian height errors. It writes or overwrites these files in the existing `../DTED/` directory:

| File / variable | Processing | Paper naming |
|---|---|---|
| `DB_true.mat` / `DB_true` | Compressed terrain | True terrain |
| `DB_DEM2.mat` / `DB_DEM2` | Every second row/column, 0.37 m noise standard deviation | DEM1 |
| `DB_DEM3.mat` / `DB_DEM3` | Every fourth row/column, 3.40 m noise standard deviation | DEM2 |

These outputs use different variable names and geographic bounds from `main.m`'s default input. Configure matching truth/filter grids and flight locations before using them in an experiment.

The source MAT file is absent, and its acquisition version, void handling, vertical datum, and preprocessing record are unspecified. Record source identifiers, processing steps, and redistribution terms when supplying a dataset.

## Saved results and plotting

- `main.m` saves `result.mat`; repeated runs overwrite it.
- [plot_result.m](../plot_result.m) loads many separately named `result_*.mat` files for mode, DEM, altitude, frequency, terrain, and bias comparisons. A single `result.mat` does not satisfy this input set.
- [plot_terrain.m](../plot_terrain.m) and [plot_terrain_heights.m](../plot_terrain_heights.m) require the generated terrain files and fixed grid indices.
- `plot_terrain_heights.m` also expects color variables supplied by `plot_result.m`.
- [Simpletest.m](../Simpletest.m) is a standalone visualization of a random particle cloud.

## Synthetic input

[example_synthetic.m](../example_synthetic.m) creates a small artificial grid with an isolated peak entirely in memory. The peak defines a known closest target for geometry and interpolation checks.
