# Numerical regression checks

Known nonzero roll, general-attitude orthogonality, and determinant checks catch errors hidden by level flight.

From the repository root, with base MATLAB:

```bash
matlab -batch "addpath('tests/integration/rotation'); verify_rotation"
```

These checks require no external data or plotting. They have been syntax checked, but have not been executed in MATLAB or Octave. They do not validate the complete research experiment.
