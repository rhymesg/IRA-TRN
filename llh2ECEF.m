% Convert spherical latitude, longitude (radians), height (metres) to ECEF.
% See docs/running.md and docs/measurement-model.md for usage and contracts.
function [x,y,z] = llh2ECEF(latitude,longitude,height)
    R = 6378137; % f = 0 (flattening)
    
%     cos_lati = cos(latitude);
%     cos_long = cos(longitude);
%     sin_lati = sin(latitude);
%     sin_long = sin(longitude);
%     x = (R + height)*cos_lati*cos_long;
%     y = (R + height)*cos_lati*sin_long;
%     z = (R + height)*sin_lati;
    
    R_eff   = R + height;
    x       = R_eff * cos(latitude) * cos(longitude);
    y       = R_eff * cos(latitude) * sin(longitude);
    z       = R_eff * sin(latitude);
%     r       = [x,y,z];
end
