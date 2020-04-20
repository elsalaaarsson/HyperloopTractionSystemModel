% Plots the magnetic drag and lift as produced by the levitation system.

D = mainmodel.lev.F_levdrag(y, v_x);
L = mainmodel.lev.F_levitation(y, v_x);

figure
plot(time,D,'r')
hold on
plot(time,L,'b')
grid on
legend('Magnetic Drag','Lift Force')
title('Levitation Forces vs Velocity for the Inductrack Model')
ylabel('Force (N)');
xlabel('Time (s)');