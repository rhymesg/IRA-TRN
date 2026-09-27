% Legacy noisy IRA measurement inversion; not used by main.m.
% See docs/running.md and docs/measurement-model.md for usage and contracts.
function [x, y, z] = Measure_propagate(rho, gamma, theta, state, noise, rho_noise_flag, gamma_noise_flag, theta_noise_flag)
    
    rho     = rho   + rho_noise_flag    * noise.sigma_rho   *randn();          % noise add
    gamma   = gamma + gamma_noise_flag  * noise.sigma_gamma *randn();
    theta   = theta + theta_noise_flag  * noise.sigma_theta *randn();
    
    X_d     = rho*cos(pi/2 - gamma);
    Y_m     = rho*sin(theta);
    R_i     = rho*cos(theta);
%%
    Vel         = state(4:6);
    Pos         = state(1:3);
    norm_Vel    = sqrt(Vel(1)^2 + Vel(2)^2 + Vel(3)^2);
    dop_cir     = X_d * (Vel/norm_Vel);
    [X1, Y1, Z1] = ECEF2body(dop_cir(1) + Pos(1), dop_cir(2) + Pos(2), dop_cir(3) + Pos(3),state); 
                                % velocity이기 때문에 Frame rotation만 고려, 
                                % shift 상쇄( + Pos)
%%
    K1      = (X1^2 + Y1^2 + Z1^2 - Y1*Y_m)/X1;
    K2      = Z1/X1;
    
    y       = Y_m;
    A       = K1*K2/(1+K2^2);
    B       = sqrt((K1*K2)^2-(1+K2^2)*(K1^2-R_i^2))/(1+K2^2);
    
    z       = A+B; % ((A-B)<0)*(A-B);
    x_      = sqrt(R_i^2-z^2);
    x       = x_; % (theta <= 0)*-1*x_ + (theta > 0)*x_;
end
