function example_synthetic
% IRA-TRN measurement smoke check; https://doi.org/10.1002/navi.233.
% See docs/measurement-model.md and README.md#citation; no research data required.
latitude = 37.4 * pi/180;
longitude = 128.15 * pi/180;
altitude = 2500;
[X, Y, Z] = llh2ECEF(latitude, longitude, altitude);
[lat, lon, h] = ECEF2llh([X; Y; Z]);
assert(abs(lat-latitude) < 1e-12 && abs(lon-longitude) < 1e-12);
assert(abs(h-altitude) < 1e-6);

DB.MIN_LAT = 37.38;
DB.MAX_LAT = 37.42;
DB.MIN_LONG = 128.13;
DB.MAX_LONG = 128.17;
DB.LAT_MAX_index = 41;
DB.LONG_MAX_index = 41;
DB.data = zeros(41, 41);
DB.data(22, 22) = 1000;

% The elevated interior cell is closer than the surrounding zero-height terrain.
velocity = 40 * [-sin(latitude)*cos(longitude); ...
                 -sin(latitude)*sin(longitude); cos(latitude)];
state = [X; Y; Z; velocity; 0; 0; 0];
[target_lat, target_lon, target_h] = Search(state, DB);
assert(abs(target_lat - 37.401*pi/180) < 1e-12);
assert(abs(target_lon - 128.151*pi/180) < 1e-12);
assert(abs(target_h - 1000) < 1e-6);
[Xt, Yt, Zt] = llh2ECEF(target_lat, target_lon, target_h);
[xb, yb, zb] = ECEF2body(Xt, Yt, Zt, state);
[rho, gamma, theta] = Inverse_Transform(Xt, Yt, Zt, xb, yb, zb, state);

% With level northward flight, body x is along-track and body y is cross-track.
displacement = [Xt; Yt; Zt] - [X; Y; Z];
expected_range = norm(displacement);
east = [-sin(longitude); cos(longitude); 0];
expected_gamma = asin(dot(displacement, velocity/40) / expected_range);
expected_theta = asin(dot(displacement, east) / expected_range);
assert(all(isfinite([rho, gamma, theta])));
assert(abs(rho-expected_range) < 1e-6);
assert(abs(gamma-expected_gamma) < 1e-10);
assert(abs(theta-expected_theta) < 1e-10);

% An affine height field has an exact bilinear value between grid nodes.
[rows, cols] = ndgrid(0:40, 0:40);
DB.data = 100 + 2*rows + 3*cols;
interpolated = get_height(37.3905*pi/180, 128.14525*pi/180, DB);
assert(abs(interpolated - (100 + 2*10.5 + 3*15.25)) < 1e-6);
assert(abs(get_height(DB.MAX_LAT*pi/180, DB.MAX_LONG*pi/180, DB)-300) < 1e-6);

[~, ~, zero_cross_track] = Inverse_Transform(Xt, Yt, Zt, 1, 0, 2, state);
assert(zero_cross_track == 0);

edge_db = DB;
edge_db.data = zeros(41, 41);
edge_db.data(41, 41) = 1000;
[xe, ye, ze] = llh2ECEF(DB.MAX_LAT*pi/180, DB.MAX_LONG*pi/180, 2500);
edge_lat = DB.MAX_LAT*pi/180;
edge_lon = DB.MAX_LONG*pi/180;
edge_velocity = 40*([-sin(edge_lon); cos(edge_lon); 0] - ...
    0.05*[xe; ye; ze]/norm([xe; ye; ze]));
edge_state = [xe; ye; ze; edge_velocity; 0; 0; 0];
[lat_edge, lon_edge, h_edge] = Search(edge_state, edge_db);
assert(abs(lat_edge-edge_lat) < 1e-12 && abs(lon_edge-edge_lon) < 1e-12);
assert(h_edge == 1000);

state(4:6) = state(1:3)/norm(state(1:3));
try
    Search(state, DB);
    error('example_synthetic:MissingError', 'Expected an empty search gate.');
catch exception
    assert(strcmp(exception.identifier, 'Search:NoCandidate'));
end
fprintf('Synthetic measurement checks passed.\n');
end
