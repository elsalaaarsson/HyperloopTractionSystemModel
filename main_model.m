%This is the main model of the Fourth-Year Dissertation as produced by
% -------ELSA LARSSON------
% --------20/03/2020---------
%at the University of Strathclyde.

%This model uses the prop_track_system.m base class for information about
%the propulsion system chosen, the lev_system.m base class for informaiton
%about the levitation system chosen and the general.m class for information
%specific to the application. The aerodrag.m model also provides the
%aerodynamic drag force.

classdef main_model
    properties
        prop   %prop_track_system
        lev    %lev_system
        air    %aerodrag
        gen general
    end
    methods        
        %% JOURNEY SIMULATOR

        %Total mass [kg]
        function out = m(obj)
            mass = obj.gen.m + obj.gen.m_passenger * obj.gen.n_passengers ... 
                + obj.lev.m_l * obj.lev.n_l + obj.prop.m_p * obj.prop.n_p;
            out = mass;
        end
        %Total drag [N]
        function out = F_drag(obj,y,v_x)
            F_totaldrag = obj.air.F_airdrag(v_x) + obj.lev.F_levdrag(y,v_x);
            out = F_totaldrag;
        end
        %Net force in the x-direction [N]
        function out = F_net_x(obj,y,v_x)
            F_x = obj.prop.F_thrust(y,v_x) - obj.F_drag(y,v_x);
            
            % Apply max acceleration constraint
            F_x_amax = obj.gen.a_max * obj.m;
            F_x = min(F_x, repmat(F_x_amax,size(F_x)));
            
            out = F_x;
        end
        %Net force in the y-direction [N]
        function out = F_net_y(obj,y,v)
            F_y = obj.lev.F_levitation(y,v) - obj.gen.a_g * obj.m;
            out = F_y;
        end
        %Acceleration in x-direction from the limited net force [m.s^-2]
        function out = calculate_acceleration_x(obj,y,v_x)
            a_x = obj.F_net_x(y,v_x) / obj.m; %Acceleration in x-dir
            out = a_x;
        end
        %Definition of the dqdt-vector with imposed maximum acceleration
        %constraint
        function out = compute_dqdt(obj,y,v_y,v_x)
            a_y = obj.F_net_y(y,v_x)./obj.m; %Acceleration in y-dir                        
            a_x = obj.calculate_acceleration_x(y,v_x);
            dqdt = [v_y, a_y, v_x, a_x]';
            out = dqdt;
        end
        %Integration of the dqdt state vector: simulation of journey
        function [time,qvec] = compute_q(obj,t0,tmax,x0,y0,v_x_min_init,v_y0)
            x = x0;
            if x < obj.gen.tracklength
                tspan = [t0 tmax]; %Time span
                
                % Initial conditions
                q0 = [y0;v_y0;x0;v_x_min_init];
                    % note that the v_x_min_init currently can not be found
                    % automatically, so try your way until you find the
                    % minimum speed for which the journey simulation does
                    % not crash

                % Function computing gradients for each function in the
                % system of equations
                f = @(t,q) obj.compute_dqdt(q(1),q(2),q(4));
                
                options     = odeset('Events', @obj.distanceLimitEvent);                
                [time,qvec] = ode15s(f,tspan,q0,options);
                
                %Clarification of the qvec outputs:
                %y = qvec(1);
                %v_y = qvec(2);
                %x = qvec(3);
                %v_x = qvec(4);
            end
        end
        %Condition to stop the simulaiton when the distance travelled
        %equals the track length
        function [value, isterminal, direction] = distanceLimitEvent(obj,t,q)
                value      = (q(3) >= obj.gen.tracklength);
                isterminal = 1;   % Stop the integration
                direction  = 0;
        end
        %Recalculation of thrust provided by the propulsion system with the
        %imposed acceleration limit [N]
        function out = F_limited_thrust(obj,y,v_x)
            T_prop = obj.F_net_x(y,v_x) + obj.F_drag(y,v_x); 
            out = T_prop;
        end
        %Power output throughout the journey [W]
        function out = poweroutput(obj,y,v_x)
            % If the power output equation is not defined (= defined to
            % equal zero) in the propulsion sub-class, calculate as
            % follows:
            if obj.prop.power_out(0.01,1) == 0
                P_out = obj.F_limited_thrust(y,v_x) .* v_x;
                
            % If there is a defined power output equation, run it:
            else
                P_out = obj.prop.power_out(y,v_x);
            end
            out = P_out;
        end
        %Power input throughout the journey [W]
        function out = powerinput(obj,y,v_x)
            P_losses = 3 * obj.prop.I^2 * obj.prop.R; %Power loss for 3-phase AC system [W]
            
            % If the power input equation is not defined (= defined to
            % equal zero) in the propulsion sub-class, calculate as
            % follows:
            if obj.prop.power_in(0.01,1) == 0
                P_in = obj.F_limited_thrust(y,v_x) .* v_x + P_losses;
            
            % If there is a defined power output equation, run it:
            else
                P_in = obj.prop.power_in(y,v_x);
            end
            out = P_in;
        end

        %% ENERGY USAGE
        % Energy: power integrated over time [J]
        function out = energy(obj,t,y,v_x)
            E = sum(obj.powerinput(y,v_x) .* t, 'All');
            out = E;
        end

        %% EFFICIENCY CALCULATOR
        %Transient efficiency
        function out = efficiency(obj,y,v_x)
            Eta = abs(obj.poweroutput(y,v_x)) ...
                ./ abs(obj.powerinput(y,v_x));
            out = Eta;
        end
        %Efficiency min, median and max
        function out = efficiency_values(obj,y,v_x)
            minimum = min(obj.efficiency(y,v_x));
            median_val = median(obj.efficiency(y,v_x));
            maximum = max(obj.efficiency(y,v_x));
            out = [minimum, median_val, maximum];
        end

        %% COST CALCULATOR
        % Cost per journey = Energy used * price per energy unit
        % Manufacturing cost = sum of:
        %  - Track length * cost per length of track
        %  - Cost per pod * number of pods
        % Works for any currency, but be consistent!
        
        % Cost per journey
        function out = journeycost(obj,t,y,v_x)
            C_journey = obj.energy(t,y,v_x) * obj.gen.costperJ;
            out = C_journey;
        end

        % Total manufacturing cost
        function out = manufcost(obj)
            C_man = (obj.prop.propcost + obj.lev.levcost + obj.gen.podcost)...
                * obj.gen.n_pods + obj.prop.trackcost;
            out = C_man;
        end
    end
end