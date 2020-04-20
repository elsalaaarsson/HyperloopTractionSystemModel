%Initialisation of the journey.
clear all
clc

Values_inductrack

% note that the v_x_min_init currently can not be found
% automatically, so try your way until you find the
% minimum speed for which the journey simulation does
% not crash

t0 = 0;             %initial time
tmax = 1000;        %initial guess for maximum time
x0 = 0;             %initial displacement in x-direction 
y0 = 0.011;         %initial displacement in y-direction
v_x_min_init = 39;  %initial velocity in x-direction
v_y0 = 0;           %initial velocity in y-direction

% Running the journey simulation
[time,qvec] = mainmodel.compute_q(t0,tmax,x0,y0,v_x_min_init,v_y0);
% Redefining the state of the system using easier-to-understand variables
y = qvec(:,1);
v_y = qvec(:,2);
x = qvec(:,3);
v_x = qvec(:,4);
