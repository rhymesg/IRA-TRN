% Convert ECEF target to relative body coordinates (metres).
% See docs/running.md and docs/measurement-model.md for usage and contracts.
function [x, y, z] = ECEF2body(X, Y, Z, state)
    [x_NED, y_NED, z_NED] = ECEF2NED(X, Y, Z, state);                       % ECEF -> NED
    Att = state(7:9);
    R   = DCM(Att(1),Att(2),Att(3));
    
    relative_pos    = R*[x_NED; y_NED; z_NED];                              % NED -> body
    x               = relative_pos(1);
    y               = relative_pos(2);
    z               = relative_pos(3);
end
