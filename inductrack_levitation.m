classdef inductrack_levitation < lev_system
    %Ref: Kim Nam, Long Ge, "Dynamic modeling of electromagnetic suspension 
    %system", Journal of Vibration and Control, 2013
    %
    %EDS model of a Halbach array travelling of a track of shorted coils as
    %developed under the name "Inductrack".
    %
    properties
        gen general
        n_l = 160;      %Number of wavelengths of Halbach array []
        m_l = 0;        %Mass per wavelength [kg] (in prop)
        c_l = 0;        %Cost per wavelength [£] (in prop)
        L = 1.8*10^-6;  %Lumped self-inductance [H]
        R = 1.5*10^-3;  %Resistance of the single circuit of track [ohm]
        lambda = 0.1;   %Wavelength of the magnetic array [m]
        N_c = 13;       %Number of lifting coils per wavelength
        B0 = 1;         %Typical peak surface magnetic field strength for a Neodymium magnet[T]
    end
    methods
        function out = calculate_k(obj)
        k = 2 * pi / obj.lambda;
        out = k;
        end
        function out = calculate_omega(obj,v)
        omega = obj.calculate_k() * v; %frequency of magnetic field [rad/s]
        out = omega;
        end
        
        %Constraint for the pod not to go through the track - add to F_L-F_contact
        %K = 10000; %Stiffness of collision with track [N/m]
        %b = 10; %Damping coefficient of collison with track
        % if y<0
        %     F_contact = K*y(1) + b*y(2);
        % else
        %     F_contact = 0;
        % end
        
        function out = F_levitation(obj,y,v)
        F_L = obj.N_c .* obj.n_l .* (obj.B0.^2 .* obj.gen.w.^2)./(2.*obj.calculate_k().*obj.L) ...
            .* 1./(1+(obj.R./(obj.calculate_omega(v).*obj.L)).^2) .* exp(-2.*obj.calculate_k().*y);
        out = F_L;
        end
        function out = F_levdrag(obj,y,v)
        F_D = obj.N_c .* obj.n_l .* (obj.B0.^2.*obj.gen.w^2)/(2.*obj.calculate_k().*obj.L) ...
            .* (obj.R./(obj.calculate_omega(v).*obj.L))...
            ./(1+(obj.R./(obj.calculate_omega(v).*obj.L)).^2) ...
            .* exp(-2.*obj.calculate_k().*y);
        out = F_D;
        end
    end
end