% Plot terrain profiles; requires external DEMs and workspace colors.
% See docs/running.md and docs/measurement-model.md for usage and contracts.
load('../DTED/DB_true.mat');
load('../DTED/DB_DEM2.mat');
load('../DTED/DB_DEM3.mat');


xmin = 329;
xmax = xmin + 4*4;
y1 = 665;
y2 = ceil(y1/2);
y3 = ceil(y1/4);
x1 = xmin:xmax;
x2 = ceil(xmin/2):ceil(xmax/2);
x3 = ceil(xmin/4):ceil(xmax/4);

figure;
plot(1:length(x1), DB_true.data(x1,y1), '-o', 'color', b2, 'linewidth', 2); hold on;
plot(1:2:length(x1), DB_DEM2.data(x2,y2), '--s', 'color', r1,'linewidth', 2); 
plot(1:4:length(x1), DB_DEM3.data(x3,y3), '-.^', 'color', v1,'linewidth', 2); 
axis([1 17 210 270]);
grid on;
axh = gca;
set(axh,'XGrid','on')
set(axh,'XTick',1:length(x1));
legend('True', 'DEM1', 'DEM2');
