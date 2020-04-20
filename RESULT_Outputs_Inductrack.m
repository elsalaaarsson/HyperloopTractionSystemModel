%OUTPUTS
%Simulates the journey as specified using the Inductrack propulsion and
%levitation models.

Initialisation_Inductrack;

runtime = max(time);
initialcost = mainmodel.manufcost();
runcost = mainmodel.journeycost(time,y,v_x);
maxpower = max(mainmodel.powerinput(y,v_x));
powerefficiency = mainmodel.efficiency_values(y,v_x);

Outputs = ['The specified journey over ', num2str(mainmodel.gen.tracklength),...
    ' metres will take ', num2str(runtime),' seconds.\n' ...
    'The initial cost is ', num2str(initialcost), ...
    ' of the chosen currency, \nand the cost per journey is ', num2str(runcost),...
    '. \nThe maximum power used during the journey is ', num2str(maxpower), 'W \n'...
    'and the minimum, median and maximum power efficiencies are \n', num2str(powerefficiency(1)),...
    ', ', num2str(powerefficiency(2)), ' and ', num2str(powerefficiency(3)), ', respectively.\n'];
fprintf(Outputs);

Plots_VelocityAndDistance;
Plots_Thrust_Drag_FNetX;
Plots_Power;
Plots_Efficiency;