# Implementation scope and limitations

This reference describes the boundaries of the supplied IRA-TRN MATLAB implementation. It is research simulation code; the [paper](../README.md#citation) does not validate every input or auxiliary script.

## Provenance

The implementation corresponds to the paper's closest-point IRA measurement model, conventional RA/IRA comparisons, and particle-filter procedure. The exact original software revision, MATLAB version, and software authorship have not yet been established; no release or software DOI is declared.

## Numerical and geometric boundaries

| Component | Limitation and consequence |
|---|---|
| [DCM.m](../DCM.m) | Its `(3,2)` entry uses `cr*sp*sy - sr*sy`; the rotation product in its own comment implies `cr*sp*sy - sr*cy`. Nonzero-roll rotations may not be orthogonal; the default zero attitude does not validate general attitude use. |
| [Inverse_Transform.m](../Inverse_Transform.m) | `y/abs(y)` is undefined at zero cross-track displacement; zero speed/range also divides by zero, and `acos` arguments are not clamped for roundoff. |
| [Search.m](../Search.m) | No eligible coarse point leaves the selected indices undefined. Edge winners cause out-of-range neighborhood indexing; refinement does not preserve the coarse angular gate. |
| [get_height.m](../get_height.m) | Queries on the maximum row/column endpoint or outside the grid can index beyond the matrix. |
| [main.m](../main.m) | Longitude offsets/errors use `(R+h)` without the latitude cosine, so reported horizontal distances are the script's coordinate approximation. |
| [main.m](../main.m) | Weights below a total threshold become uniform; NaN weights are not recovered, and the code does not use log likelihoods. |
| [main.m](../main.m) | The three-dimensional likelihood uses `sqrt(2*pi*det(RR))`, matching the printed Eq. (14), rather than the normalized 3D Gaussian prefactor. The common factor cancels in normalized weights but affects the absolute underflow threshold. |
| [main.m](../main.m) | Calls such as `normrnd(0, sigma, Nparticles)` allocate square arrays while later indexing only the first `Nparticles` elements, increasing allocation and random-number consumption. |

These expressions are retained. Changes to geometry, search admissibility, noise, and evaluation conventions require separate scientific validation.

## Auxiliary scripts

- [Search_p.m](../Search_p.m) declares its function as `Search`, not `Search_p`, uses measurement-bounded search, and does not guard grid bounds. It is not called by `main.m` and is not an alternative supported entry point.
- [Measure_propagate.m](../Measure_propagate.m) is unused by `main.m`; it has unguarded denominators and square roots and should not be treated as a validated inverse of `Inverse_Transform`.
- [findZ.m](../findZ.m) assumes `rho^2 >= x^2 + y^2` and selects the positive root.
- Terrain preparation and plotting scripts require [external data and workspace state](data.md). They are not self-contained examples.

## Verification status

- [example_synthetic.m](../example_synthetic.m) supplies deterministic assertions for spherical conversion, bilinear interpolation, a known closest target, and its range/angles. It covers neither the particle-filter loop nor the unsupported inputs above.
- MATLAB and Octave were unavailable during preparation, so neither the example nor the full simulation has been executed here.
- Research terrain and experiment outputs are absent; published accuracy figures have not been reproduced.

The example's coordinate tolerances are `1e-12` rad and `1e-6` m; measurement comparisons use `1e-10` rad and `1e-6` m. These are numerical smoke-check tolerances, not navigation-accuracy claims.
