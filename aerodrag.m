%Reference: Jiaqing Ma Dajing Zhou, Lifeng Zhao, Yong Zhang, Zhao Yong; 
%"The approach to calculate the aerodynamic drag of maglev train in the 
%evacuated tube", Journal of Modern Transportation, 2013.

classdef aerodrag    
    properties
    P       %Pressure of the inner tube [Pa]
    P0      %Ambient pressure [Pa]
    rho0    %Ambient density [kg/m^3]
    mu      %Viscosity of air [Pa s]
    L_pod   %Length of the pod [m]
    v_c     %Speed of sound [m/s]

    S0      %Cross-sectional area of the tube [m^2]
    S       %Cross-sectional area of the pod [m^2]
    end
    methods
        %Blockage ratio
        function out = b_r(obj)
            blockageratio = obj.S / obj.S0; %Blockage ratio []
            out = blockageratio;
        end
        %Aerodynamic drag force [N]
        function out = F_airdrag(obj,v)
                if v < obj.v_c
                    F_D = obj.b_r .* obj.S0 .* obj.P ./(2 .* obj.P0) ...
                        .* obj.rho0 .* v.^2 + obj.mu .* obj.L_pod .* v ...
                        .* sqrt(obj.S0 .* obj.b_r);
                else
                    F_D = obj.b_r .* obj.S0 .* obj.P ./(2 .* obj.P0) ...
                        .* obj.rho0 .* v .* (v + obj.v_c) + obj.mu ...
                        .* obj.L_pod .* v .* sqrt(obj.S0 .* obj.b_r);
                end
            out = F_D;
        end
    end
end