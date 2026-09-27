function verify_rotation
% Check attitude rotations independently of terrain and particle filtering.
root = fileparts(fileparts(fileparts(fileparts(mfilename('fullpath')))));
old_path = path;
cleanup = onCleanup(@() path(old_path)); %#ok<NASGU>
addpath(root);
R = DCM(0, 0, pi/6);
expected = [1, 0, 0; 0, sqrt(3)/2, 0.5; 0, -0.5, sqrt(3)/2];
assert(norm(R-expected, 'fro') < 1e-12);
R = DCM(0.4, -0.3, 0.2);
assert(norm(R*R'-eye(3), 'fro') < 1e-12);
assert(abs(det(R)-1) < 1e-12);
fprintf('Rotation checks passed.\n');
end
