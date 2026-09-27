# Implementation notes

This reference covers numerical behavior and considerations for adapting the IRA-TRN measurement model and particle filter. Read it alongside the [algorithm reference](measurement-model.md) and [running guide](running.md).

## Provenance

The implementation corresponds to the [paper's](../README.md#citation) closest-point IRA measurement model, conventional RA/IRA comparisons, and particle-filter procedure. [CITATION.cff](../CITATION.cff) identifies the software project collectively; individual software authorship and the original source revision remain unconfirmed.

## Numerical and geometric details

| Component | Behavior and adaptation considerations |
|---|---|
| [DCM.m](../DCM.m) | Its `(3,2)` entry is corrected to `cr*sp*sy - sr*cy`, consistent with the stated rotation product. [Regression checks](../tests/integration/rotation/README.md) cover nonzero roll and general-attitude orthogonality. |
| [Inverse_Transform.m](../Inverse_Transform.m) | Uses `atan2(y,hypot(x,z))` for the cross-track angle, including zero displacement; clamps the along-track cosine for roundoff and requires positive speed and range. |
| [Search.m](../Search.m) | Reports `Search:NoCandidate` for an empty angular gate. Returns an edge winner directly and refines interior winners; the angular gate is applied during coarse selection. |
| [get_height.m](../get_height.m) | Interpolates through the final row and column using the adjacent cell. Reports `get_height:OutsideGrid` for coordinates outside the DEM. |
| [main.m](../main.m) | Longitude offsets/errors use `(R+h)` without the latitude cosine, so reported horizontal distances are the script's coordinate approximation. |
| [main.m](../main.m) | Weights below a total threshold become uniform; NaN weights are not recovered, and the code does not use log likelihoods. |
| [main.m](../main.m) | The three-dimensional likelihood uses `sqrt(2*pi*det(RR))`, matching the printed Eq. (14), rather than the normalized 3D Gaussian prefactor. The common factor cancels in normalized weights but affects the absolute underflow threshold. |
| [main.m](../main.m) | Calls such as `normrnd(0, sigma, Nparticles)` allocate square arrays while later indexing only the first `Nparticles` elements, increasing allocation and random-number consumption. |

When adapting geometry, search admissibility, noise, or evaluation conventions, compare the changed behavior against the corresponding [paper equations](measurement-model.md#equation-to-source-map).

## Auxiliary scripts

- [Search_p.m](../Search_p.m) is an auxiliary measurement-bounded search, unused by `main.m`. Its function name now matches its filename; its grid accesses still need bounds checks before standalone use.
- [Measure_propagate.m](../Measure_propagate.m) is an auxiliary noisy measurement inversion, unused by `main.m`. Check its denominators and square-root domains before using it as an inverse of `Inverse_Transform`.
- [findZ.m](../findZ.m) assumes `rho^2 >= x^2 + y^2` and selects the positive root.
- Terrain preparation and plotting scripts use the [external data and workspace variables](data.md#saved-results-and-plotting) listed in the data guide.

## Environment and example coverage

[example_synthetic.m](../example_synthetic.m) checks spherical conversion, bilinear interpolation, a known closest target, and its range/angles using deterministic inputs. Particle-filter evaluation requires the separate [simulation workflow](running.md#reproducing-published-results) and its [terrain inputs](data.md).

Coordinate tolerances are `1e-12` rad and `1e-6` m; measurement comparisons use `1e-10` rad and `1e-6` m. These tolerances measure numerical agreement in the example.
