# Numerical regression checks

Known nonzero roll, general-attitude orthogonality, and determinant checks catch errors hidden by level flight.

From the repository root, with base MATLAB:

```bash
matlab -batch "addpath('tests/integration/rotation'); verify_rotation"
```

These checks require no external data or plotting and cover the numerical routines described above.
