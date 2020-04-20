% Collection of general properties needed to define the application and
% some system properties. Define the values in a Values script.

classdef general
    properties
        tracklength %Length of hyperloop track
        m           %Mass of hyperloop pod excluding tractive systems
        a_max       %Maximum acceleration from a comfort perspective
        c_kWh       %Cost for electricity per kWh
        n_pods      %Number of pods
        podcost     %Cost per basic pod 
        n_passengers %Number of passengers per pod
        m_passenger  %Average estimated weight per pasenger
        conv_kWh_J = 3600; %Conversion rate kWh -> Joules
        a_g         %Gravitational acceleration
        w           %Width of track [m]
    end
    methods
        function out = costperJ(obj)
            c_J = obj.c_kWh / obj.conv_kWh_J;
            out = c_J;
        end
    end
end

%THRUST
%P = 1000; 
%a_max = 8;
%m = 500;
%d = 10000;
