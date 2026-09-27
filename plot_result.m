% Plot saved experiment comparisons; requires external MAT files.
% See docs/running.md and docs/measurement-model.md for usage and contracts.
close all;
%%

b1 = [0.2 0.2 0.7];
r1 = [1.0 0.2 0.2];
g1 = [0.0 0.6 0.3];
v1 = [0.4 0.0 0.7];

b2 = [0.1 0.2 0.5];
r2 = [0.8 0.2 0.2];

b3 = g1;

r3 = [0.4 0.2 0.0];
r4 = [0.8 0.5 0.2];

k1 = [0.2 0.2 0.2];
k2 = [0.3 0.3 0.3];

%%

plot_terrain_heights;

%%

figure;
load('result_3d_DEM2_h25_1Hz_rough.mat');

plot(time, d_err_RMS, 'color', b2, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

hold on; 
load('result_IRA_DEM2_h25_1Hz_rough.mat');
plot(time, d_err_RMS, '--', 'color', r1,'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

load('result_RA_DEM2_h25_1Hz_rough.mat');
plot(time, d_err_RMS, '-.', 'color',  v1,'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

axis([0 100 0 70]);
xlabel('Time (s)');
ylabel('RMS Position Error (m)');
legend('TRN-IRA-P', 'TRN-IRA', 'TRN-RA');

figure;
load('result_3d_DEM2_h25_1Hz_smooth.mat');

plot(time, d_err_RMS, 'color', b2, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

hold on; 
load('result_IRA_DEM2_h25_1Hz_smooth.mat');
plot(time, d_err_RMS, '--', 'color', r1,'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

load('result_RA_DEM2_h25_1Hz_smooth.mat');
plot(time, d_err_RMS, '-.', 'color',  v1,'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

axis([0 100 0 70]);
xlabel('Time (s)');
ylabel('RMS Position Error (m)');
legend('TRN-IRA-P', 'TRN-IRA', 'TRN-RA');


figure;
load('result_3d_DEM3_h25_1Hz_rough.mat');

plot(time, d_err_RMS, 'color', b2, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

hold on; 
load('result_IRA_DEM3_h25_1Hz_rough.mat');
plot(time, d_err_RMS, '--', 'color', r1,'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

load('result_RA_DEM3_h25_1Hz_rough.mat');
plot(time, d_err_RMS, '-.', 'color',  v1,'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

axis([0 100 0 70]);
xlabel('Time (s)');
ylabel('RMS Position Error (m)');
legend('TRN-IRA-P', 'TRN-IRA', 'TRN-RA');


figure;
load('result_3d_DEM3_h25_1Hz_smooth.mat');

plot(time, d_err_RMS, 'color', b2, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

hold on; 
load('result_IRA_DEM3_h25_1Hz_smooth.mat');
plot(time, d_err_RMS, '--', 'color', r1,'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

load('result_RA_DEM3_h25_1Hz_smooth.mat');
plot(time, d_err_RMS, '-.', 'color',  v1,'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

axis([0 100 0 70]);
xlabel('Time (s)');
ylabel('RMS Position Error (m)');
legend('TRN-IRA-P', 'TRN-IRA', 'TRN-RA');

%%
figure;
load('result_3d_DEM3_h25_5Hz_rough.mat');
cnt = 10/const.dt;
plot(time, d_err_RMS, 'color', k1, 'linewidth', 2); hold on; 
plot(time(1+cnt:cnt:end), d_err_RMS(1+cnt:cnt:end), 'o', 'color', k1, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

load('result_3d_DEM3_h25_1Hz_rough.mat');
cnt = 10/const.dt;
plot(time, d_err_RMS, 'color', k1, 'linewidth', 2);
plot(time(1+cnt:cnt:end), d_err_RMS(1+cnt:cnt:end), '^', 'color', k1, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))


load('result_IRA_DEM3_h25_2Hz_rough.mat');
cnt = 10/const.dt;
plot(time, d_err_RMS, '--', 'color', k2,'linewidth', 2);
plot(time(1+cnt:cnt:end), d_err_RMS(1+cnt:cnt:end), 'o', 'color', k2, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))


load('result_IRA_DEM3_h25_1Hz_rough.mat');
cnt = 10/const.dt;
plot(time, d_err_RMS, '--', 'color',  k2,'linewidth', 2);
plot(time(1+cnt:cnt:end), d_err_RMS(1+cnt:cnt:end), '^', 'color',  k2, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

axis([0 100 0 70]);
xlabel('Time (s)');
ylabel('RMS Position Error (m)');
% legend('TRN-IRA-P f = 5 Hz', 'TRN-IRA-P f = 2 Hz', 'TRN-IRA-P f = 1 Hz', ...
% 'TRN-IRA f = 5 Hz', 'TRN-IRA f = 2 Hz', 'TRN-IRA f = 1 Hz');
%%

figure;
load('result_3d_DEM3_h25_5Hz_smooth.mat');
cnt = 10/const.dt;
plot(time, d_err_RMS, 'color', b1, 'linewidth', 2); hold on; 
plot(time(1+cnt:cnt:end), d_err_RMS(1+cnt:cnt:end), 'o', 'color', b1, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

load('result_3d_DEM3_h25_1Hz_smooth.mat');

cnt = 10/const.dt;
plot(time, d_err_RMS, 'color', r1, 'linewidth', 2);
plot(time(1+cnt:cnt:end), d_err_RMS(1+cnt:cnt:end), '^', 'color', r1, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))


load('result_IRA_DEM3_h25_5Hz_smooth.mat');
cnt = 10/const.dt;
plot(time, d_err_RMS, '--', 'color', b2,'linewidth', 2);
plot(time(1+cnt:cnt:end), d_err_RMS(1+cnt:cnt:end), 'o', 'color', b2, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))


load('result_IRA_DEM3_h25_1Hz_smooth.mat');
cnt = 10/const.dt;
plot(time, d_err_RMS, '--', 'color',  r2,'linewidth', 2);
plot(time(1+cnt:cnt:end), d_err_RMS(1+cnt:cnt:end), '^', 'color',  r2, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

axis([0 100 0 70]);
xlabel('Time (s)');
ylabel('RMS Position Error (m)');


%%

figure;
load('result_3d_DEM2_h25_1Hz_rough.mat');
cnt = 10/const.dt;
plot(time, d_err_RMS, 'color', b1, 'linewidth', 2); hold on; 
plot(time(1+cnt:cnt:end), d_err_RMS(1+cnt:cnt:end), 'o', 'color', b1, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

load('result_3d_DEM2_h45_1Hz_rough.mat');
cnt = 10/const.dt;
plot(time, d_err_RMS, 'color', r1, 'linewidth', 2);
plot(time(1+cnt:cnt:end), d_err_RMS(1+cnt:cnt:end), '^', 'color', r1, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))


load('result_IRA_DEM2_h25_1Hz_rough.mat');
cnt = 10/const.dt;
plot(time, d_err_RMS, '--', 'color', b2,'linewidth', 2);
plot(time(1+cnt:cnt:end), d_err_RMS(1+cnt:cnt:end), 'o', 'color', b2, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

% load('result.mat');
load('result_IRA_DEM2_h45_1Hz_rough.mat');
cnt = 10/const.dt;
plot(time, d_err_RMS, '--', 'color',  r2,'linewidth', 2);
plot(time(1+cnt:cnt:end), d_err_RMS(1+cnt:cnt:end), '^', 'color',  r2, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

axis([0 100 0 70]);
xlabel('Time (s)');
ylabel('RMS Position Error (m)');
% legend('TRN-IRA-P f = 5 Hz', 'TRN-IRA-P f = 2 Hz', 'TRN-IRA-P f = 1 Hz', ...
% 'TRN-IRA f = 5 Hz', 'TRN-IRA f = 2 Hz', 'TRN-IRA f = 1 Hz');
%%

figure;
load('result_3d_DEM2_h25_1Hz_smooth.mat');
cnt = 10/const.dt;
plot(time, d_err_RMS, 'color', b1, 'linewidth', 2); hold on; 
plot(time(1+cnt:cnt:end), d_err_RMS(1+cnt:cnt:end), 'o', 'color', b1, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

load('result_3d_DEM2_h45_1Hz_smooth.mat');

cnt = 10/const.dt;
plot(time, d_err_RMS, 'color', r1, 'linewidth', 2);
plot(time(1+cnt:cnt:end), d_err_RMS(1+cnt:cnt:end), '^', 'color', r1, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))


load('result_IRA_DEM2_h25_1Hz_smooth.mat');
cnt = 10/const.dt;
plot(time, d_err_RMS, '--', 'color', b2,'linewidth', 2);
plot(time(1+cnt:cnt:end), d_err_RMS(1+cnt:cnt:end), 'o', 'color', b2, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))


load('result_IRA_DEM2_h45_1Hz_smooth.mat');
cnt = 10/const.dt;
plot(time, d_err_RMS, '--', 'color',  r2,'linewidth', 2);
plot(time(1+cnt:cnt:end), d_err_RMS(1+cnt:cnt:end), '^', 'color',  r2, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

axis([0 100 0 70]);
xlabel('Time (s)');
ylabel('RMS Position Error (m)');

%%

figure;
load('result_3d_DEM2_h25_1Hz_rough.mat');
cnt = 10/const.dt;
plot(time, d_err_RMS, 'color', b1, 'linewidth', 2); hold on; 
plot(time(1+cnt:cnt:end), d_err_RMS(1+cnt:cnt:end), 'o', 'color', b1, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

load('result_3d_DEM2_h25_1Hz_rough_vhbias3.mat');
cnt = 10/const.dt;
plot(time, d_err_RMS, 'color', r1, 'linewidth', 2);
plot(time(1+cnt:cnt:end), d_err_RMS(1+cnt:cnt:end), '^', 'color', r1, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))


load('result_IRA_DEM2_h25_1Hz_rough.mat');
cnt = 10/const.dt;
plot(time, d_err_RMS, '--', 'color', b2,'linewidth', 2);
plot(time(1+cnt:cnt:end), d_err_RMS(1+cnt:cnt:end), 'o', 'color', b2, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

% load('result.mat');
load('result_IRA_DEM2_h25_1Hz_rough_vhbias3.mat');
cnt = 10/const.dt;
plot(time, d_err_RMS, '--', 'color',  r2,'linewidth', 2);
plot(time(1+cnt:cnt:end), d_err_RMS(1+cnt:cnt:end), '^', 'color',  r2, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

axis([0 100 0 70]);
xlabel('Time (s)');
ylabel('RMS Position Error (m)');
% legend('TRN-IRA-P f = 5 Hz', 'TRN-IRA-P f = 2 Hz', 'TRN-IRA-P f = 1 Hz', ...
% 'TRN-IRA f = 5 Hz', 'TRN-IRA f = 2 Hz', 'TRN-IRA f = 1 Hz');
%%

figure;
load('result_3d_DEM2_h25_1Hz_smooth.mat');
cnt = 10/const.dt;
plot(time, d_err_RMS, 'color', b1, 'linewidth', 2); hold on; 
plot(time(1+cnt:cnt:end), d_err_RMS(1+cnt:cnt:end), 'o', 'color', b1, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

load('result_3d_DEM2_h25_1Hz_smooth_vhbias3.mat');

cnt = 10/const.dt;
plot(time, d_err_RMS, 'color', r1, 'linewidth', 2);
plot(time(1+cnt:cnt:end), d_err_RMS(1+cnt:cnt:end), '^', 'color', r1, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))


load('result_IRA_DEM2_h25_1Hz_smooth.mat');
cnt = 10/const.dt;
plot(time, d_err_RMS, '--', 'color', b2,'linewidth', 2);
plot(time(1+cnt:cnt:end), d_err_RMS(1+cnt:cnt:end), 'o', 'color', b2, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))


load('result_IRA_DEM2_h25_1Hz_smooth_vhbias3.mat');
cnt = 10/const.dt;
plot(time, d_err_RMS, '--', 'color',  r2,'linewidth', 2);
plot(time(1+cnt:cnt:end), d_err_RMS(1+cnt:cnt:end), '^', 'color',  r2, 'linewidth', 2);
sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))

axis([0 100 0 70]);
xlabel('Time (s)');
ylabel('RMS Position Error (m)');

%%

figure;
plot(1,1, '-o', 'color', b1, 'linewidth', 2); hold on;
plot(1,1, '-^', 'color', r1, 'linewidth', 2);
plot(1,1, '--o', 'color', b2, 'linewidth', 2);
plot(1,1, '--^', 'color', r2, 'linewidth', 2);
legend('1', '2', '3', '4');

%%
% 
% figure;
% 
% load('result_3d_DEM1_h25_1Hz_rough.mat');
% % load('result.mat');
% plot(time, d_err_RMS, 'color', b1, 'linewidth', 2);
% sum(d_err_RMS(20:end))/81
% 
% hold on; 
% load('result_3d_DEM2_h25_1Hz_rough.mat');
% % load('result.mat');
% plot(time, d_err_RMS, '--', 'color', r1,'linewidth', 2);
% sum(d_err_RMS(20:end))/81
% 
% load('result_3d_DEM3_h25_1Hz_rough.mat');
% plot(time, d_err_RMS, ':', 'color',  g1,'linewidth', 2);
% sum(d_err_RMS(20:end))/81
% 
% axis([0 100 0 80]);
% xlabel('Time (s)');
% ylabel('RMS Position Error (m)');
% legend('\sigma_{DEM} = 0 m', '\sigma_{DEM} = 0.37 m', '\sigma_{DEM} = 3.40 m');
% 
% figure;
% 
% load('result_3d_DEM1_h25_1Hz_smooth.mat');
% plot(time, d_err_RMS, 'color', b1, 'linewidth', 2);
% hold on; 
% sum(d_err_RMS(20:end))/81
% 
% load('result_3d_DEM2_h25_1Hz_smooth.mat');
% plot(time, d_err_RMS, '--', 'color', r1,'linewidth', 2);
% sum(d_err_RMS(20:end))/81
% 
% load('result_3d_DEM3_h25_1Hz_smooth.mat');
% plot(time, d_err_RMS, ':', 'color',  g1,'linewidth', 2);
% sum(d_err_RMS(20:end))/81
% 
% axis([0 100 0 80]);
% xlabel('Time (s)');
% ylabel('RMS Position Error (m)');
% legend('\sigma_{DEM} = 0 m', '\sigma_{DEM} = 0.37 m', '\sigma_{DEM} = 3.40 m');
% 
% %%
% figure;
% 
% load('result_1d_DEM1_h25_1Hz_rough.mat');
% sum(d_err_RMS(20:end))/81
% plot(time, d_err_RMS, 'color', b1, 'linewidth', 2);
% hold on; 
% load('result_1d_DEM2_h25_1Hz_rough.mat');
% sum(d_err_RMS(20:end))/81
% plot(time, d_err_RMS, '--', 'color', r1,'linewidth', 2);
% 
% load('result_1d_DEM3_h25_1Hz_rough.mat');
% sum(d_err_RMS(20:end))/81
% plot(time, d_err_RMS, ':', 'color',  g1,'linewidth', 2);
% 
% axis([0 100 0 80]);
% xlabel('Time (s)');
% ylabel('RMS Position Error (m)');
% legend('\sigma_{DEM} = 0 m', '\sigma_{DEM} = 0.37 m', '\sigma_{DEM} = 3.40 m');
% 
% figure;
% 
% load('result_1d_DEM1_h25_1Hz_smooth.mat');
% sum(d_err_RMS(20:end))/81
% plot(time, d_err_RMS, 'color', b1, 'linewidth', 2);
% axis([0 100 0 80]);
% hold on;
% 
% load('result_1d_DEM2_h25_1Hz_smooth.mat');
% sum(d_err_RMS(20:end))/81
% plot(time, d_err_RMS, '--', 'color', r1,'linewidth', 2);
% 
% load('result_1d_DEM3_h25_1Hz_smooth.mat');
% sum(d_err_RMS(20:end))/81
% plot(time, d_err_RMS, ':', 'color',  g1,'linewidth', 2);
% 
% 
% xlabel('Time (s)');
% ylabel('RMS Position Error (m)');
% legend('\sigma_{DEM} = 0 m', '\sigma_{DEM} = 0.37 m', '\sigma_{DEM} = 3.40 m');
% 
% %%
% figure;
% 
% load('result_3d_DEM3_h25_5Hz_rough.mat');sum(d_err_RMS(100:end))/401
% % load('result.mat');
% plot(time, d_err_RMS, 'color', b1, 'linewidth', 2);hold on; 
% 
% load('result_3d_DEM3_h25_2Hz_rough.mat');sum(d_err_RMS(40:end))/161
% plot(time, d_err_RMS, '--', 'color', r1,'linewidth', 2);
% 
% load('result_3d_DEM3_h25_1Hz_rough.mat');sum(d_err_RMS(20:end))/81
% plot(time, d_err_RMS, ':', 'color',  g1,'linewidth', 2);
% 
% axis([0 100 0 80]);
% xlabel('Time (s)');
% ylabel('RMS Position Error (m)');
% legend('f = 5 Hz', 'f = 2 Hz', 'f = 1 Hz');
% 
% figure;
% 
% load('result_3d_DEM3_h25_5Hz_smooth.mat'); (sum(d_err_RMS(100:129))+sum(d_err_RMS(131:end)))/400
% plot(time, d_err_RMS, 'color', b1, 'linewidth', 2);hold on; 
% 
% load('result_3d_DEM3_h25_2Hz_smooth.mat');sum(d_err_RMS(40:end))/161
% plot(time, d_err_RMS, '--', 'color', r1,'linewidth', 2);
% 
% load('result_3d_DEM3_h25_1Hz_smooth.mat');sum(d_err_RMS(20:end))/81
% plot(time, d_err_RMS, ':', 'color',  g1,'linewidth', 2);
% 
% axis([0 100 0 80]);
% xlabel('Time (s)');
% ylabel('RMS Position Error (m)');
% legend('f = 5 Hz', 'f = 2 Hz', 'f = 1 Hz');
% 
% %%
% figure;
% 
% load('result_3d_DEM2_h25_1Hz_rough.mat'); sum(d_err_RMS(20:end))/81
% plot(time, d_err_RMS, 'color', b1, 'linewidth', 2);hold on; 
% 
% load('result_3d_DEM2_h45_1Hz_rough.mat'); sum(d_err_RMS(20:end))/81
% plot(time, d_err_RMS, '--', 'color', r1,'linewidth', 2);
% 
% load('result_3d_DEM2_h35_1Hz_rough.mat');sum(d_err_RMS(20:end))/81
% plot(time, d_err_RMS, ':', 'color',  g1,'linewidth', 2);
% 
% axis([0 100 0 80]);
% xlabel('Time (s)');
% ylabel('RMS Position Error (m)');
% legend('h = 2.5 km', 'h = 3.5 km', 'h = 4.5 km');
% 
% 
% figure;
% 
% load('result_3d_DEM2_h25_1Hz_smooth.mat'); sum(d_err_RMS(20:end))/81
% plot(time, d_err_RMS, 'color', b1, 'linewidth', 2);hold on; 
% 
% load('result_3d_DEM2_h35_1Hz_smooth.mat'); sum(d_err_RMS(20:end))/81
% plot(time, d_err_RMS, '--', 'color', r1,'linewidth', 2);
% 
% load('result_3d_DEM2_h45_1Hz_smooth.mat'); sum(d_err_RMS(20:end))/81
% plot(time, d_err_RMS, ':', 'color',  g1,'linewidth', 2);
% 
% axis([0 100 0 80]);
% xlabel('Time (s)');
% ylabel('RMS Position Error (m)');
% legend('h = 2.5 km', 'h = 3.5 km', 'h = 4.5 km');
% 
% 
% %%
% figure;
% 
% load('result_3d_DEM2_h25_1Hz_rough.mat'); sum(d_err_RMS(20:end))/81
% % load('result.mat');
% plot(time, d_err_RMS, 'color', b1, 'linewidth', 2);
% hold on; 
% load('result_3d_DEM2_h25_1Hz_rough_vbias3.mat'); sum(d_err_RMS(20:end))/81
% % load('result.mat');
% plot(time, d_err_RMS, '--', 'color', r1,'linewidth', 2);
% 
% load('result_3d_DEM2_h25_1Hz_rough_hbias3.mat'); sum(d_err_RMS(20:end))/81
% plot(time, d_err_RMS, ':', 'color',  g1,'linewidth', 2);
% 
% load('result_3d_DEM2_h25_1Hz_rough_vhbias3.mat'); sum(d_err_RMS(20:end))/81
% plot(time, d_err_RMS, '-.', 'color',  [0.4 0.7 0.4],'linewidth', 2);
% 
% axis([0 100 0 80]);
% xlabel('Time (s)');
% ylabel('RMS Position Error (m)');
% legend('b_h = 1 m, b_v = 0.389 m/s', 'b_h = 1 m, b_v = 1.167 m/s', 'b_h = 3 m, b_v = 0.389 m/s', 'b_h = 3 m, b_v = 1.167 m/s');
% 
% 
% figure;
% 
% load('result_3d_DEM2_h25_1Hz_smooth.mat'); sum(d_err_RMS(20:end))/81
% % load('result.mat');
% plot(time, d_err_RMS, 'color', b1, 'linewidth', 2);
% hold on; 
% load('result_3d_DEM2_h25_1Hz_smooth_vbias3.mat'); sum(d_err_RMS(20:end))/81
% % load('result.mat');
% plot(time, d_err_RMS, '--', 'color', r1,'linewidth', 2);
% 
% load('result_3d_DEM2_h25_1Hz_smooth_hbias3.mat'); sum(d_err_RMS(20:end))/81
% plot(time, d_err_RMS, ':', 'color',  g1,'linewidth', 2);
% 
% load('result_3d_DEM2_h25_1Hz_smooth_vhbias3.mat'); sum(d_err_RMS(20:end))/81
% plot(time, d_err_RMS, '-.', 'color',  [0.4 0.7 0.4],'linewidth', 2);
% 
% axis([0 100 0 80]);
% xlabel('Time (s)');
% ylabel('RMS Position Error (m)');
% legend('b_h = 1 m, b_v = 0.389 m/s', 'b_h = 1 m, b_v = 1.167 m/s', 'b_h = 3 m, b_v = 0.389 m/s', 'b_h = 3 m, b_v = 1.167 m/s');


%%

load('result_3d_DEM3_h25_1Hz_rough_residual2.mat');
% load('result_3d_DEM1_h25_1Hz_rough.mat');
% i = 31; % 19, 31,45, 80
i = 45; % 45
for n = 1:const.Nparticles;
    p_err(n) = norm((Particles(1:2,n,i+1) - True_state_list(1:2,i+1)));
    x_err(n) = Particles_p(1,n,i+1) - True_state_list(1,i+1);
    diff(n) = norm(xyz_true(1:2,i) - xyz_meas(1:2,n,i));
end

max(diff)
min(diff)

tol = (max(diff)+min(diff))/2;

figure;
subplot(1,3,1);

for n = 1:const.Nparticles;
    if (diff(n) > tol)
        plot(x_err(n), Measurements_list(1,n,i), 'x', 'color', b2); hold on;
    end
end
for n = 1:const.Nparticles;
    if (diff(n) < tol)
        plot(x_err(n), Measurements_list(1,n,i), 'o', 'color',  [0.6 0.0 0.3]);
    end
end
plot([-20 20], True_measurement_list(1,i)*ones(1,2), '--', 'color', r1);
xlabel('x Error (m)');
ylabel('Estimated \rho (m)');

subplot(1,3,2);

for n = 1:2:const.Nparticles;
    if (diff(n) > tol)
        plot(x_err(n), Measurements_list(2,n,i), 'x', 'color', b2);hold on;
    end
end
for n = 1:const.Nparticles;
    if (diff(n) < tol)
        plot(x_err(n), Measurements_list(2,n,i), 'o', 'color', [0.6 0.0 0.3]);
    end
end
plot([-20 20], True_measurement_list(2,i)*ones(1,2), '--', 'color', r1);
xlabel('x Error (m)');
ylabel('Estimated \gamma (rad)');


subplot(1,3,3);

for n = 1:2:const.Nparticles;
    if (diff(n) > tol)
        plot(x_err(n), Measurements_list(3,n,i), 'x', 'color', b2);hold on;
        break;
    end
end
for n = 1:const.Nparticles;
    if (diff(n) < tol)
        plot(x_err(n), Measurements_list(3,n,i), 'o', 'color', [0.6 0.0 0.3]);
        break;
    end
end
plot([-20 20], True_measurement_list(3,i)*ones(1,2), '--', 'color', r1);

for n = 1:2:const.Nparticles;
    if (diff(n) > tol)
        plot(x_err(n), Measurements_list(3,n,i), 'x', 'color', b2);
    end
end
for n = 1:const.Nparticles;
    if (diff(n) < tol)
        plot(x_err(n), Measurements_list(3,n,i), 'o', 'color', [0.6 0.0 0.3]);
    end
end
plot([-20 20], True_measurement_list(3,i)*ones(1,2), '--', 'color', r1);
xlabel('x Error (m)');
ylabel('Estimated \theta (rad)');
legend('Wrong peak', 'Right peak', 'Measurement');
