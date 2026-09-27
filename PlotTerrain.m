% Plot the central region of a terrain database in ECEF coordinates.
% See docs/running.md and docs/measurement-model.md for usage and contracts.
function PlotTerrain(DB)
    D2R     = pi/180;
    R       = 6378137;

    lat         = ceil(DB.LAT_MAX_index*3/8):ceil(DB.LAT_MAX_index*5/8);
    long        = ceil(DB.LONG_MAX_index*3/8):ceil(DB.LONG_MAX_index*5/8);
    HEIGHT      = DB.data(lat,long);
    lat         = D2R*((DB.MAX_LAT - DB.MIN_LAT)  *(lat - 1) /(DB.LAT_MAX_index - 1) + DB.MIN_LAT);
    long        = D2R*((DB.MAX_LONG - DB.MIN_LONG)*(long - 1)/(DB.LONG_MAX_index - 1)+ DB.MIN_LONG);
    [LAT,LONG]  = meshgrid(lat,long);

    Reff        = HEIGHT + R;                                                       % llh2ECEF
    X           = Reff'.* cos(LAT).*cos(LONG);                                      % Mesh
    Y           = Reff'.* cos(LAT).*sin(LONG);
    Z           = Reff'.* sin(LAT);
    mesh(X,Y,Z);
    hold on;
    
end
