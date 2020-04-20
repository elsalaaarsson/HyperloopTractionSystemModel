% Abstract class defining the desired structure of a propulsion system for
% future simulation.

classdef prop_track_system 
    properties (Abstract)
        gen general
        c_p         %Cost per pod-mounted propulsion system unit [£]
        c_t         %Cost per meter track [£/m]
        m_p         %Mass per propulsion system [kg]
        n_p         %Number of propulsion units per pod []
        
        %For calculation of power input in main model unless it has been
        %specified in the sub-class, the following are needed:
        %  I           %Current provided to the driving coils [A]
        %  R           %Electric resistance in the driving coils [ohm] 
    end
    methods (Abstract)
        thrust_out = F_thrust(obj,y,v);         %Thrust [N]
        poweroutput_out = power_out(obj,y,v);   %Power output [W]
        powerinput_out = power_in(obj,y,v);     %Power input [W]
    end
    methods
        % Pod-mounted propulsion cost per pod
        function out = propcost(obj)
            C_p = obj.c_p * obj.n_p;
            out = C_p;
        end
        % Track cost
        function out = trackcost(obj)
            C_t = obj.c_t * obj.gen.tracklength;
            out = C_t;
        end
    end
end