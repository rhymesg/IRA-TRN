% Euler-angle direction cosine matrix (radians); see docs/implementation-notes.md.
% See docs/running.md and docs/measurement-model.md for usage and contracts.
function R = DCM(yaw,pitch,roll)
    cr = cos(roll); sr = sin(roll);
    cp = cos(pitch);sp = sin(pitch);
    cy = cos(yaw);  sy = sin(yaw);

    R = [cp*cy,         cp*sy,          -sp;
        sr*sp*cy-cr*sy, sr*sp*sy+cr*cy, sr*cp;
        cr*sp*cy+sr*sy, cr*sp*sy-sr*sy, cr*cp];    
    % R = [1 0 0;0 cr sr;0 -sr cr]*[cp 0 -sp;0 1 0;sp 0 cp]*[cy sy 0;-sy cy 0;0 0 1];
end
