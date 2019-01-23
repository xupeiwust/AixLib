within AixLib.Systems.ModularAHU;
model RegisterModule "AHU register module for heaters and coolers"
    extends AixLib.Fluid.Interfaces.PartialFourPortParallel;

  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal(min=0)
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal(min=0)
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
    parameter Modelica.SIunits.Temperature T_start=303.15
    "Initialization temperature" annotation(Dialog(tab="Advanced"));
  parameter Modelica.SIunits.Time tau=15
    "Time Constant for PT1 behavior of temperature sensors" annotation(Dialog(group="Heat exchanger"));
  parameter  Modelica.SIunits.Temperature T_amb "Ambient temperature";
  replaceable HydraulicModules.Admix
    partialHydraulicModule(final T_amb=T_amb, redeclare package Medium =
        Medium2,
    final m_flow_nominal=m2_flow_nominal,
    T_start=T_start,
    final allowFlowReversal=allowFlowReversal2)
                           constrainedby
    HydraulicModules.BaseClasses.PartialHydraulicModule
    annotation (Dialog(enable=true, group="Hydraulics"), Placement(transformation(extent={{-38,-38},{38,38}},
        rotation=90,
        origin={0,-40})), __Dymola_choicesAllMatching=true);
  Fluid.HeatExchangers.DynamicHX dynamicHX(final m1_flow_nominal=
        m1_flow_nominal, final m2_flow_nominal=m2_flow_nominal,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    T1_start=T_start,
    T2_start=T_start)
    annotation (Dialog(enable=true, group="Heat exchanger"), Placement(transformation(extent={{-20,32},{20,66}})));
  BaseClasses.registerBus registerBus
    annotation (Placement(transformation(extent={{-130,-10},{-110,10}})));

protected
  Fluid.Sensors.TemperatureTwoPort senT_airIn(
    T_start=T_start,
    transferHeat=true,
    final TAmb=T_amb,
    final m_flow_nominal=m1_flow_nominal,
    redeclare package Medium = Medium1,
    final allowFlowReversal=allowFlowReversal1)
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Modelica.Blocks.Continuous.FirstOrder PT1_airIn(
    initType=Modelica.Blocks.Types.Init.SteadyState,
    y_start=T_start,
    final T=tau) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-70,90})));
  Fluid.Sensors.TemperatureTwoPort senT_airOut(
    T_start=T_start,
    transferHeat=true,
    final TAmb=T_amb,
    final m_flow_nominal=m1_flow_nominal,
    redeclare package Medium = Medium1,
    final allowFlowReversal=allowFlowReversal1)
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Modelica.Blocks.Continuous.FirstOrder PT1_airOut(
    initType=Modelica.Blocks.Types.Init.SteadyState,
    y_start=T_start,
    final T=tau) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={70,90})));

  Fluid.Sensors.VolumeFlowRate VFSen_out(
    T_start=T_start,
    final m_flow_nominal=m1_flow_nominal,
    redeclare package Medium = Medium1,
    final allowFlowReversal=allowFlowReversal1)
    "Inflow into admix module in forward line" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-38,60})));
equation
  connect(partialHydraulicModule.port_b1, dynamicHX.port_a2) annotation (Line(
        points={{-22.8,-2},{0,-2},{0,28},{20,28},{20,38.8}}, color={0,127,255}));
  connect(partialHydraulicModule.port_a2, dynamicHX.port_b2) annotation (Line(
        points={{22.8,-2},{18,-2},{18,12},{-20,12},{-20,38.8}},
                                                              color={0,127,255}));
  connect(senT_airIn.T, PT1_airIn.u)
    annotation (Line(points={{-70,71},{-70,78}}, color={0,0,127}));
  connect(senT_airOut.T, PT1_airOut.u)
    annotation (Line(points={{70,71},{70,78}}, color={0,0,127}));
  connect(dynamicHX.port_b1, senT_airOut.port_a) annotation (Line(points={{20,59.2},
          {42,59.2},{42,60},{60,60}}, color={0,127,255}));
  connect(partialHydraulicModule.hydraulicBus, registerBus.hydraulicBus)
    annotation (Line(
      points={{-38,-40},{-119.95,-40},{-119.95,0.05}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(senT_airIn.port_b, VFSen_out.port_a)
    annotation (Line(points={{-60,60},{-48,60}}, color={0,127,255}));
  connect(VFSen_out.port_b, dynamicHX.port_a1) annotation (Line(points={{-28,60},
          {-24,60},{-24,59.2},{-20,59.2}}, color={0,127,255}));
  connect(PT1_airIn.y, registerBus.Tair_in) annotation (Line(points={{-70,101},{
          -86,101},{-86,102},{-119.95,102},{-119.95,0.05}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(PT1_airOut.y, registerBus.Tair_out) annotation (Line(points={{70,101},
          {70,110},{-119.95,110},{-119.95,0.05}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(VFSen_out.V_flow, registerBus.VF_air) annotation (Line(points={{-38,49},
          {-38,30},{-119.95,30},{-119.95,0.05}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(senT_airIn.port_a, port_a1)
    annotation (Line(points={{-80,60},{-100,60}}, color={0,127,255}));
  connect(senT_airOut.port_b, port_b1)
    annotation (Line(points={{80,60},{100,60}}, color={0,127,255}));
  connect(partialHydraulicModule.port_a1, port_a2) annotation (Line(points={{-22.8,
          -78},{-58,-78},{-58,-72},{-100,-72},{-100,-60}}, color={0,127,255}));
  connect(partialHydraulicModule.port_b2, port_b2) annotation (Line(points={{22.8,
          -78},{100,-78},{100,-60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,120}}), graphics={Rectangle(
          extent={{-40,120},{40,40}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid), Line(
          points={{-40,120},{40,40}},
          color={0,0,0},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,120}})));
end RegisterModule;
