%Sets up the simulation values for the LP LIM propulsion model and the
%Inductrack levitation model.

%Values
%General values
values = general;
values.tracklength = 67350;    %Bird-fly shortest distance between Edinburgh and London [m]
values.m = 5000;                %Weight of HyperloopTT pod [kg]
values.a_max = 10;              %Maximum acceleration [m/s^2]
values.c_kWh = 0.12;            %Electricity price per kWh [£]
values.n_pods = 2;              %Number of pods to be manufactured
values.podcost = 3*10^6;        %Cost per basic pod [£]
values.n_passengers = 28;       %Number of passengers per pod
values.m_passenger = 75;        %Average passenger weight [kg]
values.a_g = 9.81;              %Gravitational acceleration [m/s^2]
values.w = 0.2;                 %Track width [m]


% Values for levitation
levitation = inductrack_levitation;
levitation.gen = values;

%Values for propulsion
%lim = inductrack_drive;
propulsion = LPLIM;
propulsion.induc_lev = levitation;
propulsion.gen = values;

%Values for aerodrag
adrag = aerodrag;
adrag.P = 200;          %Tube pressure [Pa]
adrag.P0 = 101325;      %Ambient pressure [Pa]
adrag.rho0 = 1.293;     %Ambient density [kg/m^3]
adrag.mu = 1.81*10^-5;  %Viscosity of air [Pa s]
adrag.L_pod = 32;       %Length of the pod [m]
adrag.v_c = 340;        %Speed of sound [m/s]
adrag.S = 7;            %Cross-sectional area of pod [m^2]
adrag.S0 = 12.6;        %Cross-sectional area of tube [m^2]

%Values for main model
mainmodel = main_model;
mainmodel.prop = propulsion;
mainmodel.lev = levitation;
mainmodel.gen = values;
mainmodel.air = adrag;