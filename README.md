# HyperloopTractionSystemModel
System model in MATLAB for modelling traction technologies in a hyperloop design project.


--20/04/2020--
The repository includes the following files:

aerodrag.m
general.m
Values_LPLIM.m
Values_inductrack.m
RESULT_Outputs_Inductrack.m
prop_track_system.m
Plots_VelocityAndDistance.m
Plots_Thrust_Drag_FNetX.m
Plots_Power.m
Plots_Levforces.m
Plots_Efficiency.m
main_model.m
LPLIM.m
lev_system.m
Initialisation_Inductrack.m
inductrack_levitation.m
inductrack_drive.m


Running the file RESULT_Outputs_Inductrack.m runs the simulation, produces a text summarising the main outputs and plots a bunch of graphs that can help to visualise the properties of the system. It starts by running the Values_inductrack.m file to set up the values connected to the application to be simulated, and then initialises and runs the journey simulator using the Initialisation_Inductrack.m file. The files starting with "Plots" are run by the RESULT_Outputs_Inductrack.m file and include the plotting sequences.

The prop_track_system.m and lev_system.m are abstract classes defining the structure of propulsion and levitation systems, respectively. The general.m class defines some general properties that all hyperloop systems should define, regardless of the traction systems. The aerodrag.m class defines the aerodynamic shape function from the shape of the pod and the track.

The files inductrack_drive.m and LPLIM.m are both sub-classes to prop_track_system.m, and inductrack_levitation.m is a sub-class of lev_system.m.