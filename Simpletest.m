% Plot a random particle cloud; this script does not test navigation.
% See docs/running.md and docs/measurement-model.md for usage and contracts.
True_P = [100, 100, 100]';
Particles = zeros(3,3000);

for i = 1:3000;
    Particles(:,i) = True_P + [5*randn;5*randn;5*randn];
end


plot3(True_P(1),True_P(2),True_P(3),'rd');hold on; grid on;
plot3(Particles(1,:),Particles(2,:),Particles(3,:),'kd'); hold off;
