% Legacy measurement-bounded search; not used by main.m; see docs/implementation-notes.md.
% See docs/running.md and docs/measurement-model.md for usage and contracts.
function [lat_return, long_return, h_return] = Search(state,DB,T_M,noise)
D2R = pi/180;
R2D = 180/pi;
R   = 6378137;

data            = DB.data;
Min_distance    = 10^6;
Pos             = state(1:3);
Vel             = state(4:6);
norm_Vel        = sqrt(Vel(1)^2 + Vel(2)^2 + Vel(3)^2);

d_lati  = (DB.MAX_LAT  - DB.MIN_LAT) / (DB.LAT_MAX_index-1);                % Degree per one index of lati
d_long  = (DB.MAX_LONG - DB.MIN_LONG)/ (DB.LONG_MAX_index-1);               % Degree per one index of long

% long    = atan2(Pos(2), Pos(1)) * R2D;                                      % current state longitude(Degree)
% lati    = atan2(Pos(3), sqrt(Pos(2)^2 + Pos(1)^2)) * R2D;                   % current state latitude
% 
% I       = round((lati - DB.MIN_LAT) / d_lati) +1;                           % corresponding index 
% J       = round((long - DB.MIN_LONG)/ d_long) +1;
% 
% LPI     = D2R * d_lati * R;                                                 % length per one i
% LPJ     = D2R * d_long * R;                                                 % length per one j
% del_i   = round(1.45 * 10^3 / LPI);                                         % delta index for searching area
% del_j   = round(1.45 * 10^3 / LPJ);
% 
% min_i   = ((I-del_i)<1) + ((I-del_i)>=1) * (I-del_i)
% min_j   = ((J-del_j)<1) + ((J-del_j)>=1) * (J-del_j)
% max_i   = ((I+del_i)>DB.LAT_MAX_index) * DB.LAT_MAX_index + ((I+del_i)<=DB.LAT_MAX_index) * (I+del_i)
% max_j   = ((J+del_j)>DB.LONG_MAX_index)* DB.LONG_MAX_index+ ((J+del_j)<=DB.LONG_MAX_index)* (J+del_j)

%%% min
rho = T_M(1);
gamma = T_M(2) - 3*sqrt(noise.var_IRA_gamma);
theta = T_M(3) - 3*sqrt(noise.var_IRA_theta);

del_p  = [rho*sin(gamma),rho*sin(theta)];
[X_p, Y_p, Z_p]          = body2ECEF(del_p(1),del_p(2),0,state);
[lat_p, long_p, h_p]     = ECEF2llh([X_p, Y_p, Z_p]);

min_i = floor((lat_p*R2D - DB.MIN_LAT) / (d_lati));
min_j = floor((long_p*R2D - DB.MIN_LONG)/ (d_long));

%%% max
rho = T_M(1);
gamma = T_M(2) + 3*sqrt(noise.var_IRA_gamma);
theta = T_M(3) + 3*sqrt(noise.var_IRA_theta);

del_p  = [rho*sin(gamma),rho*sin(theta)];
[X_p, Y_p, Z_p]          = body2ECEF(del_p(1),del_p(2),0,state);
[lat_p, long_p, h_p]     = ECEF2llh([X_p, Y_p, Z_p]);

max_i = ceil((lat_p*R2D - DB.MIN_LAT) / d_lati) +1;
max_j = ceil((long_p*R2D - DB.MIN_LONG)/ d_long) +1;

for i = min_i:max_i;
    lat                     = D2R * (DB.MIN_LAT  +(i-1)*d_lati);            % Radian
    cos_lat                 = cos(lat);
    sin_lat                 = sin(lat);
    for j = min_j:max_j;
        long                = D2R * (DB.MIN_LONG +(j-1)*d_long);
        cos_long            = cos(long);
        sin_long            = sin(long);
        
        R_eff               = R + DB.data(i,j);
        x_DB                = R_eff * cos_lat * cos_long;
        y_DB                = R_eff * cos_lat * sin_long;
        z_DB                = R_eff * sin_lat;
        
        vector_d_x          = x_DB - Pos(1);
        vector_d_y          = y_DB - Pos(2);
        vector_d_z          = z_DB - Pos(3);
        distance            = sqrt(vector_d_x^2 + vector_d_y^2 + vector_d_z^2);
%         angle_cos           = (vector_d_x*Vel(1) + vector_d_y*Vel(2) + vector_d_z*Vel(3))/distance/norm_Vel;
        
        if (distance < Min_distance)

            Min_distance    = distance;
            Min_lat_index   = i;
            Min_long_index	= j;
            Min_lat         = lat;                                          % Radian
            Min_long        = long;

        end
    end
end

lat_return  = Min_lat;
long_return = Min_long;
h_return    = data(Min_lat_index,Min_long_index);

H = [DB.data(Min_lat_index-1,Min_long_index-1),DB.data(Min_lat_index-1,Min_long_index),DB.data(Min_lat_index-1,Min_long_index+1);
    DB.data(Min_lat_index,Min_long_index-1),DB.data(Min_lat_index,Min_long_index),DB.data(Min_lat_index,Min_long_index+1);
    DB.data(Min_lat_index+1,Min_long_index-1),DB.data(Min_lat_index+1,Min_long_index),DB.data(Min_lat_index+1,Min_long_index+1)];
D = 9;                                                                      % DB 한칸을 쪼개는 갯수 -> 10m

for i = -D:D;
    I                       = abs(i); 
    lat                     = Min_lat   + i/D * D2R * d_lati;               % Radian
    cos_lat                 = cos(lat);
    sin_lat                 = sin(lat);
    for j = -D:D;
        if i ~= 0 && j ~= 0  
            J                   = abs(j);
            long                = Min_long  + j/D * D2R * d_long;
            cos_long            = cos(long);
            sin_long            = sin(long);
            
            h_diag  = H(2+i/I,2+j/J);
            h_lati  = H(2+i/I,2);
            h_long  = H(2,2+j/J);
            h_self  = H(2,2);
         
            h_high  = (h_diag*J + h_lati*(D-J))/D;
            h_low   = (h_long*J + h_self*(D-J))/D;                         
            h       = (h_high*I + h_low*(D-I))/D;                           % linear interpolation 2D
           
            R_eff   = R + h;
            x       = R_eff * cos_lat * cos_long;
            y       = R_eff * cos_lat * sin_long;
            z       = R_eff * sin_lat;
            distance= sqrt((x - Pos(1))^2 + (y - Pos(2))^2 + (z - Pos(3))^2);
            
            if distance < Min_distance
   
                Min_distance = distance;
                lat_return   = lat;
                long_return  = long;
                h_return     = h;
            end
        end
    end
end
end
