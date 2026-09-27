% IRA range/angle geometry; https://doi.org/10.1002/navi.233.
% See docs/measurement-model.md and README.md#citation.
function [rho, gamma, theta] = Inverse_Transform(X,Y,Z,x,y,z,state)
    Pos         = state(1:3);
    Vel         = state(4:6);
    
    vector_d    = [X; Y; Z] - Pos;
    distance    = sqrt(vector_d(1)^2 + vector_d(2)^2 + vector_d(3)^2);
    norm_Vel    = sqrt(Vel(1)^2 + Vel(2)^2 + Vel(3)^2);
    beta        = acos((vector_d(1)*Vel(1) + vector_d(2)*Vel(2) + vector_d(3)*Vel(3))/distance/norm_Vel);
          
    R_i         = sqrt(x^2 + z^2);                                          % = rho*cos(theta);
    rho         = sqrt(x^2 + y^2 + z^2);
    theta       = y/abs(y)*acos(R_i/rho);
    gamma       = pi/2 - beta; 
    
end
