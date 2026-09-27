% IRA range/angle geometry; https://doi.org/10.1002/navi.233.
% See docs/measurement-model.md and README.md#citation.
function [rho, gamma, theta] = Inverse_Transform(X,Y,Z,x,y,z,state)
    Pos         = state(1:3);
    Vel         = state(4:6);
    
    vector_d    = [X; Y; Z] - Pos;
    distance    = sqrt(vector_d(1)^2 + vector_d(2)^2 + vector_d(3)^2);
    norm_Vel    = sqrt(Vel(1)^2 + Vel(2)^2 + Vel(3)^2);
    if distance == 0 || norm_Vel == 0
        error('Inverse_Transform:DegenerateGeometry', 'Range and speed must be positive.');
    end
    angle_cos   = dot(vector_d, Vel)/distance/norm_Vel;
    beta        = acos(max(-1, min(1, angle_cos)));
          
    R_i         = sqrt(x^2 + z^2);                                          % = rho*cos(theta);
    rho         = sqrt(x^2 + y^2 + z^2);
    theta       = atan2(y, R_i);
    gamma       = pi/2 - beta; 
    
end
