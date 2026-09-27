# IRA measurement model

This reference connects the [paper cited in the README](../README.md#citation) to the MATLAB implementation of closest-point terrain-referenced navigation. The full algorithm is in [main.m](../main.m); [example_synthetic.m](../example_synthetic.m) demonstrates its measurement path.

## Problem and method

An IRA measures a terrain target's slant range `rho`, along-track angle `gamma`, and cross-track angle `theta`. The proposed filter predicts these measurements separately for each particle by searching a DEM for the closest point, then weighting the particle by the measurement residual.

For a particle position `p`, velocity `v`, closest terrain point `q`, and body-frame displacement `d = [x; y; z]`, [Inverse_Transform.m](../Inverse_Transform.m) implements Eq. (10) as:

```text
rho   = sqrt(x^2 + y^2 + z^2)
gamma = pi/2 - acos(dot(q-p, v) / (norm(q-p) * norm(v)))
theta = atan2(y, sqrt(x^2 + z^2))
```

The cross-track expression is equivalent to Eq. (10) for nonzero `y` and returns zero at `y = 0`. The along-track cosine is clamped to `[-1,1]` for roundoff; see [implementation notes](implementation-notes.md#numerical-and-geometric-details) for input domains.

For the proposed three-measurement mode, Eqs. (13)–(15) give:

```text
measurement = c(particle) + noise
residual    = predicted_measurement - observed_measurement
weight      proportional to exp(-0.5 * residual' * inv(RR) * residual)
RR(i,j)     = correlation(i,j) * sigma(i) * sigma(j)
```

`main.m` constructs `RR`, normalizes particle weights, estimates the state by their weighted mean, and resamples through the cumulative weights with added position noise. The sign of the residual does not affect this quadratic likelihood; [implementation notes](implementation-notes.md#numerical-and-geometric-details) describe the density prefactor and underflow handling.

## Closest-point procedure

[Search.m](../Search.m) performs a discrete search followed by local interpolation:

1. Convert the particle's ECEF position to spherical latitude and longitude.
2. Search a rectangular grid window using index offsets derived from a 1.45 km scale and `R * angular_spacing`; longitude scaling omits the latitude cosine, giving a physically narrower east/west window away from the equator.
3. Accept coarse points whose displacement has cosine with velocity between `0` and `0.17364817766` (approximately 80–90 degrees).
4. Select the point with minimum Euclidean ECEF distance.
5. Read its 3-by-3 neighborhood and test bilinear interpolants at ninth-cell increments; keep any closer point.

The refinement excludes offsets with either component zero and does not reapply the angular gate. This local grid-and-interpolation search uses sampling and an angular gate that differ from the paper's stated field of view.

## Equation-to-source map

| Paper | Implementation | Implementation choice |
|---|---|---|
| Eq. (1), conventional radar altimeter | `TRN_RA` in [main.m](../main.m) | Terrain height at particle latitude/longitude |
| Eqs. (2)–(6), particle filter | Propagation, normalization, mean, and resampling blocks in [main.m](../main.m) | Stores nine values per particle while perturbing position |
| Eq. (9), bilinear interpolation | [get_height.m](../get_height.m), refinement in [Search.m](../Search.m) | Assumes a regular grid with valid neighboring cells |
| Eq. (10), measurement geometry | [Inverse_Transform.m](../Inverse_Transform.m) | Requires positive speed and range; zero cross-track displacement returns zero angle |
| Eqs. (11)–(12), existing IRA method | `TRN_IRA` in [main.m](../main.m), [findZ.m](../findZ.m) | Uses measured horizontal displacement and positive vertical component |
| Eqs. (13)–(15), proposed method | `TRN_IRA_C3` in [main.m](../main.m) | Searches `DB_e` for each particle; truth uses `DB` |

`TRN_IRA_C1` is a range-only closest-point variant; `TRN_IRA_C3` corresponds to the paper's proposed `TRN-IRA-P` label.

## Data and function contracts

| Value or entry point | Contract |
|---|---|
| `state` | 9-by-1 column: ECEF position (m), ECEF velocity (m/s), yaw/pitch/roll (rad) |
| `llh2ECEF(lat, lon, h)` | Scalar spherical latitude/longitude in radians, height in metres; returns scalar ECEF coordinates |
| `ECEF2llh(pos)` | Three-component ECEF position; returns spherical latitude, longitude, height |
| `ECEF2body(X,Y,Z,state)` / `body2ECEF(x,y,z,state)` | Absolute ECEF target ↔ relative body coordinates, via NED |
| `Search(state,DB)` | Returns scalar latitude/longitude in radians and height in metres |
| `get_height(lat,lon,DB)` | Bilinear height in metres inside the grid, including its final row and column |
| `Inverse_Transform(X,Y,Z,x,y,z,state)` | Matching ECEF target and body displacement; returns range (m), angles (rad) |
| `ERF(value,mean,variance)` | Scalar normal density with strictly positive variance |

Coordinate conversion uses a spherical Earth of radius 6,378,137 m. The simulation operates on known attitude, supplied velocity, and geometric IRA measurements.

Use the [DEM schema](data.md#terrain-structure), [running guide](running.md), and [implementation notes](implementation-notes.md) when adapting inputs or flight conditions.
