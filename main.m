% IRA-TRN particle-filter simulation; https://doi.org/10.1002/navi.233.
% See docs/measurement-model.md and README.md#citation.
clc
% close all;

TRN_RA = 0;
TRN_IRA = 1;
TRN_IRA_C1 = 2;
TRN_IRA_C3 = 3;

mode = 3;

const.D2R           = pi/180;
const.R2D           = 180/pi;
const.dt            = 0.2;
const.Sim_time      = 100;
const.Sim_nstep     = const.Sim_time/const.dt;
const.Nparticles    = 1000;
const.R             = 6378137;                                             % meter
time = 0:const.dt:const.Sim_time;

const.n_mont        = 20;

lat_init = 37.40 * const.D2R;
long_init = 128.15 * const.D2R;

vel = 40;
init_err = [50;50];
alt = 2.5*10^3;

noise.sigma_rho         = 4.5387;                                 % Actual measurement
noise.sigma_gamma       = 0.0013;                                 % Actual measurement
noise.sigma_theta       = 3.6053e-4;                              % Actual measurement
noise.sigma_h_RA        = 10;               % RA error
noise.sigma_h           = 5;                                        % barometer error
sigma_bias_h = 1; % altitude bias
% sigma_bias_h = 3; % altitude bias
noise.sigma_x0_propagate  = 70;                                     % initial particle (filter)
noise.sigma_x_propagate = 4 * const.dt;                             % process noise (filter)
noise.sigma_x_resample  = 2 * const.dt;                             % resampling (filter)
noise.sigma_v           = 1;                                        % velocity error
sigma_bias_v = 0.389/sqrt(2); % velocity bias
% sigma_bias_v = 1.167/sqrt(2); % velocity bias

noise.var_ALTIMETER_H = 16.0^2;
noise.var_IRA_h = 12.0^2;

r = 10.0;
g = 0.0035;
t = 8.0e-4;
cor_rg = 0.15;
cor_rt = 0.08;
cor_gt = 0.5;

noise.var_IRA_rho       = (r)^2;                       
noise.var_IRA_gamma     = (g)^2;                       % Particles distribution
noise.var_IRA_theta     = (t)^2;                       
                       
RR = [r*r, r*g*cor_rg, r*t*cor_rt;
    g*r*cor_rg, g*g, g*t*cor_gt;
    t*r*cor_rt, t*g*cor_gt, t*t]; % measurement covariance matrix

%%
% load('../DTED/DB_TanDEM-X.mat');
load('../DTED/DB_SRTM.mat');

%%

% load('../DTED/SRTM_N35_to_39_E127_to_129.mat')
% data = SRTM_N35_to_39_E127_to_129;                                         % data(lat,long)
% [DB.LAT_MAX_index, DB.LONG_MAX_index] = size(data);
% DB.MAX_LONG     = 129;                                                     % degree
% DB.MAX_LAT      = 39;
% DB.MIN_LONG     = 127;
% DB.MIN_LAT      = 35;
% for i = 1:DB.LAT_MAX_index;
%     for j = 1:DB.LONG_MAX_index;
%         if data(i,j) < 0
%             data(i,j) = 0;
%         end
%     end
% end
% DB.data                     = data;
% 
% sigma_DTED = 3.4; % SRTM
% % sigma_DTED = 0.367; % TanDEM-X
% 
% DB_e = DB;
% DB_e.data = data + sigma_DTED * randn(size(data));
% 
% save('../DTED/DB.mat', 'DB', 'DB_e');

%%

% figure(1); hold on;
% PlotTerrain(DB);
x_err = zeros(const.n_mont, const.Sim_nstep+1);
y_err = zeros(const.n_mont, const.Sim_nstep+1);
d_err = zeros(const.n_mont, const.Sim_nstep+1);

biases_h = normrnd(0, sigma_bias_h, 1, const.n_mont);
biases_v = normrnd(0, sigma_bias_v, 3, const.n_mont);
tic
for jj = 1:const.n_mont;
    %% IRA 3 measurement particles
    True_measurement_list      = zeros(3,const.Sim_nstep);

    Particles                   = zeros(9,const.Nparticles,const.Sim_nstep+1);                  % Particles(state,index,time)
    Measurements_list           = zeros(3,const.Nparticles,const.Sim_nstep);                    % Measurements(measurements,index,time);
    Weights                     = ones(1,const.Nparticles)/const.Nparticles;
    Filtered_state_list         = zeros(9,const.Sim_nstep+1);
       

    %% initialization
    lat0                        = lat_init;
    long0                       = long_init;
    h0                          = alt;
    [x0, y0, z0]                = llh2ECEF(lat0, long0, h0);                                    % initial position
    C                           = cos(long0 - pi/2);  
    S                           = sin(long0 - pi/2);
    dir_v                       = [S*z0; -C*z0; C*y0 - S*x0];                                   % cross([cos(128-90),sin(128-90),0],[x,y,z]);
    v0                          = vel * dir_v / sqrt(dir_v(1)^2 + dir_v(2)^2 + dir_v(3)^2);     % initial velocity

    cur_state                   = [x0;y0;z0;v0;0;0;0];
    True_state_list             = zeros(9,const.Sim_nstep+1);
    True_state_list(:,1)        = cur_state;

    % Particle creation
    x_samples                   = normrnd(0, noise.sigma_x0_propagate, const.Nparticles);
    y_samples                   = normrnd(0, noise.sigma_x0_propagate, const.Nparticles);
    z_samples                   = normrnd(0, 0, const.Nparticles);
    
    for n = 1:const.Nparticles;
        [x, y, z]               = llh2ECEF( (lat0 + (init_err(1) + x_samples(n))/(const.R + h0)), (long0 + (init_err(2) + y_samples(n))/(const.R + h0)), h0);
        Particles(:,n,1)        = [x;y;z;v0;0;0;0];
    end
    
    for n = 1:const.Nparticles;
        Filtered_state_list(:,1)    = Filtered_state_list(:,1) + Weights(n)*Particles(:,n,1);
    end
    
    x_err(jj,1) = init_err(1);
    y_err(jj,1) = init_err(2);
    d_err(jj,1) = norm(init_err);
    
    bias_h = biases_h(jj); % constant at each run
    bias_v = biases_v(:,jj); % constant at each run

    for i = 1 : const.Sim_nstep;
        %% True Propagation
        [cur_lat, cur_long, cur_h]  = ECEF2llh(cur_state(1:3));
        C                           = cos(cur_long - pi/2);
        S                           = sin(cur_long - pi/2);
        dir_v                       = [S*cur_state(3); -C*cur_state(3); C*cur_state(2) - S*cur_state(1)];
        v                           = vel * (dir_v / sqrt(dir_v(1)^2 + dir_v(2)^2 + dir_v(3)^2));
        cur_state(1:6)              = [cur_state(1:3) + cur_state(4:6)*const.dt; v];
        True_state_list(:,i+1)      = cur_state;

        %% True Measurement
        % % IRA measurement
        if (mode >= TRN_IRA && mode <= TRN_IRA_C3)
            [lat,long, h]               = Search(cur_state,DB);                                 % 현 상태에서 측정 되어야 할 위치(ideal)
            [X, Y, Z]                   = llh2ECEF(lat,long,h);                                 % 해당 위치 llh -> ECEF
            [xr, yr, zr]                = ECEF2body(X,Y,Z,cur_state);                           % 해당 위치 ECEF -> body-frame
            [rho, gamma, theta]         = Inverse_Transform(X,Y,Z,xr,yr,zr,cur_state);          % 해당 x,y,z를 얻기 위한 측정치

    %         xyz_true(:,i) = [X; Y; Z];

            T_M_IRA                         = [rho; gamma; theta]   + [noise.sigma_rho  *randn;
                                                                   noise.sigma_gamma*randn;
                                                                   noise.sigma_theta*randn];    % True measurements

%             True_measurement_list(:,i)  = T_M_IRA;
        end
        
        if (mode == TRN_IRA)
            del_p                       = [T_M_IRA(1)*sin(T_M_IRA(2)),T_M_IRA(1)*sin(T_M_IRA(3))];
            del_h                       = findZ(T_M_IRA(1),T_M_IRA(1)*sin(T_M_IRA(2)),T_M_IRA(1)*sin(T_M_IRA(3)));

%             del_pc                      = [rho*sin(gamma), rho*sin(theta)];             % == [xr, yr]
%             del_hc                      = findZ(rho, rho*sin(gamma), rho*sin(theta));   % == zr

            h_b                         = (cur_h + randn * noise.sigma_h + bias_h);
            T_M_IRA_2                   = h_b - del_h;
        end

        % % RA measurement
        if (mode == TRN_RA)
            h_b                         = (cur_h + randn * noise.sigma_h + bias_h);
            h_a                         = (cur_h - get_height(cur_lat,cur_long,DB) + randn * noise.sigma_h_RA);
            T_M_RA                      =  h_b - h_a;             % RA True measurements, h_b - h_a
        end

        v_err = noise.sigma_v*randn(3,1) + bias_v;
        x_samples = normrnd(0, noise.sigma_x_propagate, const.Nparticles);
        y_samples = normrnd(0, noise.sigma_x_propagate, const.Nparticles);
        z_samples = normrnd(0, noise.sigma_h, const.Nparticles);

        for n = 1:const.Nparticles;
            %% Particle Propagation
            Particles(1:3,n,i+1)    = Particles(1:3,n,i) + (Particles(4:6,n,i) + v_err) * const.dt;     % Propagation with Velocity error taken into account

            %% IRA 3 M propagation
            [lat, long, h]          = ECEF2llh(Particles(1:3,n,i+1));                                   % Propagation Error add
            lat                     = lat   + x_samples(n)/(const.R + h);
            long                    = long  + y_samples(n)/(const.R + h);
            h                       = cur_h + z_samples(n) + bias_h;
            [x, y, z]               = llh2ECEF(lat,long,h);

            Particles(1:6,n,i+1)    = [x;y;z;v];

            %% Particle Measurement
            %%------------------------------------- [3 measurements] model
            % % % Proposed 
            if (mode == TRN_IRA_C1 || mode == TRN_IRA_C3)
                [lat,long, h]               = Search(Particles(:,n,i+1),DB_e);                             % 각 particle에서 측정 되어야 할 위치(ideal)
                [X, Y, Z]                   = llh2ECEF(lat,long,h);                                      % 해당 위치 llh -> ECEF
                [xr, yr, zr]                = ECEF2body(X,Y,Z,Particles(:,n,i+1));                       % 해당 위치 ECEF -> body-frame
                [rho_p, gamma_p, theta_p]   = Inverse_Transform(X,Y,Z,xr,yr,zr,Particles(:,n,i+1));      % 해당 x,y,z를 얻기 위한 측정치
                Measurements_list(:,n,i)    = [rho_p; gamma_p; theta_p];
            end
            
            % % TRN-IRA-C1
            if (mode == TRN_IRA_C1)
                Weights(n) = ERF(rho_p,T_M_IRA(1),noise.var_IRA_rho); % rho only
            end
            
            % % TRN-IRA-C3
            if (mode == TRN_IRA_C3)
                T_E = [rho_p; gamma_p; theta_p];
                Weights(n) = exp( -0.5 * (T_E - T_M_IRA)'*inv(RR)*(T_E - T_M_IRA) ) / sqrt(2*pi*det(RR)); % multivariate - three measurements
            end
            
            % % TRN-RA
            if (mode == TRN_RA)
                [lat_p3, long_p3, h_p3]     = ECEF2llh(Particles(1:3,n,i+1));
                h_RA                        = get_height(lat_p3, long_p3,DB_e); 
                Weights(n) = ERF(h_RA,T_M_RA,noise.var_ALTIMETER_H);
            end
            
            % % TRN-IRA typical
            if (mode == TRN_IRA)
                [X_p2, Y_p2, Z_p2]          = body2ECEF(del_p(1),del_p(2),0,Particles(:,n,i+1));
                [lat_p2, long_p2, h_p2]     = ECEF2llh([X_p2, Y_p2, Z_p2]);
                h_typ                       = get_height(lat_p2, long_p2, DB_e);

                Weights(n) = ERF(h_typ,T_M_IRA_2,noise.var_IRA_h);   % IRA typical
            end

%             xyz_meas(:,n,i) = [X; Y; Z];

        end
        
        if (sum(Weights) < 1e-50)
            Weights = ones(1,const.Nparticles) * 1/const.Nparticles;
        else
            Weights = Weights/sum(Weights) ;                           % Normalize
        end
        
        filtered_state = zeros(9,1);
        for n = 1:const.Nparticles;
            filtered_state = filtered_state + Weights(n) * Particles(:,n,i+1);
        end
        Filtered_state_list(:,i+1) = filtered_state;
        
       %%% maximum a posteriori
%         [a, ind] = max(Weights);
%         Filtered_state_list(:,i+1) = Particles(:,ind,i+1);

        [lat_f, long_f, h_f]    = ECEF2llh(Filtered_state_list(1:3,i+1));
        [lat_c, long_c, h_c]    = ECEF2llh(True_state_list(1:3,i+1));
        dx                      = (lat_f - lat_c)*(const.R + cur_h);
        dy                      = (long_f - long_c)*(const.R + cur_h);

        x_err(jj,i+1) = dx;
        y_err(jj,i+1) = dy;
        d_err(jj,i+1) = sqrt(dx^2 + dy^2);

        %% Resampling
        Particles_tmp = zeros(9,const.Nparticles);
        x_samples = normrnd(0, noise.sigma_x_resample, const.Nparticles);
        y_samples = normrnd(0, noise.sigma_x_resample, const.Nparticles);
        if i ~= const.Sim_nstep;
            Weights_cdf                 = cumsum(Weights);
            for j = 1 : const.Nparticles
                index_find              = find(rand <= Weights_cdf,1);
                if isempty(index_find)
                    [a, index_find]     = max(Weights);
                end
                [lat, long ,h]          = ECEF2llh(Particles(1:3,index_find,i+1));
                [x, y, z]               = llh2ECEF((lat + x_samples(j)/(const.R+h)), (long + y_samples(j)/(const.R+h)), h);
                Particles_tmp(:,j)      = [x;y;z;Particles(4:9,index_find,i+1)];
            end
            
%             figure;
%             for j = 1 : const.Nparticles
%                 plot(Particles_tmp(1,j), Particles_tmp(2,j), 'bo');hold on;
%             end
%             plot(cur_state(1), cur_state(2), 'rs', 'linewidth', 2);
%             axis equal;
%             pause;
            
            Particles(:,:,i+1)  = Particles_tmp;
%             std(Particles(1,:,i+1))
%             std(Particles(2,:,i+1))

        end
   
    end 
    disp(['Monte-Carlo step ' int2str(jj) '/' int2str(const.n_mont) ' completed']);
end
toc
% plot3(True_state_list(1,:),True_state_list(2,:),True_state_list(3,:),'g*-','MarkerSize',2);
% plot3(Filtered_state_list(1,:),Filtered_state_list(2,:),Filtered_state_list(3,:),'r*-','Markersize',3);

%%
res_x_err = zeros(const.n_mont, const.Sim_nstep+1);
res_y_err = zeros(const.n_mont, const.Sim_nstep+1);
res_d_err = zeros(const.n_mont, const.Sim_nstep+1);
if (const.n_mont > 1)
    r = 0;
    for jj = 1:1:const.n_mont;
        if (abs(d_err(jj,end)) < 70)
            r = r + 1;
            res_x_err(r,:) = x_err(jj,:);
            res_y_err(r,:) = y_err(jj,:);
            res_d_err(r,:) = d_err(jj,:);
        end
    end
    disp(['convergence rate = ' int2str(r/const.n_mont*100) '%']);
    
    if (r > 0)
        x_err_RMS = sqrt(mean(res_x_err(1:r,:).^2,1));
        y_err_RMS = sqrt(mean(res_y_err(1:r,:).^2,1));
        d_err_RMS = sqrt(mean(res_d_err(1:r,:).^2,1));

        % RMSE plot
        figure; grid on;
        plot(time, d_err_RMS);
        sum(d_err_RMS(20/const.dt:end))/length(d_err_RMS(20/const.dt:end))
    end
end

clear SRTM_N35_to_39_E127_to_129;
clear data
clear DB
clear DB_e
clear terrain
clear Particles
save('result.mat');

%%

figure; 
subplot(2,1,1); grid on;
plot(time, x_err);
subplot(2,1,2); grid on;
plot(time, y_err);


%%
% len = size(observ_r,1);
% cnt = 10;
% 
% figure;
% plot(observ_r(1:cnt:end,1), observ_r(1:cnt:end,2), 'b.','MarkerSize',0.4);grid on;
% % axis([0 250 0 250]);
% xlabel('State error norm');ylabel('rho residual');title('RHO');
% 
% figure;
% plot(observ_g(1:cnt:end,1), observ_g(1:cnt:end,2), 'b.','MarkerSize',0.4);grid on;
% % axis([0 250 0 250]);
% xlabel('State error norm');ylabel('gamma residual');title('GAMMA');
% 
% figure;
% plot(observ_t(1:cnt:end,1), observ_t(1:cnt:end,2), 'b.','MarkerSize',0.4);grid on;
% % axis([0 250 0 250]);
% xlabel('State error norm');ylabel('theta residual');title('THETA');
% 
% figure;
% plot(observ_x(1:cnt:end,1), observ_x(1:cnt:end,2), 'b.','MarkerSize',0.4);grid on;
% % axis([0 250 0 250]);
% xlabel('State error norm');ylabel('X body residual');title('X BODY');
% 
% figure;
% plot(observ_y(1:cnt:end,1), observ_y(1:cnt:end,2), 'b.','MarkerSize',0.4);grid on;
% % axis([0 250 0 250]);
% xlabel('State error norm');ylabel('Y body residual');title('Y BODY');
% 
% figure;
% plot(observ_z(1:cnt:end,1), observ_z(1:cnt:end,2), 'b.','MarkerSize',0.4); grid on;
% % axis([0 250 0 250]);
% xlabel('State error norm');ylabel('Z body residual');title('Z BODY');
% 
% figure;
% subplot(1,3,1); histogram(observ_r(:,2)); grid on; xlabel('RHO residual');
% subplot(1,3,2); histogram(observ_g(:,2)); grid on; xlabel('GAMMA residual');
% subplot(1,3,3); histogram(observ_t(:,2)); grid on; xlabel('THETA residual');
% 
% figure;
% subplot(1,3,1); histogram(observ_x(:,2)); grid on; xlabel('X body residual');
% subplot(1,3,2); histogram(observ_y(:,2)); grid on; xlabel('Y body residual');
% subplot(1,3,3); histogram(observ_z(:,2)); grid on; xlabel('Z body residual');
