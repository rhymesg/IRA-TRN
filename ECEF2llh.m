% Convert ECEF position to spherical latitude, longitude (radians), height (metres).
% See docs/running.md and docs/measurement-model.md for usage and contracts.
function [lat, long, h] = ECEF2llh(pos)
    R       = 6378137;
    X       = pos(1); Y       = pos(2); Z       = pos(3);
    s       = sqrt(X^2+Y^2);
    
    long    = atan2(Y,X);
    lat     = atan2(Z,s);
    h       = sqrt(X^2 + Y^2 + Z^2) - R; %(s*cos(lat) + Z*sin(lat)) - R;
end
