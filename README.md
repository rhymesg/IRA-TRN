# IRA-TRN

## Overview

MATLAB research code for terrain-referenced navigation (TRN) using an interferometric radar altimeter (IRA), a digital elevation model (DEM), and a particle filter.

The implementation follows the closest-point measurement method in **“Terrain-Referenced Navigation using an Interferometric Radar Altimeter”** (2018): each particle predicts range, along-track angle, and cross-track angle to the closest terrain point. See the [paper citation](#citation) and [canonical repository](https://github.com/rhymesg/IRA-TRN).

Use it as a technical reference for terrain-aided navigation, radar measurement geometry, and sequential importance resampling. Start with the [measurement model](docs/measurement-model.md), [algorithm-to-source map](#algorithms-and-source), or [synthetic example](example_synthetic.m).

## Method

For each position particle, find the closest terrain point in a DEM and predict the radar range and along-/cross-track angles. Compare those predictions with the measurements to update particle weights and estimate position.

### Algorithms and source

The [measurement-model reference](docs/measurement-model.md) maps the paper to source and documents units, assumptions, and search behavior. [Implementation notes](docs/implementation-notes.md) cover numerical details and considerations for adapting the code.

| Capability | Source | Paper connection |
|---|---|---|
| Particle propagation, weighting, resampling | [main.m](main.m), [ERF.m](ERF.m) | Eqs. (2)–(6) |
| Closest terrain point and interpolation | [Search.m](Search.m), [get_height.m](get_height.m) | Measurement generation; Eq. (9) |
| Range and angle prediction | [Inverse_Transform.m](Inverse_Transform.m), [ECEF2body.m](ECEF2body.m) | Eq. (10) |
| Conventional and proposed measurement models | [main.m](main.m) | Eqs. (1), (11)–(15) |
| Virtual DEM preparation | [generate_DB.m](generate_DB.m), [data guide](docs/data.md) | Simulation Set-up |

## Examples

Run commands from the repository root with MATLAB on your shell path (`-batch` requires R2019a or later). The synthetic example uses base MATLAB; the full simulation also requires Statistics and Machine Learning Toolbox and external terrain data.

Run the deterministic, data-free measurement example from the repository root:

```bash
matlab -batch "example_synthetic"
```

It checks coordinate conversion, terrain interpolation, closest-point selection, and range/angle geometry on an artificial terrain with an isolated peak. Expected completion is `Synthetic measurement checks passed.`; it opens no figures and writes no files.

The full simulation requires external terrain data, which are not included. Provide `../DTED/DB_SRTM.mat` with the [documented terrain structures](docs/data.md), then set `mode` and the experiment parameters in [main.m](main.m):

```bash
matlab -batch "rng(0, 'twister'); main"
```

The script runs seeded Monte Carlo trials, creates plots, and overwrites `result.mat`. See the [running guide](docs/running.md) for modes, output variables, and published experiment settings.

## Implementation scope

The synthetic example covers the radar measurement geometry; the full particle-filter simulation requires external DEM data. [Implementation notes](docs/implementation-notes.md) describe numerical assumptions and coverage.

### Checks

The [rotation regression checks](tests/integration/rotation/README.md) cover nonzero-attitude coordinate transforms. Use `example_synthetic` for the measurement path.

## Citation

Please cite the paper when using this method:

> Youngjoo Kim, Junwoo Park, and Hyochoong Bang. “Terrain-Referenced Navigation using an Interferometric Radar Altimeter.” *NAVIGATION: Journal of the Institute of Navigation*, 65(2), 157–167, 2018. [doi:10.1002/navi.233](https://doi.org/10.1002/navi.233). [Publisher record](https://www.ion.org/publications/abstract.cfm?articleID=102746).

[CITATION.cff](CITATION.cff) provides the preferred paper citation and software project metadata.

## License

No software license has been specified; reuse permissions require confirmation from the rights holder.
