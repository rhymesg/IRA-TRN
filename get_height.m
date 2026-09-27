% IRA-TRN bilinear terrain interpolation; https://doi.org/10.1002/navi.233.
% See docs/measurement-model.md and README.md#citation.
function h = get_height(lat,long,DB)
    lat     = lat*180/pi;
    long    = long*180/pi;
    I_      = (DB.LAT_MAX_index-1) *(lat-DB.MIN_LAT)    /(DB.MAX_LAT-DB.MIN_LAT);
    J_      = (DB.LONG_MAX_index-1)*(long-DB.MIN_LONG)  /(DB.MAX_LONG-DB.MIN_LONG);
    tolerance = 64*eps(max(DB.LAT_MAX_index, DB.LONG_MAX_index));
    if ~isfinite(I_) || ~isfinite(J_) || I_ < -tolerance || J_ < -tolerance || ...
            I_ > DB.LAT_MAX_index-1+tolerance || J_ > DB.LONG_MAX_index-1+tolerance
        error('get_height:OutsideGrid', 'Terrain coordinates must lie inside the DEM.');
    end
    I_      = min(max(I_, 0), DB.LAT_MAX_index-1);
    J_      = min(max(J_, 0), DB.LONG_MAX_index-1);
    I       = min(floor(I_) + 1, DB.LAT_MAX_index-1);
    J       = min(floor(J_) + 1, DB.LONG_MAX_index-1);
    
    
    h_diag  = DB.data(I+1,J+1);
    h_lati  = DB.data(I+1,J);
    h_long  = DB.data(I,J+1);
    h_self  = DB.data(I,J);
         
    a       = J_ - J + 1;
    b       = I_ - I + 1;
    h_high  = h_diag * a     + h_lati * (1-a);
    h_low   = h_long * a     + h_self * (1-a);
    h       = h_high * b     + h_low  * (1-b);                           % linear interpolation 2D
    
end
