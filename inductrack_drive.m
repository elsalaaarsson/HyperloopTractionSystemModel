classdef inductrack_drive < prop_track_system
    %Ref: Kim Nam, Long Ge, "Dynamic modeling of electromagnetic suspension 
    %system", Journal of Vibration and Control, 2013
    %
    %Propulsion system using pod-mounted Halbach arrays that travel over a
    %track with passive coils interspersed with powered "drive" coils which
    %work as a LSM-type system.
    properties
        induc_lev inductrack_levitation
        gen general
        c_p = 400;      %Cost per wavelength [£]
        c_t = 7800;     %Cost per length of track [£/m]
        m_p = 3;        %Mass per wavelength of Halbach array [kg]
        n_p = 160;      %Number of Halbach array wavelengths []
        n_coils = 3;    %Number of coils per wavelength []
        tau = 600e-6;   %Impulse length [s]
        I = 4000;       %Drive current [A]
        L = 1.8*10^-6;  %Lumped self-inductance [H]
        R = 1.5*10^-3;  %Resistance in the single circuit of track [ohm]
    end
    methods
        function out = F_thrust(obj,y,v)
            F_drive = obj.n_p .* obj.n_coils .* obj.gen.w ...
                .* exp(-1 .* obj.induc_lev.calculate_k() .* y) .* 2 ...
                .* v/obj.induc_lev.lambda .* obj.tau/pi .* obj.I ...
                .* obj.induc_lev.B0;
            out = F_drive;
        end
        function out = power_out(obj,y,v)
            out = 0;
        end
        function out = power_in(obj,y,v)
            out = 0;
        end
    end
end