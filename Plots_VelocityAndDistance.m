% Plots the displacement and velocities in x- and y- directions. Easiest
% run through running RESULT_Outputs_Inductrack. If one figure with four
% subplots is desired, remove the comment from the first rows and comment
% out the "figure"s on the second rows. Uncomment the first "figure" 
% statement.


%figure
%subplot(2,2,1)
figure
plot(time,y,'r');
title('Vertical Displacement')
xlabel('Time (s)');
ylabel('y (m)');
grid on;

%subplot(2,2,2)
figure
plot(time,v_y,'m');
title('Vertical Velocity')
xlabel('Time (s)');
ylabel('v_y (m/s)');
grid on;

%subplot(2,2,3)
figure
plot(time,x,'b');
title('Distance Travelled')
xlabel('Time (s)');
ylabel('x (m)');
grid on;

%subplot(2,2,4)
figure
plot(time,v_x,'m');
title('Translational Velocity')
xlabel('Time (s)');
ylabel('v_x (m/s)');
grid on;