% Plots the continuously changing efficiency throughout the journey.

Eff = mainmodel.efficiency(y,v_x);

figure
plot(time,Eff)
xlabel('Time (s)')
ylabel('Efficiency')
title('Power Efficiency')
grid on