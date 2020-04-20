% Plots the output and input power graphs.

P_out = mainmodel.poweroutput(y, v_x);
P_in = mainmodel.powerinput(y, v_x);

figure
plot(time,P_out)
hold on
plot(time,P_in)
legend('Power Output','Power Input')
title('Power Output and Input Over Time')
xlabel('Time (s)')
ylabel('Power (W)')
grid on