% Convert ECEF target to relative north/east/down coordinates (metres).
% See docs/running.md and docs/measurement-model.md for usage and contracts.
function [x, y, z] = ECEF2NED(X, Y, Z, state)                               
    Pos     = state(1:3);
    long    = atan2(Pos(2),Pos(1));
    lati    = atan2(Pos(3),sqrt(Pos(2)^2 + Pos(1)^2));
    R       = DCM(long,3/2*pi - lati,0);                                    % long, lati adjusted Frame
                                                                            %http://kr.mathworks.com/help/aeroblks/ecefpositiontolla.html?requestedDomain=kr.mathworks.com
                                                                            %http://kr.mathworks.com/help/aeroblks/directioncosinematrixeceftoned.html?requestedDomain=www.mathworks.com&requestedDomain=kr.mathworks.com
    relative_pos    = R*[X-Pos(1); Y-Pos(2); Z-Pos(3)];
    x               = relative_pos(1);
    y               = relative_pos(2);
    z               = relative_pos(3);
end
