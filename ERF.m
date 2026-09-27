% Evaluate a scalar normal density using a positive variance.
% See docs/running.md and docs/measurement-model.md for usage and contracts.
function p = ERF(x,mean,variance)
    p =  (1/sqrt(2*pi*variance)) * exp(-(x - mean)^2/(2*variance));
end
