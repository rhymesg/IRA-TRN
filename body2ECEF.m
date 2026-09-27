% Convert body-frame relative coordinates to an ECEF target (metres).
% See docs/running.md and docs/measurement-model.md for usage and contracts.
function [X,Y,Z] = body2ECEF(x,y,z,state)

    R           = DCM(state(7),state(8),state(9));
    xyz_NED     = R\[x;y;z];
    
    Pos         = state(1:3);
    long        = atan2(Pos(2),Pos(1));
    lati        = atan2(Pos(3),sqrt(Pos(2)^2 + Pos(1)^2));
    R2          = DCM(long,3/2*pi - lati,0);      
    xyz_ECEF    = (R2\xyz_NED) + state(1:3);
    
    X       	= xyz_ECEF(1);
    Y       	= xyz_ECEF(2);
    Z       	= xyz_ECEF(3);
end
