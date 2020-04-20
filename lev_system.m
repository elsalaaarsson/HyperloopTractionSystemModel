% Abstract class defining the desired structure of a levitation system for
% future simulation.

classdef lev_system
    properties (Abstract)
        gen general
        c_l     %Cost per levitation system unit [any currency]
        m_l     %Mass per levitation system [kg]
        n_l     %Number of levitation system units
    end
    methods (Abstract)
        lift_out = F_levitation(obj,y,v)        %Levitation force (N)
        drag_out = F_levdrag(obj,y,v)           %Drag force (N)
    end
    methods
        % Cost per pod for lev system
        function out = levcost(obj)
            C_l = obj.n_l * obj.c_l;
            out = C_l;
        end
    end
end