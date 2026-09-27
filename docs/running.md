# Running IRA-TRN

This guide covers [main.m](../main.m), its configuration and outputs. Start with the [README installation and synthetic example](../README.md#examples).

## Research simulation

1. Provide MATLAB with Statistics and Machine Learning Toolbox.
2. Place `DB_SRTM.mat` in a sibling `DTED` directory, containing both structures described in the [data guide](data.md).
3. Review the constants and `mode` near the start of `main.m`, including flight position, terrain coverage, and noise parameters.
4. Run from the repository root using the seeded [README command](../README.md#examples).

Configure settings directly in `main.m`. The script uses the current directory for relative paths and `result.mat`.

| `mode` | Source constant | Measurement update |
|---|---|---|
| `0` | `TRN_RA` | Barometric altitude minus radar-altimeter clearance, compared with terrain height |
| `1` | `TRN_IRA` | Existing IRA method using displaced terrain lookup |
| `2` | `TRN_IRA_C1` | Closest-point prediction with range-only likelihood |
| `3` | `TRN_IRA_C3` | Closest-point prediction with correlated range and angle likelihood |

## Settings and reproducibility

- `const` sets time step, duration, particle count, and Monte Carlo count; `mode` chooses the measurement model.
- `lat_init`, `long_init`, `alt`, `vel`, and `init_err` define flight and initial position error.
- `noise`, `sigma_bias_h`, and `sigma_bias_v` control sensor, process, initialization, and resampling noise.
- `r`, `g`, `t`, and the correlation coefficients construct the filter covariance `RR`; these differ from the synthetic sensor noise standard deviations.
- `rng(0, 'twister')` in the documented command controls this run's random stream; no original experiment seed is recorded.
- Preserve the source revision, MATLAB/toolbox versions, settings, seed, input-file checksums, and output filename with each experiment.

The default configuration uses a 0.2 s time step, 20 Monte Carlo trials, and `DB_SRTM.mat`. The paper's nominal comparison uses 1 Hz, 100 trials, and the virtual terrain described in the [data guide](data.md).

## Output contract

The script prints trial progress, elapsed time, and a convergence percentage when multiple trials run. It also plots errors and saves remaining workspace variables to `result.mat` after clearing the terrain structures and particle array.

| Variable | Meaning |
|---|---|
| `time` | Simulation time samples including the initial state |
| `x_err`, `y_err`, `d_err` | Per-trial latitude-derived, longitude-derived, and combined position-error histories |
| `True_state_list`, `Filtered_state_list` | Last trial's 9-by-time state histories |
| `Measurements_list` | Last trial's 3-by-particle-by-step predictions, populated in modes 2 and 3 |
| `x_err_RMS`, `y_err_RMS`, `d_err_RMS` | RMS histories over trials whose final combined error is below the script's convergence threshold |

RMS variables are only produced when there is more than one trial and at least one qualifies. Run in a fresh MATLAB process: stale workspace variables can otherwise survive the script's conditional assignments and be saved.

The RMS summary excludes nonconverged trials. `True_measurement_list` is allocated but its population is commented out, and particles are cleared before saving.

## Reproducing published results

For the published experiment settings and RMS results, refer to the paper's Table 4 and its rough/smooth DEM1 cases at 1 Hz.

To reproduce the comparison, supply the original terrain/preprocessing, configure the scenarios and trial count, and match the paper's evaluation conventions. Run each scenario separately and save the named outputs consumed by [plot_result.m](../plot_result.m).
