within AixLib.Utilities.Sources.InternalGains.Examples.InternalGains;
model Lights "Simulation to check the light models"
  extends Modelica.Icons.Example;
  AixLib.Utilities.Sources.InternalGains.Lights.LightsAreaSpecific lights
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Utilities.Sources.InternalGains.Lights.Lights_Avar lights_sensibleHeat_Avar
    annotation (Placement(transformation(extent={{-10,-62},{10,-42}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(table=[0,0; 28740,0;
        28800,1; 64800,1; 64860,0; 86400,0])
    annotation (Placement(transformation(extent={{-76,-10},{-56,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemp(T=293.15)
    annotation (Placement(transformation(extent={{78,-8},{58,12}})));
equation
  connect(combiTimeTable.y[1],lights.schedule)  annotation (Line(
      points={{-55,0},{-10,0}},
      color={0,0,127}));
  connect(combiTimeTable.y[1],lights_sensibleHeat_Avar.schedule)  annotation (
     Line(
      points={{-55,0},{-32,0},{-32,-52},{-10,-52}},
      color={0,0,127}));
  connect(lights.convHeat, fixedTemp.port) annotation (Line(
      points={{9,6},{34,6},{34,2},{58,2}},
      color={191,0,0}));
  connect(lights_sensibleHeat_Avar.convHeat, fixedTemp.port) annotation (
      Line(
      points={{9,-46},{34,-46},{34,2},{58,2}},
      color={191,0,0}));
  connect(lights_sensibleHeat_Avar.radHeat, fixedTemp.port) annotation (
      Line(
      points={{9,-58},{46,-58},{46,2},{58,2}},
      color={95,95,95},
      pattern=LinePattern.Solid));
  connect(lights.radHeat, fixedTemp.port) annotation (Line(
      points={{9,-6},{46,-6},{46,2},{58,2}},
      color={95,95,95},
      pattern=LinePattern.Solid));
  annotation (
    experiment(
      StopTime=86400,
      Interval=60,
      __Dymola_Algorithm="Lsodar"),
Documentation(info="<html>
<h4><font color=\"#008000\">Overview</font></h4>
<p>This simulation is to check the functionality of the light models described by the internal gains. </p>
<h4><font color=\"#008000\">Concept</font></h4>
<p>The simulation consists of the following models:</p>
<table summary=\"Models\" cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td bgcolor=\"#dcdcdc\"><p>index</p></td>
<td bgcolor=\"#dcdcdc\"><p>model</p></td>
</tr>
<tr>
<td><p>1</p></td>
<td><p><a href=\"AixLib.Building.Components.Sources.InternalGains.Lights.Lights_simple\">Lights_simple</a></p></td>
</tr>
<tr>
<td><p>2</p></td>
<td><p><a href=\"AixLib.Building.Components.Sources.InternalGains.Lights.Lights_relative\">Lights_relative</a></p></td>
</tr>
<tr>
<td><p>3</p></td>
<td><p><a href=\"AixLib.Building.Components.Sources.InternalGains.Lights.Lights_Avar\">Lights_Avar</a></p></td>
</tr>
</table>
<p>Heat flow values can be displayed via the provided output. </p>
</html>",
        revisions="<html>
<ul>
<li><i>May 31, 2013&nbsp;</i> by Ole Odendahl:<br/>Implemented, added documentation and formatted appropriately</li>
</ul>
</html>"));
end Lights;
