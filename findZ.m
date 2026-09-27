% Compute the positive vertical component from range and horizontal components.
% See docs/running.md and docs/measurement-model.md for usage and contracts.
function z = findZ(rho,x,y)
    z = sqrt(rho^2 - x^2 - y^2);
end
