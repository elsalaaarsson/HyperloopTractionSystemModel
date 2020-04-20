classdef LPLIM < prop_track_system
    %Design and Characteristics Analysis of Long-Primary Single-Sided Linear
    %Induction Motor
    %Ref: Zheng2009
    properties
        gen general
        induc_lev
        c_p = 2000;     %Cost per unit prop system [£]
        c_t = 1800;      %Cost per length of track [£/m]
        n_p = 12;        %Number of propulsion units []
        
        %Copper Windings
        N_t = 252;              %Number of turns (N1 in doc)
        d_wire = 0.0012;        %Diameter of copper wire [m]
%         R_m = 1.75*10^-8;       %Resistivity [ohm/m]
        R = 1.75*10^-8;         %Resistivity [ohm/m]
        %Iron Core
        L_tooth = 0.050;        %Tooth length (movement direction) [m]
        w_tooth = 0.100;        %Tooth width [m]
        w_slot = 0.025;         %Slot width [m]
        lambda_slot = 0.075;    %Slot pitch [m]
        h_slot = 0.075;         %Slot depth [m]
        tau = 0.1125;           %Pole pitch [m]
        h_yoke = 0.025;         %Yoke height [m]
        m = 4;                  %Number of phases

        %Compound Secondary
        %Al sheet
        L_sheet = 0.450;    %Length of sheet [m]
        w_sheet = 0.110;    %Width of sheet [m]
        d_sheet = 0.0027;   %Thickness of sheet [m]
        %Back iron
        L_back = 0.450;     %Length of back iron [m]
        w_back = 0.100;     %Width of back iron [m]
        d_back = 0.008;     %Thickness of back iron [m]

        %General inputs
%         I1_dot = 7000;            %Rated input phase current [A]
        I = 7000;               %Rated input phase current [A]
        q1 = 13;                %Number of slots per pole per phase in stator iron core []
        p = 5;                  %Number of pole pairs []
        theta_p = 180;          %The coil span in electrical degrees [deg]
        rho_r = 2.7e-8;         %Resistivity of Al [ohm*m]
        mu0 = 4*pi()*10^-7;     %Permeability of vacuum [H/m]
        mu_Al = 1.256665e-6;    %Permeability of aluminium [H/m]
        f = 50;                 %Frequency [Hz]

    end
    methods
        function out = power_out(obj,y,v)
            frequency = obj.f;
            
            %Carter's coefficient, Ref:?Isobe1986
            gamma = 4/pi() * (obj.w_slot / (2 * y) * atan(obj.w_slot /(2 * y)) - log(sqrt(1 + (obj.w_slot / (2 * y))^2)));
            k_c = obj.lambda_slot / (obj.lambda_slot * gamma); %The Carter's coefficient

            g_e = k_c * y; %Effective air-gap [m]
%                 l_ce = obj.theta_p * obj.tau / 180;
%                 k_p = sind(obj.theta_p / 2); %Pitch factor
%                 lambda_s = obj.h_slot * (1+3*k_p) / (12*obj.w_slot);
%                 lambda_d = 5 * (g_e / obj.w_slot) / (5 + 4 * (y / obj.w_slot));
%                 lambda_e = 0.3 * (3 * k_p - 1);
            k_w = sin(pi()/2 * obj.gen.m) / (obj.q1 * sin(pi()/2 * obj.gen.m * obj.q1));
            G = 2 * obj.mu0 * frequency * obj.tau^2 / (pi() * (obj.rho_r / obj.d_sheet) * g_e); %Goodness factor
            w_se = obj.gen.w + y; %Equivalent stator width [m]

            v_s = 2 * frequency * obj.tau; %Synchronous speed [m/s]

            S = (v_s - v) / v_s; %Slip ratio

%                 X1 = 2*obj.mu0*pi()*obj.f* ((lambda_s * (1+3/obj.p) + lambda_d) * obj.gen.w/obj.q1 + lambda_e*l_ce) * obj.N_t^2; %Per-phase stator-slot leakage reactance 
            X_m = 24 * obj.mu0 * pi() * frequency * w_se * k_w * obj.N_t^2 * obj.tau / (pi()^2 * obj.p * g_e); %Per-phase magnetising reactance
            I2_dot = obj.I / sqrt(1/(S*G)^2 + 1); %Rotor phase current [A]
            R2_dash = X_m / G; %Equivalent per-phase rotor resistance [ohm]

%                 delta_t = sqrt(obj.rho_r / (obj.mu0 * obj.mu_Al * pi() * obj.f)); %Penetration depth [m]

            P_out = obj.m * I2_dot^2 * R2_dash * ((1-S)/S); %Mechanical power developed by secondary [W]
            
%             df = 10;
%             for ii = 1:100
%                 P_out(1) = obj.m * I2_dot^2 * R2_dash * ((1-S)/S); %Mechanical power developed by secondary [W]
%                 if P_out(ii) < P_out(ii-1)
%                     frequency = frequency + df;
%                     k_w = sin(pi()/2 * obj.gen.m) / (obj.q1 * sin(pi()/2 * obj.gen.m * obj.q1));
%                     G = 2 * obj.mu0 * frequency * obj.tau^2 / (pi() * (obj.rho_r / obj.d_sheet) * g_e); %Goodness factor
%                     w_se = obj.gen.w + y; %Equivalent stator width [m]
% 
%                     v_s = 2 * frequency * obj.tau; %Synchronous speed [m/s]
% 
%                     S = (v_s - v) / v_s; %Slip ratio
% 
%                     X_m = 24 * obj.mu0 * pi() * frequency * w_se * k_w * obj.N_t^2 * obj.tau / (pi()^2 * obj.p * g_e); %Per-phase magnetising reactance
%                     I2_dot = obj.I / sqrt(1/(S*G)^2 + 1); %Rotor phase current [A]
%                     R2_dash = X_m / G; %Equivalent per-phase rotor resistance [ohm]
%                     P_out(ii+1) = obj.m * I2_dot^2 * R2_dash * ((1-S)/S); %Mechanical power developed by secondary [W]
%                 end
%             end
            out = P_out;
        end
        function out = F_thrust(obj,y,v)
            thrust = obj.power_out(y,v) / v; %Electromagnetic thrust [N]
            out = thrust;
        end
        function out = power_in(obj)
            P_in = obj.I^2 * obj.R_m + obj.P0(); %CHECK!!
            out = P_in;
        end
    end
end