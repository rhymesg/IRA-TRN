% Plot a configured virtual-terrain region; requires DB_true.mat.
% See docs/running.md and docs/measurement-model.md for usage and contracts.
clear all;

% resolution = 90;
% load('../DTED/DB_SRTM.mat');
% terrain = DB.data;

% % rough
% lat = 38.00;
% lon = 128.0;

% smooth
% lat = 37.45;
% lon = 128.15;



mul = 16;
resolution = 90 /mul;
load('../DTED/DB_true.mat');
terrain = DB_true.data;

lat = 35.016;
lon = 127.026;

% lat = 35.038;
% lon = 127.010;

xm = floor(  (lat - 35)/(4/16) * (4800)  )
ym = floor(  (lon - 127)/(0.5/16) * (800) )

y_max = ym + 120;
y_min = ym - 120;
x_max = xm + floor(40*100/resolution)+120;
x_min = xm - 120;

x_mesh              = x_min:12:x_max;
y_mesh              = y_min:12:y_max;
[X_mesh, Y_mesh]    = meshgrid(x_mesh, y_mesh);
z_mesh              = terrain(x_mesh, y_mesh)';
min(min(z_mesh))
max(max(z_mesh))

% z_mesh(1,1) = 100;
% z_mesh(1,2) = 900;

z_mesh(1,1) = -100;
z_mesh(1,2) = 400;

[xi, yi] = meshgrid(x_min : 1 : x_max, y_min : 1 : y_max);

zi = interp2(X_mesh, Y_mesh, z_mesh, xi, yi, 'spline');

sqrt(mean(var(zi',0)))


figure()
contourf(xi,yi,zi, 8)
colormap('gray');
hold on;
axis ([x_min x_max y_min y_max]);
axis equal;
plot(xm, ym, 'rs', 'linewidth', 2);
plot(xm+floor(4000/resolution), ym, 'ro', 'linewidth', 2);

