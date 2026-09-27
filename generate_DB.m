% Prepare virtual terrain from external SRTM data; see docs/data.md.
% See docs/running.md and docs/measurement-model.md for usage and contracts.
load('../DTED/SRTM_N35_to_39_E127_to_129.mat')
data = SRTM_N35_to_39_E127_to_129(:,1:801);

[DB.LAT_MAX_index, DB.LONG_MAX_index] = size(data);
DB.MAX_LONG     = 127 + 0.5/16;   % resolution: 3'' / 16
DB.MAX_LAT      = 35 + 4/16;
DB.MIN_LONG     = 127;
DB.MIN_LAT      = 35;

data = ceil(data/4);

for i = 1:DB.LAT_MAX_index;
    for j = 1:DB.LONG_MAX_index;
        if data(i,j) < 0
            data(i,j) = 0;
        end
    end
end
DB.data                     = data;

DB_true = DB;

save('../DTED/DB_true.mat', 'DB_true');

data2 = data(1:2:end,1:2:end); % resolution: 3'' / 8
[DB.LAT_MAX_index, DB.LONG_MAX_index] = size(data2);

DB_DEM2 = DB;
clear DB_DEM2.data;
DB_DEM2.data = data2 + 0.37 * randn(size(data2));

save('../DTED/DB_DEM2.mat', 'DB_DEM2');

data3 = data(1:4:end,1:4:end); % resolution: 3'' / 4
[DB.LAT_MAX_index, DB.LONG_MAX_index] = size(data3);

DB_DEM3 = DB;
clear DB_DEM3.data;
DB_DEM3.data = data3 + 3.40 * randn(size(data3));

save('../DTED/DB_DEM3.mat', 'DB_DEM3');
