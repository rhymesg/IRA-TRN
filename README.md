# IRA-TRN

## Overview

MATLAB research code for terrain-referenced navigation (TRN) using an interferometric radar altimeter (IRA), a digital elevation model (DEM), and a particle filter.

The implementation follows the closest-point measurement method in **“Terrain-Referenced Navigation using an Interferometric Radar Altimeter”** (2018): each particle predicts range, along-track angle, and cross-track angle to the closest terrain point. Use it to study terrain-aided navigation, synthetic radar-altimeter measurements, and sequential importance resampling; see the [canonical repository](https://github.com/rhymesg/IRA-TRN) and [paper citation](#citation).

The full simulation requires terrain data that are not distributed here. The [synthetic example](example_synthetic.m) exercises the measurement path without external data; it does not reproduce the paper's navigation accuracy. See [implementation limitations and provenance](docs/limitations.md) before adapting the code.

## Installation

Clone the repository:

```bash
git clone https://github.com/rhymesg/IRA-TRN.git
```

Enter the repository root:

```bash
cd IRA-TRN
```

Use MATLAB, with its `matlab` executable on your shell path. The full simulation also uses Statistics and Machine Learning Toolbox for [`normrnd`](https://www.mathworks.com/help/stats/normrnd.html); the synthetic example uses base MATLAB only.

The original MATLAB release is unspecified. The commands below use [`-batch`](https://www.mathworks.com/help/matlab/ref/matlabmacos.html); execution and Octave compatibility have not been verified in this repository.

## Usage

Run the deterministic, data-free measurement example from the repository root:

```bash
matlab -batch "example_synthetic"
```

It checks coordinate conversion, terrain interpolation, closest-point selection, and range/angle geometry on an artificial terrain with an isolated peak. Expected completion is `Synthetic measurement checks passed.`; it opens no figures and writes no files.

For the research simulation, first provide `../DTED/DB_SRTM.mat` with the [documented terrain structures](docs/data.md), then review `mode` and the settings in [main.m](main.m):

```bash
matlab -batch "rng(0, 'twister'); main"
```

This seed is a repeatable starting point, not the paper's original seed. The script runs Monte Carlo trials, creates plots, and overwrites `result.mat`; see the [running guide](docs/running.md) for modes, output variables, and experiment requirements.

## Development

Run the synthetic command after changes to the measurement path. It is a focused smoke check, not a complete test suite or a navigation benchmark; see [verification status](docs/limitations.md#verification-status).

Report issues or propose fixes through the [issue tracker](https://github.com/rhymesg/IRA-TRN/issues), including the revision, MATLAB/toolbox versions, command, mode, random seed, terrain dimensions and bounds, and error or unexpected output. Suggested GitHub description and topics are in [repository metadata](docs/repository-metadata.md).

## Algorithms and source

The [measurement-model reference](docs/measurement-model.md) maps the paper to source and documents units, assumptions, and search behavior.

| Capability | Source | Paper connection |
|---|---|---|
| Particle propagation, weighting, resampling | [main.m](main.m), [ERF.m](ERF.m) | Eqs. (2)–(6) |
| Closest terrain point and interpolation | [Search.m](Search.m), [get_height.m](get_height.m) | Measurement generation; Eq. (9) |
| Range and angle prediction | [Inverse_Transform.m](Inverse_Transform.m), [ECEF2body.m](ECEF2body.m) | Eq. (10) |
| Conventional and proposed measurement models | [main.m](main.m) | Eqs. (1), (11)–(15) |
| Virtual DEM preparation | [generate_DB.m](generate_DB.m), [data guide](docs/data.md) | Simulation Set-up |

## Citation

Please cite the paper when using this method:

> Youngjoo Kim, Junwoo Park, and Hyochoong Bang. “Terrain-Referenced Navigation using an Interferometric Radar Altimeter.” *NAVIGATION: Journal of the Institute of Navigation*, 65(2), 157–167, 2018. [doi:10.1002/navi.233](https://doi.org/10.1002/navi.233). [Publisher record](https://www.ion.org/publications/abstract.cfm?articleID=102746).

[CITATION.cff](CITATION.cff) records the preferred paper citation and identifies the software project collectively pending individual authorship confirmation. Publication attribution does not itself grant permission to reuse the software or external terrain data.

## License

No software license has been specified. Obtain permission from the rights holder before reuse or redistribution; the paper's publication terms and external datasets are separate.
