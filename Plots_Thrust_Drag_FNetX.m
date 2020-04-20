% Plots the thrust, drag and net force in the x-direction for the simulated
% journey.


for ii=1:numel(y)
    D(ii) = mainmodel.F_drag(y(ii), v_x(ii));
    T(ii) = mainmodel.F_limited_thrust(y(ii), v_x(ii));
end
F_x = mainmodel.F_net_x(y, v_x);

figure
plot(time,D','r')
hold on
plot(time,T,'b')
plot(time,F_x,'g')
grid on
legend('Total Drag','Thrust','Net Force in x-Direction')
title('Forces in the Direction of Travel')
ylabel('Force (N)');
xlabel('Time (s)');