// Cypher Script for Battery Electric Vehicle SysML Model
// Created from bev_sysml_model.txt

// Cypher Script for Battery Electric Vehicle SysML Model
// Created from bev_sysml_model.txt

// Clear existing data (use with caution)
MATCH (n) OPTIONAL MATCH (n)-[r]-() DELETE n, r;

// ==========================
// Create Functional Requirements
// ==========================

// Overall Vehicle Functional Requirements
CREATE (fr_userAuth:functional_requirement {
    name: 'UserAuthentication',
    description: 'Must support user authentication and keyless entry.',
    label: 'User Authentication Requirement'
})
CREATE (fr_realTimeDiag:functional_requirement {
    name: 'RealTimeDiagnostics',
    description: 'Shall provide real-time vehicle diagnostics to the driver.',
    label: 'Real Time Diagnostics Requirement'
})
CREATE (fr_remoteSW:functional_requirement {
    name: 'RemoteSoftwareUpdates',
    description: 'Must enable remote software updates.',
    label: 'Remote Software Updates Requirement'
})
CREATE (fr_mobileApp:functional_requirement {
    name: 'MobileAppIntegration',
    description: 'Shall integrate with mobile applications for remote monitoring.',
    label: 'Mobile App Integration Requirement'
})
CREATE (fr_regCompliance:functional_requirement {
    name: 'RegulatoryCompliance',
    description: 'Must comply with all regional safety and emissions regulations.',
    label: 'Regulatory Compliance Requirement'
})
CREATE (fr_regenBraking:functional_requirement {
    name: 'RegenerativeBraking',
    description: 'Shall provide regenerative braking functionality.',
    label: 'Regenerative Braking Requirement'
})
CREATE (fr_chargingStandards:functional_requirement {
    name: 'ChargingStandards',
    description: 'Must support multiple charging standards (e.g., CCS, CHAdeMO).',
    label: 'Charging Standards Requirement'
})
CREATE (fr_otaUpdates:functional_requirement {
    name: 'OTAUpdates',
    description: 'Shall provide over-the-air (OTA) firmware updates.',
    label: 'OTA Updates Requirement'
})
CREATE (fr_userFriendlyHMI:functional_requirement {
    name: 'UserFriendlyHMI',
    description: 'Must have a user-friendly human-machine interface (HMI).',
    label: 'User Friendly HMI Requirement'
})
CREATE (fr_wirelessConn:functional_requirement {
    name: 'WirelessConnectivity',
    description: 'Must support wireless connectivity (Bluetooth, Wi-Fi, cellular).',
    label: 'Wireless Connectivity Requirement'
})

// Vehicle Propulsion Functional Requirements
CREATE (fr_seamlessTorque:functional_requirement {
    name: 'SeamlessTorqueDelivery',
    description: 'Must provide seamless torque delivery from standstill.',
    label: 'Seamless Torque Delivery Requirement'
})
CREATE (fr_driveModes:functional_requirement {
    name: 'DriveModesSupport',
    description: 'Shall support both forward and reverse drive modes.',
    label: 'Drive Modes Support Requirement'
})
CREATE (fr_regenBrakingInt:functional_requirement {
    name: 'RegenBrakingIntegration',
    description: 'Must integrate with regenerative braking system.',
    label: 'Regen Braking Integration Requirement'
})
CREATE (fr_hillAssist:functional_requirement {
    name: 'HillAssist',
    description: 'Shall enable hill-hold and hill-start assist features.',
    label: 'Hill Assist Requirement'
})

// BMS Functional Requirements
CREATE (fr_cellMonitoring:functional_requirement {
    name: 'CellMonitoring',
    description: 'Must monitor cell voltage, current, and temperature in real time.',
    label: 'Cell Monitoring Requirement'
})
CREATE (fr_stateEstimation:functional_requirement {
    name: 'StateEstimation',
    description: 'Shall estimate State of Charge (SOC) and State of Health (SOH) accurately.',
    label: 'State Estimation Requirement'
})
CREATE (fr_cellBalancing:functional_requirement {
    name: 'CellBalancing',
    description: 'Must perform active cell balancing.',
    label: 'Cell Balancing Requirement'
})
CREATE (fr_faultDetection:functional_requirement {
    name: 'FaultDetection',
    description: 'Shall detect and report faults (overvoltage, undervoltage, overtemperature, short circuit).',
    label: 'Fault Detection Requirement'
})
CREATE (fr_thermalControl:functional_requirement {
    name: 'ThermalControl',
    description: 'Must provide thermal management control signals.',
    label: 'Thermal Control Requirement'
})
CREATE (fr_safetyCompliance:functional_requirement {
    name: 'SafetyCompliance',
    description: 'Shall comply with ISO 26262 functional safety standards.',
    label: 'Safety Compliance Requirement'
})
CREATE (fr_dataLogging:functional_requirement {
    name: 'DataLogging',
    description: 'Must log operational data for diagnostics.',
    label: 'Data Logging Requirement'
})

// Thermal Management Functional Requirements
CREATE (fr_activeThermal:functional_requirement {
    name: 'ActiveThermalControl',
    description: 'Must actively cool or heat battery pack based on temperature thresholds.',
    label: 'Active Thermal Control Requirement'
})
CREATE (fr_hvacIntegration:functional_requirement {
    name: 'HVACIntegration',
    description: 'Shall integrate with cabin HVAC for waste heat recovery.',
    label: 'HVAC Integration Requirement'
})
CREATE (fr_coolantMonitor:functional_requirement {
    name: 'CoolantMonitoring',
    description: 'Must monitor coolant flow and temperature.',
    label: 'Coolant Monitoring Requirement'
})
CREATE (fr_powerElecCooling:functional_requirement {
    name: 'PowerElectronicsCooling',
    description: 'Shall provide thermal protection for power electronics.',
    label: 'Power Electronics Cooling Requirement'
})

// ESP Functional Requirements
CREATE (fr_sensorMonitor:functional_requirement {
    name: 'SensorMonitoring',
    description: 'Must monitor steering angle, wheel speeds, yaw rate, and lateral acceleration.',
    label: 'Sensor Monitoring Requirement'
})
CREATE (fr_stabilityIntervention:functional_requirement {
    name: 'StabilityIntervention',
    description: 'Shall intervene by reducing motor torque and/or applying individual wheel brakes.',
    label: 'Stability Intervention Requirement'
})
CREATE (fr_trailerStability:functional_requirement {
    name: 'TrailerStability',
    description: 'Must support trailer stability control.',
    label: 'Trailer Stability Requirement'
})
CREATE (fr_driverFeedback:functional_requirement {
    name: 'DriverFeedback',
    description: 'Shall provide driver feedback on ESP activation.',
    label: 'Driver Feedback Requirement'
})

// Vehicle Control Functional Requirements
CREATE (fr_systemCoord:functional_requirement {
    name: 'SystemCoordination',
    description: 'Must coordinate propulsion, braking, and steering systems.',
    label: 'System Coordination Requirement'
})
CREATE (fr_driveModesSupport:functional_requirement {
    name: 'DriveModesSupport',
    description: 'Shall support multiple drive modes (e.g., eco, sport, snow).',
    label: 'Drive Modes Support Requirement'
})
CREATE (fr_systemIntegration:functional_requirement {
    name: 'SystemIntegration',
    description: 'Must interface with ADAS and infotainment systems.',
    label: 'System Integration Requirement'
})
CREATE (fr_failSafeOp:functional_requirement {
    name: 'FailSafeOperation',
    description: 'Shall provide fail-safe operation in case of subsystem failure.',
    label: 'Fail Safe Operation Requirement'
})

// ADAS Functional Requirements
CREATE (fr_coreFeatures:functional_requirement {
    name: 'CoreFeatures',
    description: 'Must support adaptive cruise control, lane keeping, and emergency braking.',
    label: 'Core Features Requirement'
})
CREATE (fr_safetyFeatures:functional_requirement {
    name: 'SafetyFeatures',
    description: 'Shall provide blind spot detection and rear cross-traffic alert.',
    label: 'Safety Features Requirement'
})
CREATE (fr_navIntegration:functional_requirement {
    name: 'NavigationIntegration',
    description: 'Must integrate with navigation and mapping systems.',
    label: 'Navigation Integration Requirement'
})
CREATE (fr_otaCapability:functional_requirement {
    name: 'OTACapability',
    description: 'Shall enable over-the-air updates for ADAS algorithms.',
    label: 'OTA Capability Requirement'
})

// Brake System Functional Requirements
CREATE (fr_dualBraking:functional_requirement {
    name: 'DualBraking',
    description: 'Must provide both hydraulic and regenerative braking.',
    label: 'Dual Braking Requirement'
})
CREATE (fr_absEbd:functional_requirement {
    name: 'ABSandEBD',
    description: 'Shall support anti-lock braking (ABS) and electronic brake-force distribution (EBD).',
    label: 'ABS and EBD Requirement'
})
CREATE (fr_brakeSystemIntegration:functional_requirement {
    name: 'SystemIntegration',
    description: 'Must integrate with ESP and ADAS for coordinated interventions.',
    label: 'Brake System Integration Requirement'
})
CREATE (fr_wearFeedback:functional_requirement {
    name: 'WearFeedback',
    description: 'Shall provide driver feedback on brake wear.',
    label: 'Wear Feedback Requirement'
})

// ==========================
// Create Performance Requirements
// ==========================

// Overall Vehicle Performance Requirements
CREATE (pr_drivingRange:performance_requirement {
    name: 'DrivingRange',
    description: 'Must achieve a minimum driving range of 400 km per charge (target for 2030: >600 km).',
    label: 'Driving Range Requirement'
})
CREATE (pr_acceleration:performance_requirement {
    name: 'Acceleration',
    description: 'Shall accelerate from 0–100 km/h in less than 8 seconds.',
    label: 'Acceleration Requirement'
})
CREATE (pr_topSpeed:performance_requirement {
    name: 'TopSpeed',
    description: 'Must support a top speed of at least 160 km/h.',
    label: 'Top Speed Requirement'
})
CREATE (pr_brakingDistance:performance_requirement {
    name: 'BrakingDistance',
    description: 'Shall provide a minimum braking distance of 40 m from 100 km/h.',
    label: 'Braking Distance Requirement'
})
CREATE (pr_tempPerformance:performance_requirement {
    name: 'TemperaturePerformance',
    description: 'Must maintain full performance in ambient temperatures from -30°C to +50°C.',
    label: 'Temperature Performance Requirement'
})
CREATE (pr_fastCharging:performance_requirement {
    name: 'FastCharging',
    description: 'Shall support fast charging to 80% within 30 minutes.',
    label: 'Fast Charging Requirement'
})

// Vehicle Propulsion Performance Requirements
CREATE (pr_peakPower:performance_requirement {
    name: 'PeakPower',
    description: 'Must deliver a peak power output of at least 150 kW.',
    label: 'Peak Power Requirement'
})
CREATE (pr_maxTorque:performance_requirement {
    name: 'MaxTorque',
    description: 'Shall provide a maximum torque of 350 Nm.',
    label: 'Max Torque Requirement'
})
CREATE (pr_continuousOp:performance_requirement {
    name: 'ContinuousOperation',
    description: 'Must support continuous operation at 80% rated power for at least 30 minutes.',
    label: 'Continuous Operation Requirement'
})
CREATE (pr_gradeability:performance_requirement {
    name: 'Gradeability',
    description: 'Shall support a minimum gradeability of 20% at full load.',
    label: 'Gradeability Requirement'
})

// BMS Performance Requirements
CREATE (pr_chargeDischargeRate:performance_requirement {
    name: 'ChargeDischargeRate',
    description: 'Shall support charge/discharge rates up to 4C for peak power events.',
    label: 'Charge Discharge Rate Requirement'
})
CREATE (pr_voltageTolerance:performance_requirement {
    name: 'VoltageTolerance',
    description: 'Must maintain cell voltage within ±0.02 V tolerance.',
    label: 'Voltage Tolerance Requirement'
})
CREATE (pr_thermalRunaway:performance_requirement {
    name: 'ThermalRunawayDetection',
    description: 'Shall detect thermal runaway within 1 second.',
    label: 'Thermal Runaway Detection Requirement'
})
CREATE (pr_cycleLife:performance_requirement {
    name: 'CycleLife',
    description: 'Must support a battery cycle life of at least 1,500 full cycles.',
    label: 'Cycle Life Requirement'
})

// Thermal Management Performance Requirements
CREATE (pr_batteryTemp:performance_requirement {
    name: 'BatteryTemperature',
    description: 'Must maintain battery temperature between 15°C and 35°C during operation.',
    label: 'Battery Temperature Requirement'
})
CREATE (pr_preConditioning:performance_requirement {
    name: 'PreConditioning',
    description: 'Shall support rapid pre-conditioning before fast charging.',
    label: 'Pre Conditioning Requirement'
})
CREATE (pr_peakLoadCooling:performance_requirement {
    name: 'PeakLoadCooling',
    description: 'Must achieve full battery pack cooling within 10 minutes after peak load.',
    label: 'Peak Load Cooling Requirement'
})

// ESP Performance Requirements
CREATE (pr_responseTime:performance_requirement {
    name: 'ResponseTime',
    description: 'Must react to loss of stability within 50 ms.',
    label: 'Response Time Requirement'
})
CREATE (pr_rolloverPrev:performance_requirement {
    name: 'RolloverPrevention',
    description: 'Shall prevent vehicle rollover in emergency maneuvers.',
    label: 'Rollover Prevention Requirement'
})
CREATE (pr_speedRange:performance_requirement {
    name: 'SpeedRange',
    description: 'Must operate effectively at speeds from 0 to 200 km/h.',
    label: 'Speed Range Requirement'
})

// Vehicle Control Performance Requirements
CREATE (pr_controlLoopRate:performance_requirement {
    name: 'ControlLoopRate',
    description: 'Control loop update rate must be at least 100 Hz.',
    label: 'Control Loop Rate Requirement'
})
CREATE (pr_diagnosticsSupport:performance_requirement {
    name: 'DiagnosticsSupport',
    description: 'Shall support real-time diagnostics and fault logging.',
    label: 'Diagnostics Support Requirement'
})
CREATE (pr_bootTime:performance_requirement {
    name: 'BootTime',
    description: 'Must achieve system boot time < 2 seconds.',
    label: 'Boot Time Requirement'
})

// ADAS Performance Requirements
CREATE (pr_detectionRange:performance_requirement {
    name: 'DetectionRange',
    description: 'Object detection range must exceed 150 meters.',
    label: 'Detection Range Requirement'
})
CREATE (pr_laneKeepingAccuracy:performance_requirement {
    name: 'LaneKeepingAccuracy',
    description: 'Lane keeping accuracy must be within 10 cm.',
    label: 'Lane Keeping Accuracy Requirement'
})
CREATE (pr_brakingActivation:performance_requirement {
    name: 'BrakingActivation',
    description: 'Emergency braking activation time must be < 100 ms.',
    label: 'Braking Activation Requirement'
})

// Brake System Performance Requirements
CREATE (pr_stoppingDistance:performance_requirement {
    name: 'StoppingDistance',
    description: 'Maximum stopping distance from 100 km/h must not exceed 40 meters.',
    label: 'Stopping Distance Requirement'
})
CREATE (pr_energyRecovery:performance_requirement {
    name: 'EnergyRecovery',
    description: 'Regenerative braking must recover at least 70% of available kinetic energy.',
    label: 'Energy Recovery Requirement'
})
CREATE (pr_brakeResponseTime:performance_requirement {
    name: 'ResponseTime',
    description: 'Brake response time must be < 50 ms.',
    label: 'Brake Response Time Requirement'
})

// ==========================
// Create Resource Requirements
// ==========================

// Overall Vehicle Resource Requirements
CREATE (rr_energyConsumption:ressource_requirement {
    name: 'EnergyConsumption',
    description: 'Energy consumption must not exceed 16 kWh/100 km.',
    label: 'Energy Consumption Requirement'
})
CREATE (rr_materialCompliance:ressource_requirement {
    name: 'MaterialCompliance',
    description: 'Shall use materials compliant with environmental regulations (e.g., RoHS, REACH).',
    label: 'Material Compliance Requirement'
})
CREATE (rr_recyclability:ressource_requirement {
    name: 'Recyclability',
    description: 'Must achieve at least 95% recyclability of vehicle components.',
    label: 'Recyclability Requirement'
})
CREATE (rr_rareEarthMin:ressource_requirement {
    name: 'RareEarthMinimization',
    description: 'Shall minimize rare earth element usage in motors and batteries.',
    label: 'Rare Earth Minimization Requirement'
})

// Vehicle Propulsion Resource Requirements
CREATE (rr_powertrainEff:ressource_requirement {
    name: 'PowertrainEfficiency',
    description: 'Powertrain efficiency must exceed 90% under typical driving cycles.',
    label: 'Powertrain Efficiency Requirement'
})
CREATE (rr_emiEmissions:ressource_requirement {
    name: 'EMIEmissions',
    description: 'Shall minimize electromagnetic interference (EMI) emissions.',
    label: 'EMI Emissions Requirement'
})

// BMS Resource Requirements
CREATE (rr_bmsPower:ressource_requirement {
    name: 'PowerConsumption',
    description: 'BMS power consumption must not exceed 5 W.',
    label: 'BMS Power Consumption Requirement'
})
CREATE (rr_bmsOpTemp:ressource_requirement {
    name: 'OperatingTemperature',
    description: 'Shall operate reliably from -40°C to +85°C.',
    label: 'BMS Operating Temperature Requirement'
})

// Thermal Management Resource Requirements
CREATE (rr_energyUsage:ressource_requirement {
    name: 'EnergyUsage',
    description: 'System must use less than 1 kWh per 100 km for thermal management.',
    label: 'Energy Usage Requirement'
})
CREATE (rr_refrigerantGWP:ressource_requirement {
    name: 'RefrigerantGWP',
    description: 'Shall utilize refrigerants with low global warming potential.',
    label: 'Refrigerant GWP Requirement'
})

// ESP Resource Requirements
CREATE (rr_espPowerDraw:ressource_requirement {
    name: 'PowerDraw',
    description: 'ESP system power draw must not exceed 10 W.',
    label: 'ESP Power Draw Requirement'
})
CREATE (rr_espOpTemp:ressource_requirement {
    name: 'OperatingTemperature',
    description: 'Shall operate in ambient temperatures from -40°C to +85°C.',
    label: 'ESP Operating Temperature Requirement'
})

// Vehicle Control Resource Requirements
CREATE (rr_vcuPower:ressource_requirement {
    name: 'PowerConsumption',
    description: 'Controller power consumption must not exceed 15 W.',
    label: 'VCU Power Consumption Requirement'
})
CREATE (rr_processorGrade:ressource_requirement {
    name: 'ProcessorGrade',
    description: 'Must use automotive-grade microcontrollers.',
    label: 'Processor Grade Requirement'
})

// ADAS Resource Requirements
CREATE (rr_adasPowerDraw:ressource_requirement {
    name: 'PowerDraw',
    description: 'ADAS system power draw must not exceed 20 W.',
    label: 'ADAS Power Draw Requirement'
})
CREATE (rr_sensorGrade:ressource_requirement {
    name: 'SensorGrade',
    description: 'Shall use automotive-grade sensors (radar, lidar, cameras).',
    label: 'Sensor Grade Requirement'
})

// Brake System Resource Requirements
CREATE (rr_brakePowerDraw:ressource_requirement {
    name: 'PowerDraw',
    description: 'System power draw for electronic components must not exceed 5 W.',
    label: 'Brake Power Draw Requirement'
})
CREATE (rr_brakeMaterials:ressource_requirement {
    name: 'BrakeMaterials',
    description: 'Must use low-wear, environmentally friendly brake materials.',
    label: 'Brake Materials Requirement'
})

// ==========================
// Create Design Requirements
// ==========================

// Overall Vehicle Design Requirements
CREATE (dr_curbWeight:design_requirement {
    name: 'CurbWeight',
    description: 'Vehicle curb weight must not exceed 2,000 kg.',
    label: 'Curb Weight Requirement'
})
CREATE (dr_passengerCap:design_requirement {
    name: 'PassengerCapacity',
    description: 'Must accommodate at least five passengers.',
    label: 'Passenger Capacity Requirement'
})
CREATE (dr_luggageVol:design_requirement {
    name: 'LuggageVolume',
    description: 'Shall provide a minimum luggage volume of 400 liters.',
    label: 'Luggage Volume Requirement'
})
CREATE (dr_safetyStandards:design_requirement {
    name: 'SafetyStandards',
    description: 'Must meet Euro NCAP 5-star safety standards.',
    label: 'Safety Standards Requirement'
})
CREATE (dr_exteriorLength:design_requirement {
    name: 'ExteriorLength',
    description: 'Shall have a maximum exterior length of 4.8 meters.',
    label: 'Exterior Length Requirement'
})

// Vehicle Propulsion Design Requirements
CREATE (dr_motorMass:design_requirement {
    name: 'MotorMass',
    description: 'Electric motor mass must not exceed 80 kg.',
    label: 'Motor Mass Requirement'
})
CREATE (dr_systemVolume:design_requirement {
    name: 'SystemVolume',
    description: 'Propulsion system must fit within a 0.2 m³ volume.',
    label: 'System Volume Requirement'
})

// BMS Design Requirements
CREATE (dr_pcbArea:design_requirement {
    name: 'PCBArea',
    description: 'BMS PCB area must not exceed 250 cm².',
    label: 'PCB Area Requirement'
})
CREATE (dr_modularSupport:design_requirement {
    name: 'ModularSupport',
    description: 'Must support modular battery pack configurations.',
    label: 'Modular Support Requirement'
})

// Thermal Management Design Requirements
CREATE (dr_systemMass:design_requirement {
    name: 'SystemMass',
    description: 'Thermal system mass must not exceed 50 kg.',
    label: 'System Mass Requirement'
})
CREATE (dr_thermalSystemVol:design_requirement {
    name: 'SystemVolume',
    description: 'Must fit within a 0.1 m³ volume envelope.',
    label: 'Thermal System Volume Requirement'
})

// ESP Design Requirements
CREATE (dr_controllerFit:design_requirement {
    name: 'ControllerFit',
    description: 'ESP controller must fit within standard ECU housing.',
    label: 'Controller Fit Requirement'
})
CREATE (dr_sensorWiring:design_requirement {
    name: 'SensorWiring',
    description: 'Sensor wiring must not exceed 5 meters in length.',
    label: 'Sensor Wiring Requirement'
})

// Vehicle Control Design Requirements
CREATE (dr_vcuPcbArea:design_requirement {
    name: 'PCBArea',
    description: 'Controller PCB area must not exceed 200 cm².',
    label: 'VCU PCB Area Requirement'
})
CREATE (dr_softwareModularity:design_requirement {
    name: 'SoftwareModularity',
    description: 'Must support modular software updates.',
    label: 'Software Modularity Requirement'
})

// ADAS Design Requirements
CREATE (dr_sensorIntegration:design_requirement {
    name: 'SensorIntegration',
    description: 'Sensor modules must fit within standard bumper and windshield mounts.',
    label: 'Sensor Integration Requirement'
})
CREATE (dr_ecuVolume:design_requirement {
    name: 'ECUVolume',
    description: 'ADAS ECU must not exceed 1 liter in volume.',
    label: 'ECU Volume Requirement'
})

// Brake System Design Requirements
CREATE (dr_caliperMass:design_requirement {
    name: 'CaliperMass',
    description: 'Brake caliper mass must not exceed 4 kg per wheel.',
    label: 'Caliper Mass Requirement'
})
CREATE (dr_systemFit:design_requirement {
    name: 'SystemFit',
    description: 'Brake system must fit within standard wheel dimensions.',
    label: 'System Fit Requirement'
})

// ==========================
// Create Functions
// ==========================

// Overall Vehicle System Functions
CREATE (fn_userAuth:function {
    name: 'UserAuthentication',
    description: 'Validates user identity for vehicle access',
    label: 'User Authentication Function'
})
CREATE (fn_userAuth_in:function_input {
    name: 'keyFobSignal',
    description: 'Key fob signal input',
    label: 'Key Fob Signal'
})
CREATE (fn_userAuth_out:function_output {
    name: 'accessStatus',
    description: 'Access status output',
    label: 'Access Status'
})
// Fixed: CREATE (fn_userAuth)-[:HAS]->(fn_userAuth_in)
MATCH (fn_userAuth:function {name: 'UserAuthentication'})
MATCH (fn_userAuth_in:function_input {name: 'keyFobSignal'})
CREATE (fn_userAuth)-[:HAS]->(fn_userAuth_in);
// Fixed: CREATE (fn_userAuth)-[:HAS]->(fn_userAuth_out)
MATCH (fn_userAuth:function {name: 'UserAuthentication'})
MATCH (fn_userAuth_out:function_output {name: 'accessStatus'})
CREATE (fn_userAuth)-[:HAS]->(fn_userAuth_out);

CREATE (fn_realTimeDiag:function {
    name: 'RealTimeDiagnostics',
    description: 'Monitors and reports vehicle health',
    label: 'Real Time Diagnostics Function'
})
CREATE (fn_realTimeDiag_in:function_input {
    name: 'sensorData',
    description: 'Sensor data input',
    label: 'Sensor Data'
})
CREATE (fn_realTimeDiag_out:function_output {
    name: 'diagnosticReports',
    description: 'Diagnostic reports output',
    label: 'Diagnostic Reports'
})
// Fixed: CREATE (fn_realTimeDiag)-[:HAS]->(fn_realTimeDiag_in)
MATCH (fn_realTimeDiag:function {name: 'RealTimeDiagnostics'})
MATCH (fn_realTimeDiag_in:function_input {name: 'sensorData'})
CREATE (fn_realTimeDiag)-[:HAS]->(fn_realTimeDiag_in);
// Fixed: CREATE (fn_realTimeDiag)-[:HAS]->(fn_realTimeDiag_out)
MATCH (fn_realTimeDiag:function {name: 'RealTimeDiagnostics'})
MATCH (fn_realTimeDiag_out:function_output {name: 'diagnosticReports'})
CREATE (fn_realTimeDiag)-[:HAS]->(fn_realTimeDiag_out);

CREATE (fn_remoteSW:function {
    name: 'RemoteSoftwareUpdates',
    description: 'Updates vehicle software systems',
    label: 'Remote Software Updates Function'
})
CREATE (fn_remoteSW_in:function_input {
    name: 'updatePackage',
    description: 'Update package input',
    label: 'Update Package'
})
CREATE (fn_remoteSW_out:function_output {
    name: 'systemConfiguration',
    description: 'System configuration output',
    label: 'System Configuration'
})
// Fixed: CREATE (fn_remoteSW)-[:HAS]->(fn_remoteSW_in)
MATCH (fn_remoteSW:function {name: 'RemoteSoftwareUpdates'})
MATCH (fn_remoteSW_in:function_input {name: 'updatePackage'})
CREATE (fn_remoteSW)-[:HAS]->(fn_remoteSW_in);
// Fixed: CREATE (fn_remoteSW)-[:HAS]->(fn_remoteSW_out)
MATCH (fn_remoteSW:function {name: 'RemoteSoftwareUpdates'})
MATCH (fn_remoteSW_out:function_output {name: 'systemConfiguration'})
CREATE (fn_remoteSW)-[:HAS]->(fn_remoteSW_out);

CREATE (fn_mobileApp:function {
    name: 'MobileAppIntegration',
    description: 'Interfaces with user mobile applications',
    label: 'Mobile App Integration Function'
})
CREATE (fn_mobileApp_in:function_input {
    name: 'userCommands',
    description: 'User commands input',
    label: 'User Commands'
})
CREATE (fn_mobileApp_out:function_output {
    name: 'vehicleStatus',
    description: 'Vehicle status output',
    label: 'Vehicle Status'
})
// Fixed: CREATE (fn_mobileApp)-[:HAS]->(fn_mobileApp_in)
MATCH (fn_mobileApp:function {name: 'MobileAppIntegration'})
MATCH (fn_mobileApp_in:function_input {name: 'userCommands'})
CREATE (fn_mobileApp)-[:HAS]->(fn_mobileApp_in);
// Fixed: CREATE (fn_mobileApp)-[:HAS]->(fn_mobileApp_out)
MATCH (fn_mobileApp:function {name: 'MobileAppIntegration'})
MATCH (fn_mobileApp_out:function_output {name: 'vehicleStatus'})
CREATE (fn_mobileApp)-[:HAS]->(fn_mobileApp_out);

CREATE (fn_regenBrakeCtrl:function {
    name: 'RegenerativeBrakingControl',
    description: 'Controls energy recovery during braking',
    label: 'Regenerative Braking Control Function'
})
CREATE (fn_regenBrakeCtrl_in:function_input {
    name: 'brakePedalInput',
    description: 'Brake pedal input',
    label: 'Brake Pedal Input'
})
CREATE (fn_regenBrakeCtrl_out:function_output {
    name: 'energyRecoverySignal',
    description: 'Energy recovery signal output',
    label: 'Energy Recovery Signal'
})
// Fixed: CREATE (fn_regenBrakeCtrl)-[:HAS]->(fn_regenBrakeCtrl_in)
MATCH (fn_regenBrakeCtrl:function {name: 'RegenerativeBrakingControl'})
MATCH (fn_regenBrakeCtrl_in:function_input {name: 'brakePedalInput'})
CREATE (fn_regenBrakeCtrl)-[:HAS]->(fn_regenBrakeCtrl_in);
// Fixed: CREATE (fn_regenBrakeCtrl)-[:HAS]->(fn_regenBrakeCtrl_out)
MATCH (fn_regenBrakeCtrl:function {name: 'RegenerativeBrakingControl'})
MATCH (fn_regenBrakeCtrl_out:function_output {name: 'energyRecoverySignal'})
CREATE (fn_regenBrakeCtrl)-[:HAS]->(fn_regenBrakeCtrl_out);

CREATE (fn_chargingCompat:function {
    name: 'ChargingStandardCompatibility',
    description: 'Manages charging from various standards',
    label: 'Charging Standard Compatibility Function'
})
CREATE (fn_chargingCompat_in:function_input {
    name: 'acDcPower',
    description: 'AC/DC power input',
    label: 'AC/DC Power'
})
CREATE (fn_chargingCompat_out:function_output {
    name: 'chargingStatus',
    description: 'Charging status output',
    label: 'Charging Status'
})
// Fixed: CREATE (fn_chargingCompat)-[:HAS]->(fn_chargingCompat_in)
MATCH (fn_chargingCompat:function {name: 'ChargingStandardCompatibility'})
MATCH (fn_chargingCompat_in:function_input {name: 'acDcPower'})
CREATE (fn_chargingCompat)-[:HAS]->(fn_chargingCompat_in);
// Fixed: CREATE (fn_chargingCompat)-[:HAS]->(fn_chargingCompat_out)
MATCH (fn_chargingCompat:function {name: 'ChargingStandardCompatibility'})
MATCH (fn_chargingCompat_out:function_output {name: 'chargingStatus'})
CREATE (fn_chargingCompat)-[:HAS]->(fn_chargingCompat_out);

CREATE (fn_hmiInteract:function {
    name: 'HMIInteraction',
    description: 'Handles user interface interactions',
    label: 'HMI Interaction Function'
})
CREATE (fn_hmiInteract_in:function_input {
    name: 'touchVoiceCommands',
    description: 'Touch/voice commands input',
    label: 'Touch/Voice Commands'
})
CREATE (fn_hmiInteract_out:function_output {
    name: 'displayFeedback',
    description: 'Display feedback output',
    label: 'Display Feedback'
})
// Fixed: CREATE (fn_hmiInteract)-[:HAS]->(fn_hmiInteract_in)
MATCH (fn_hmiInteract:function {name: 'HMIInteraction'})
MATCH (fn_hmiInteract_in:function_input {name: 'touchVoiceCommands'})
CREATE (fn_hmiInteract)-[:HAS]->(fn_hmiInteract_in);
// Fixed: CREATE (fn_hmiInteract)-[:HAS]->(fn_hmiInteract_out)
MATCH (fn_hmiInteract:function {name: 'HMIInteraction'})
MATCH (fn_hmiInteract_out:function_output {name: 'displayFeedback'})
CREATE (fn_hmiInteract)-[:HAS]->(fn_hmiInteract_out);

// Vehicle Propulsion Functions
CREATE (fn_torqueDelivery:function {
    name: 'TorqueDelivery',
    description: 'Converts accelerator input to mechanical energy',
    label: 'Torque Delivery Function'
})
CREATE (fn_torqueDelivery_in:function_input {
    name: 'acceleratorPedalInput',
    description: 'Accelerator pedal input',
    label: 'Accelerator Pedal Input'
})
CREATE (fn_torqueDelivery_out:function_output {
    name: 'mechanicalEnergy',
    description: 'Mechanical energy output',
    label: 'Mechanical Energy'
})
// Fixed: CREATE (fn_torqueDelivery)-[:HAS]->(fn_torqueDelivery_in)
MATCH (fn_torqueDelivery:function {name: 'TorqueDelivery'})
MATCH (fn_torqueDelivery_in:function_input {name: 'acceleratorPedalInput'})
CREATE (fn_torqueDelivery)-[:HAS]->(fn_torqueDelivery_in);
// Fixed: CREATE (fn_torqueDelivery)-[:HAS]->(fn_torqueDelivery_out)
MATCH (fn_torqueDelivery:function {name: 'TorqueDelivery'})
MATCH (fn_torqueDelivery_out:function_output {name: 'mechanicalEnergy'})
CREATE (fn_torqueDelivery)-[:HAS]->(fn_torqueDelivery_out);

CREATE (fn_driveModes:function {
    name: 'ForwardReverseDriveModes',
    description: 'Controls motor rotation direction',
    label: 'Drive Modes Function'
})
CREATE (fn_driveModes_in:function_input {
    name: 'gearSelector',
    description: 'Gear selector input',
    label: 'Gear Selector'
})
CREATE (fn_driveModes_out:function_output {
    name: 'motorRotationDirection',
    description: 'Motor rotation direction output',
    label: 'Motor Rotation Direction'
})
// Fixed: CREATE (fn_driveModes)-[:HAS]->(fn_driveModes_in)
MATCH (fn_driveModes:function {name: 'ForwardReverseDriveModes'})
MATCH (fn_driveModes_in:function_input {name: 'gearSelector'})
CREATE (fn_driveModes)-[:HAS]->(fn_driveModes_in);
// Fixed: CREATE (fn_driveModes)-[:HAS]->(fn_driveModes_out)
MATCH (fn_driveModes:function {name: 'ForwardReverseDriveModes'})
MATCH (fn_driveModes_out:function_output {name: 'motorRotationDirection'})
CREATE (fn_driveModes)-[:HAS]->(fn_driveModes_out);

CREATE (fn_regenBraking:function {
    name: 'RegenerativeBrakingIntegration',
    description: 'Integrates regenerative braking with propulsion',
    label: 'Regenerative Braking Integration Function'
})
CREATE (fn_regenBraking_in:function_input {
    name: 'brakePedalInput',
    description: 'Brake pedal input',
    label: 'Brake Pedal Input'
})
CREATE (fn_regenBraking_out:function_output {
    name: 'energyRecoverySignal',
    description: 'Energy recovery signal output',
    label: 'Energy Recovery Signal'
})
// Fixed: CREATE (fn_regenBraking)-[:HAS]->(fn_regenBraking_in)
MATCH (fn_regenBraking:function {name: 'RegenerativeBrakingIntegration'})
MATCH (fn_regenBraking_in:function_input {name: 'brakePedalInput'})
CREATE (fn_regenBraking)-[:HAS]->(fn_regenBraking_in);
// Fixed: CREATE (fn_regenBraking)-[:HAS]->(fn_regenBraking_out)
MATCH (fn_regenBraking:function {name: 'RegenerativeBrakingIntegration'})
MATCH (fn_regenBraking_out:function_output {name: 'energyRecoverySignal'})
CREATE (fn_regenBraking)-[:HAS]->(fn_regenBraking_out);

CREATE (fn_hillHold:function {
    name: 'HillHoldAssist',
    description: 'Maintains brake pressure on inclines',
    label: 'Hill Hold Assist Function'
})
CREATE (fn_hillHold_in:function_input {
    name: 'inclineSensorData',
    description: 'Incline sensor data input',
    label: 'Incline Sensor Data'
})
CREATE (fn_hillHold_out:function_output {
    name: 'brakePressure',
    description: 'Brake pressure output',
    label: 'Brake Pressure'
})
// Fixed: CREATE (fn_hillHold)-[:HAS]->(fn_hillHold_in)
MATCH (fn_hillHold:function {name: 'HillHoldAssist'})
MATCH (fn_hillHold_in:function_input {name: 'inclineSensorData'})
CREATE (fn_hillHold)-[:HAS]->(fn_hillHold_in);
// Fixed: CREATE (fn_hillHold)-[:HAS]->(fn_hillHold_out)
MATCH (fn_hillHold:function {name: 'HillHoldAssist'})
MATCH (fn_hillHold_out:function_output {name: 'brakePressure'})
CREATE (fn_hillHold)-[:HAS]->(fn_hillHold_out);

// BMS Functions
CREATE (fn_cellMonitoring:function {
    name: 'CellVoltageMonitoring',
    description: 'Monitors individual cell voltages',
    label: 'Cell Voltage Monitoring Function'
})
CREATE (fn_cellMonitoring_in:function_input {
    name: 'cellVoltage',
    description: 'Cell voltage input',
    label: 'Cell Voltage'
})
CREATE (fn_cellMonitoring_out:function_output {
    name: 'voltageStatus',
    description: 'Voltage status output',
    label: 'Voltage Status'
})
// Fixed: CREATE (fn_cellMonitoring)-[:HAS]->(fn_cellMonitoring_in)
MATCH (fn_cellMonitoring:function {name: 'CellVoltageMonitoring'})
MATCH (fn_cellMonitoring_in:function_input {name: 'cellVoltage'})
CREATE (fn_cellMonitoring)-[:HAS]->(fn_cellMonitoring_in);
// Fixed: CREATE (fn_cellMonitoring)-[:HAS]->(fn_cellMonitoring_out)
MATCH (fn_cellMonitoring:function {name: 'CellVoltageMonitoring'})
MATCH (fn_cellMonitoring_out:function_output {name: 'voltageStatus'})
CREATE (fn_cellMonitoring)-[:HAS]->(fn_cellMonitoring_out);

CREATE (fn_socSohEst:function {
    name: 'SOCSOHEstimation',
    description: 'Estimates battery state of charge and health',
    label: 'SOC SOH Estimation Function'
})
CREATE (fn_socSohEst_in:function_input {
    name: 'voltageCurrentTemp',
    description: 'Voltage, current, temperature input',
    label: 'Voltage Current Temp'
})
CREATE (fn_socSohEst_out:function_output {
    name: 'socSohReport',
    description: 'SOC/SOH report output',
    label: 'SOC SOH Report'
})
// Fixed: CREATE (fn_socSohEst)-[:HAS]->(fn_socSohEst_in)
MATCH (fn_socSohEst:function {name: 'SOCSOHEstimation'})
MATCH (fn_socSohEst_in:function_input {name: 'voltageCurrentTemp'})
CREATE (fn_socSohEst)-[:HAS]->(fn_socSohEst_in);
// Fixed: CREATE (fn_socSohEst)-[:HAS]->(fn_socSohEst_out)
MATCH (fn_socSohEst:function {name: 'SOCSOHEstimation'})
MATCH (fn_socSohEst_out:function_output {name: 'socSohReport'})
CREATE (fn_socSohEst)-[:HAS]->(fn_socSohEst_out);

CREATE (fn_cellBalancing:function {
    name: 'ActiveCellBalancing',
    description: 'Balances cell voltages',
    label: 'Active Cell Balancing Function'
})
CREATE (fn_cellBalancing_in:function_input {
    name: 'cellVoltage',
    description: 'Cell voltage input',
    label: 'Cell Voltage'
})
CREATE (fn_cellBalancing_out:function_output {
    name: 'balancingCommands',
    description: 'Balancing commands output',
    label: 'Balancing Commands'
})
// Fixed: CREATE (fn_cellBalancing)-[:HAS]->(fn_cellBalancing_in)
MATCH (fn_cellBalancing:function {name: 'ActiveCellBalancing'})
MATCH (fn_cellBalancing_in:function_input {name: 'cellVoltage'})
CREATE (fn_cellBalancing)-[:HAS]->(fn_cellBalancing_in);
// Fixed: CREATE (fn_cellBalancing)-[:HAS]->(fn_cellBalancing_out)
MATCH (fn_cellBalancing:function {name: 'ActiveCellBalancing'})
MATCH (fn_cellBalancing_out:function_output {name: 'balancingCommands'})
CREATE (fn_cellBalancing)-[:HAS]->(fn_cellBalancing_out);

CREATE (fn_faultDetect:function {
    name: 'FaultDetection',
    description: 'Detects and reports battery faults',
    label: 'Fault Detection Function'
})
CREATE (fn_faultDetect_in:function_input {
    name: 'sensorData',
    description: 'Sensor data input',
    label: 'Sensor Data'
})
CREATE (fn_faultDetect_out:function_output {
    name: 'faultAlerts',
    description: 'Fault alerts output',
    label: 'Fault Alerts'
})
// Fixed: CREATE (fn_faultDetect)-[:HAS]->(fn_faultDetect_in)
MATCH (fn_faultDetect:function {name: 'FaultDetection'})
MATCH (fn_faultDetect_in:function_input {name: 'sensorData'})
CREATE (fn_faultDetect)-[:HAS]->(fn_faultDetect_in);
// Fixed: CREATE (fn_faultDetect)-[:HAS]->(fn_faultDetect_out)
MATCH (fn_faultDetect:function {name: 'FaultDetection'})
MATCH (fn_faultDetect_out:function_output {name: 'faultAlerts'})
CREATE (fn_faultDetect)-[:HAS]->(fn_faultDetect_out);

CREATE (fn_thermalCtrl:function {
    name: 'ThermalManagementControl',
    description: 'Controls battery thermal management',
    label: 'Thermal Management Control Function'
})
CREATE (fn_thermalCtrl_in:function_input {
    name: 'temperatureData',
    description: 'Temperature data input',
    label: 'Temperature Data'
})
CREATE (fn_thermalCtrl_out:function_output {
    name: 'coolingHeatingCommands',
    description: 'Cooling/heating commands output',
    label: 'Cooling Heating Commands'
})
// Fixed: CREATE (fn_thermalCtrl)-[:HAS]->(fn_thermalCtrl_in)
MATCH (fn_thermalCtrl:function {name: 'ThermalManagementControl'})
MATCH (fn_thermalCtrl_in:function_input {name: 'temperatureData'})
CREATE (fn_thermalCtrl)-[:HAS]->(fn_thermalCtrl_in);
// Fixed: CREATE (fn_thermalCtrl)-[:HAS]->(fn_thermalCtrl_out)
MATCH (fn_thermalCtrl:function {name: 'ThermalManagementControl'})
MATCH (fn_thermalCtrl_out:function_output {name: 'coolingHeatingCommands'})
CREATE (fn_thermalCtrl)-[:HAS]->(fn_thermalCtrl_out);

CREATE (fn_safetyComply:function {
    name: 'SafetyCompliance',
    description: 'Ensures safety compliance',
    label: 'Safety Compliance Function'
})
CREATE (fn_safetyComply_in:function_input {
    name: 'systemStatus',
    description: 'System status input',
    label: 'System Status'
})
CREATE (fn_safetyComply_out:function_output {
    name: 'safetyShutdownSignal',
    description: 'Safety shutdown signal output',
    label: 'Safety Shutdown Signal'
})
// Fixed: CREATE (fn_safetyComply)-[:HAS]->(fn_safetyComply_in)
MATCH (fn_safetyComply:function {name: 'SafetyCompliance'})
MATCH (fn_safetyComply_in:function_input {name: 'systemStatus'})
CREATE (fn_safetyComply)-[:HAS]->(fn_safetyComply_in);
// Fixed: CREATE (fn_safetyComply)-[:HAS]->(fn_safetyComply_out)
MATCH (fn_safetyComply:function {name: 'SafetyCompliance'})
MATCH (fn_safetyComply_out:function_output {name: 'safetyShutdownSignal'})
CREATE (fn_safetyComply)-[:HAS]->(fn_safetyComply_out);

CREATE (fn_dataLog:function {
    name: 'DataLogging',
    description: 'Logs operational data',
    label: 'Data Logging Function'
})
CREATE (fn_dataLog_in:function_input {
    name: 'operationalData',
    description: 'Operational data input',
    label: 'Operational Data'
})
CREATE (fn_dataLog_out:function_output {
    name: 'loggedData',
    description: 'Logged data output',
    label: 'Logged Data'
})
// Fixed: CREATE (fn_dataLog)-[:HAS]->(fn_dataLog_in)
MATCH (fn_dataLog:function {name: 'DataLogging'})
MATCH (fn_dataLog_in:function_input {name: 'operationalData'})
CREATE (fn_dataLog)-[:HAS]->(fn_dataLog_in);
// Fixed: CREATE (fn_dataLog)-[:HAS]->(fn_dataLog_out)
MATCH (fn_dataLog:function {name: 'DataLogging'})
MATCH (fn_dataLog_out:function_output {name: 'loggedData'})
CREATE (fn_dataLog)-[:HAS]->(fn_dataLog_out);

// Thermal Management Functions
CREATE (fn_batteryCooling:function {
    name: 'BatteryCoolingHeating',
    description: 'Controls battery temperature',
    label: 'Battery Cooling Heating Function'
})
CREATE (fn_batteryCooling_in:function_input {
    name: 'coolantFlow',
    description: 'Coolant flow input',
    label: 'Coolant Flow'
})
CREATE (fn_batteryCooling_out:function_output {
    name: 'adjustedCoolantFlow',
    description: 'Adjusted coolant flow output',
    label: 'Adjusted Coolant Flow'
})
// Fixed: CREATE (fn_batteryCooling)-[:HAS]->(fn_batteryCooling_in)
MATCH (fn_batteryCooling:function {name: 'BatteryCoolingHeating'})
MATCH (fn_batteryCooling_in:function_input {name: 'coolantFlow'})
CREATE (fn_batteryCooling)-[:HAS]->(fn_batteryCooling_in);
// Fixed: CREATE (fn_batteryCooling)-[:HAS]->(fn_batteryCooling_out)
MATCH (fn_batteryCooling:function {name: 'BatteryCoolingHeating'})
MATCH (fn_batteryCooling_out:function_output {name: 'adjustedCoolantFlow'})
CREATE (fn_batteryCooling)-[:HAS]->(fn_batteryCooling_out);

CREATE (fn_wasteHeat:function {
    name: 'WasteHeatRecovery',
    description: 'Recovers waste heat from systems',
    label: 'Waste Heat Recovery Function'
})
CREATE (fn_wasteHeat_in:function_input {
    name: 'cabinHVACData',
    description: 'Cabin HVAC data input',
    label: 'Cabin HVAC Data'
})
CREATE (fn_wasteHeat_out:function_output {
    name: 'heatRedistribution',
    description: 'Heat redistribution output',
    label: 'Heat Redistribution'
})
// Fixed: CREATE (fn_wasteHeat)-[:HAS]->(fn_wasteHeat_in)
MATCH (fn_wasteHeat:function {name: 'WasteHeatRecovery'})
MATCH (fn_wasteHeat_in:function_input {name: 'cabinHVACData'})
CREATE (fn_wasteHeat)-[:HAS]->(fn_wasteHeat_in);
// Fixed: CREATE (fn_wasteHeat)-[:HAS]->(fn_wasteHeat_out)
MATCH (fn_wasteHeat:function {name: 'WasteHeatRecovery'})
MATCH (fn_wasteHeat_out:function_output {name: 'heatRedistribution'})
CREATE (fn_wasteHeat)-[:HAS]->(fn_wasteHeat_out);

CREATE (fn_coolantMonitor:function {
    name: 'CoolantFlowMonitoring',
    description: 'Monitors coolant system',
    label: 'Coolant Flow Monitoring Function'
})
CREATE (fn_coolantMonitor_in:function_input {
    name: 'flowSensorData',
    description: 'Flow sensor data input',
    label: 'Flow Sensor Data'
})
CREATE (fn_coolantMonitor_out:function_output {
    name: 'flowRateAlerts',
    description: 'Flow rate alerts output',
    label: 'Flow Rate Alerts'
})
// Fixed: CREATE (fn_coolantMonitor)-[:HAS]->(fn_coolantMonitor_in)
MATCH (fn_coolantMonitor:function {name: 'CoolantFlowMonitoring'})
MATCH (fn_coolantMonitor_in:function_input {name: 'flowSensorData'})
CREATE (fn_coolantMonitor)-[:HAS]->(fn_coolantMonitor_in);
// Fixed: CREATE (fn_coolantMonitor)-[:HAS]->(fn_coolantMonitor_out)
MATCH (fn_coolantMonitor:function {name: 'CoolantFlowMonitoring'})
MATCH (fn_coolantMonitor_out:function_output {name: 'flowRateAlerts'})
CREATE (fn_coolantMonitor)-[:HAS]->(fn_coolantMonitor_out);

CREATE (fn_powerElecCool:function {
    name: 'PowerElectronicsCooling',
    description: 'Cools power electronics',
    label: 'Power Electronics Cooling Function'
})
CREATE (fn_powerElecCool_in:function_input {
    name: 'temperatureData',
    description: 'Temperature data input',
    label: 'Temperature Data'
})
CREATE (fn_powerElecCool_out:function_output {
    name: 'fanPumpControl',
    description: 'Fan/pump control output',
    label: 'Fan Pump Control'
})
// Fixed: CREATE (fn_powerElecCool)-[:HAS]->(fn_powerElecCool_in)
MATCH (fn_powerElecCool:function {name: 'PowerElectronicsCooling'})
MATCH (fn_powerElecCool_in:function_input {name: 'temperatureData'})
CREATE (fn_powerElecCool)-[:HAS]->(fn_powerElecCool_in);
// Fixed: CREATE (fn_powerElecCool)-[:HAS]->(fn_powerElecCool_out)
MATCH (fn_powerElecCool:function {name: 'PowerElectronicsCooling'})
MATCH (fn_powerElecCool_out:function_output {name: 'fanPumpControl'})
CREATE (fn_powerElecCool)-[:HAS]->(fn_powerElecCool_out);

// ESP Functions
CREATE (fn_yawMonitor:function {
    name: 'YawRateMonitoring',
    description: 'Monitors vehicle rotation',
    label: 'Yaw Rate Monitoring Function'
})
CREATE (fn_yawMonitor_in:function_input {
    name: 'gyroscopeData',
    description: 'Gyroscope data input',
    label: 'Gyroscope Data'
})
CREATE (fn_yawMonitor_out:function_output {
    name: 'stabilityStatus',
    description: 'Stability status output',
    label: 'Stability Status'
})
// Fixed: CREATE (fn_yawMonitor)-[:HAS]->(fn_yawMonitor_in)
MATCH (fn_yawMonitor:function {name: 'YawRateMonitoring'})
MATCH (fn_yawMonitor_in:function_input {name: 'gyroscopeData'})
CREATE (fn_yawMonitor)-[:HAS]->(fn_yawMonitor_in);
// Fixed: CREATE (fn_yawMonitor)-[:HAS]->(fn_yawMonitor_out)
MATCH (fn_yawMonitor:function {name: 'YawRateMonitoring'})
MATCH (fn_yawMonitor_out:function_output {name: 'stabilityStatus'})
CREATE (fn_yawMonitor)-[:HAS]->(fn_yawMonitor_out);

CREATE (fn_torqueReduce:function {
    name: 'TorqueReduction',
    description: 'Reduces motor torque for stability',
    label: 'Torque Reduction Function'
})
CREATE (fn_torqueReduce_in:function_input {
    name: 'stabilityLossSignal',
    description: 'Stability loss signal input',
    label: 'Stability Loss Signal'
})
CREATE (fn_torqueReduce_out:function_output {
    name: 'motorTorqueLimit',
    description: 'Motor torque limit output',
    label: 'Motor Torque Limit'
})
// Fixed: CREATE (fn_torqueReduce)-[:HAS]->(fn_torqueReduce_in)
MATCH (fn_torqueReduce:function {name: 'TorqueReduction'})
MATCH (fn_torqueReduce_in:function_input {name: 'stabilityLossSignal'})
CREATE (fn_torqueReduce)-[:HAS]->(fn_torqueReduce_in);
// Fixed: CREATE (fn_torqueReduce)-[:HAS]->(fn_torqueReduce_out)
MATCH (fn_torqueReduce:function {name: 'TorqueReduction'})
MATCH (fn_torqueReduce_out:function_output {name: 'motorTorqueLimit'})
CREATE (fn_torqueReduce)-[:HAS]->(fn_torqueReduce_out);

CREATE (fn_wheelBrake:function {
    name: 'IndividualWheelBraking',
    description: 'Controls individual wheel brakes',
    label: 'Individual Wheel Braking Function'
})
CREATE (fn_wheelBrake_in:function_input {
    name: 'wheelSpeed',
    description: 'Wheel speed input',
    label: 'Wheel Speed'
})
CREATE (fn_wheelBrake_out:function_output {
    name: 'brakePressureAdjustment',
    description: 'Brake pressure adjustment output',
    label: 'Brake Pressure Adjustment'
})
// Fixed: CREATE (fn_wheelBrake)-[:HAS]->(fn_wheelBrake_in)
MATCH (fn_wheelBrake:function {name: 'IndividualWheelBraking'})
MATCH (fn_wheelBrake_in:function_input {name: 'wheelSpeed'})
CREATE (fn_wheelBrake)-[:HAS]->(fn_wheelBrake_in);
// Fixed: CREATE (fn_wheelBrake)-[:HAS]->(fn_wheelBrake_out)
MATCH (fn_wheelBrake:function {name: 'IndividualWheelBraking'})
MATCH (fn_wheelBrake_out:function_output {name: 'brakePressureAdjustment'})
CREATE (fn_wheelBrake)-[:HAS]->(fn_wheelBrake_out);

CREATE (fn_trailerStab:function {
    name: 'TrailerStabilityControl',
    description: 'Stabilizes trailer motion',
    label: 'Trailer Stability Control Function'
})
CREATE (fn_trailerStab_in:function_input {
    name: 'trailerMotionData',
    description: 'Trailer motion data input',
    label: 'Trailer Motion Data'
})
CREATE (fn_trailerStab_out:function_output {
    name: 'brakeTorqueAdjustments',
    description: 'Brake torque adjustments output',
    label: 'Brake Torque Adjustments'
})
// Fixed: CREATE (fn_trailerStab)-[:HAS]->(fn_trailerStab_in)
MATCH (fn_trailerStab:function {name: 'TrailerStabilityControl'})
MATCH (fn_trailerStab_in:function_input {name: 'trailerMotionData'})
CREATE (fn_trailerStab)-[:HAS]->(fn_trailerStab_in);
// Fixed: CREATE (fn_trailerStab)-[:HAS]->(fn_trailerStab_out)
MATCH (fn_trailerStab:function {name: 'TrailerStabilityControl'})
MATCH (fn_trailerStab_out:function_output {name: 'brakeTorqueAdjustments'})
CREATE (fn_trailerStab)-[:HAS]->(fn_trailerStab_out);

// Vehicle Control Functions
CREATE (fn_driveMode:function {
    name: 'DriveModeCoordination',
    description: 'Coordinates drive modes',
    label: 'Drive Mode Coordination Function'
})
CREATE (fn_driveMode_in:function_input {
    name: 'modeSelector',
    description: 'Mode selector input',
    label: 'Mode Selector'
})
CREATE (fn_driveMode_out:function_output {
    name: 'powertrainConfiguration',
    description: 'Powertrain configuration output',
    label: 'Powertrain Configuration'
})
// Fixed: CREATE (fn_driveMode)-[:HAS]->(fn_driveMode_in)
MATCH (fn_driveMode:function {name: 'DriveModeCoordination'})
MATCH (fn_driveMode_in:function_input {name: 'modeSelector'})
CREATE (fn_driveMode)-[:HAS]->(fn_driveMode_in);
// Fixed: CREATE (fn_driveMode)-[:HAS]->(fn_driveMode_out)
MATCH (fn_driveMode:function {name: 'DriveModeCoordination'})
MATCH (fn_driveMode_out:function_output {name: 'powertrainConfiguration'})
CREATE (fn_driveMode)-[:HAS]->(fn_driveMode_out);

CREATE (fn_subsysInteg:function {
    name: 'SubsystemIntegration',
    description: 'Integrates vehicle subsystems',
    label: 'Subsystem Integration Function'
})
CREATE (fn_subsysInteg_in:function_input {
    name: 'vcuCommands',
    description: 'VCU commands input',
    label: 'VCU Commands'
})
CREATE (fn_subsysInteg_out:function_output {
    name: 'brakePropulsionSignals',
    description: 'Brake propulsion signals output',
    label: 'Brake Propulsion Signals'
})
// Fixed: CREATE (fn_subsysInteg)-[:HAS]->(fn_subsysInteg_in)
MATCH (fn_subsysInteg:function {name: 'SubsystemIntegration'})
MATCH (fn_subsysInteg_in:function_input {name: 'vcuCommands'})
CREATE (fn_subsysInteg)-[:HAS]->(fn_subsysInteg_in);
// Fixed: CREATE (fn_subsysInteg)-[:HAS]->(fn_subsysInteg_out)
MATCH (fn_subsysInteg:function {name: 'SubsystemIntegration'})
MATCH (fn_subsysInteg_out:function_output {name: 'brakePropulsionSignals'})
CREATE (fn_subsysInteg)-[:HAS]->(fn_subsysInteg_out);

CREATE (fn_failSafe:function {
    name: 'FailSafeActivation',
    description: 'Activates fail-safe modes',
    label: 'Fail Safe Activation Function'
})
CREATE (fn_failSafe_in:function_input {
    name: 'faultAlerts',
    description: 'Fault alerts input',
    label: 'Fault Alerts'
})
CREATE (fn_failSafe_out:function_output {
    name: 'emergencyShutdown',
    description: 'Emergency shutdown output',
    label: 'Emergency Shutdown'
})
// Fixed: CREATE (fn_failSafe)-[:HAS]->(fn_failSafe_in)
MATCH (fn_failSafe:function {name: 'FailSafeActivation'})
MATCH (fn_failSafe_in:function_input {name: 'faultAlerts'})
CREATE (fn_failSafe)-[:HAS]->(fn_failSafe_in);
// Fixed: CREATE (fn_failSafe)-[:HAS]->(fn_failSafe_out)
MATCH (fn_failSafe:function {name: 'FailSafeActivation'})
MATCH (fn_failSafe_out:function_output {name: 'emergencyShutdown'})
CREATE (fn_failSafe)-[:HAS]->(fn_failSafe_out);

CREATE (fn_realTimeDiag2:function {
    name: 'RealTimeDiagnostics',
    description: 'Provides real-time system diagnostics',
    label: 'Real Time Diagnostics Function 2'
})
CREATE (fn_realTimeDiag2_in:function_input {
    name: 'sensorData',
    description: 'Sensor data input',
    label: 'Sensor Data'
})
CREATE (fn_realTimeDiag2_out:function_output {
    name: 'systemHealthReport',
    description: 'System health report output',
    label: 'System Health Report'
})
// Fixed: CREATE (fn_realTimeDiag2)-[:HAS]->(fn_realTimeDiag2_in)
MATCH (fn_realTimeDiag2:function {name: 'RealTimeDiagnostics'})
MATCH (fn_realTimeDiag2_in:function_input {name: 'sensorData'})
CREATE (fn_realTimeDiag2)-[:HAS]->(fn_realTimeDiag2_in);
// Fixed: CREATE (fn_realTimeDiag2)-[:HAS]->(fn_realTimeDiag2_out)
MATCH (fn_realTimeDiag2:function {name: 'RealTimeDiagnostics'})
MATCH (fn_realTimeDiag2_out:function_output {name: 'systemHealthReport'})
CREATE (fn_realTimeDiag2)-[:HAS]->(fn_realTimeDiag2_out);

// ADAS Functions
CREATE (fn_adaptiveCruise:function {
    name: 'AdaptiveCruiseControl',
    description: 'Maintains safe following distance',
    label: 'Adaptive Cruise Control Function'
})
CREATE (fn_adaptiveCruise_in:function_input {
    name: 'radarCameraData',
    description: 'Radar/camera data input',
    label: 'Radar Camera Data'
})
CREATE (fn_adaptiveCruise_out:function_output {
    name: 'speedAdjustment',
    description: 'Speed adjustment output',
    label: 'Speed Adjustment'
})
// Fixed: CREATE (fn_adaptiveCruise)-[:HAS]->(fn_adaptiveCruise_in)
MATCH (fn_adaptiveCruise:function {name: 'AdaptiveCruiseControl'})
MATCH (fn_adaptiveCruise_in:function_input {name: 'radarCameraData'})
CREATE (fn_adaptiveCruise)-[:HAS]->(fn_adaptiveCruise_in);
// Fixed: CREATE (fn_adaptiveCruise)-[:HAS]->(fn_adaptiveCruise_out)
MATCH (fn_adaptiveCruise:function {name: 'AdaptiveCruiseControl'})
MATCH (fn_adaptiveCruise_out:function_output {name: 'speedAdjustment'})
CREATE (fn_adaptiveCruise)-[:HAS]->(fn_adaptiveCruise_out);

CREATE (fn_laneKeeping:function {
    name: 'LaneKeepingAssist',
    description: 'Keeps vehicle in lane',
    label: 'Lane Keeping Assist Function'
})
CREATE (fn_laneKeeping_in:function_input {
    name: 'cameraData',
    description: 'Camera data input',
    label: 'Camera Data'
})
CREATE (fn_laneKeeping_out:function_output {
    name: 'steeringCorrection',
    description: 'Steering correction output',
    label: 'Steering Correction'
})
// Fixed: CREATE (fn_laneKeeping)-[:HAS]->(fn_laneKeeping_in)
MATCH (fn_laneKeeping:function {name: 'LaneKeepingAssist'})
MATCH (fn_laneKeeping_in:function_input {name: 'cameraData'})
CREATE (fn_laneKeeping)-[:HAS]->(fn_laneKeeping_in);
// Fixed: CREATE (fn_laneKeeping)-[:HAS]->(fn_laneKeeping_out)
MATCH (fn_laneKeeping:function {name: 'LaneKeepingAssist'})
MATCH (fn_laneKeeping_out:function_output {name: 'steeringCorrection'})
CREATE (fn_laneKeeping)-[:HAS]->(fn_laneKeeping_out);

CREATE (fn_emergencyBrake:function {
    name: 'EmergencyBraking',
    description: 'Applies brakes to avoid collision',
    label: 'Emergency Braking Function'
})
CREATE (fn_emergencyBrake_in:function_input {
    name: 'objectDetection',
    description: 'Object detection input',
    label: 'Object Detection'
})
CREATE (fn_emergencyBrake_out:function_output {
    name: 'brakeActuation',
    description: 'Brake actuation output',
    label: 'Brake Actuation'
})
// Fixed: CREATE (fn_emergencyBrake)-[:HAS]->(fn_emergencyBrake_in)
MATCH (fn_emergencyBrake:function {name: 'EmergencyBraking'})
MATCH (fn_emergencyBrake_in:function_input {name: 'objectDetection'})
CREATE (fn_emergencyBrake)-[:HAS]->(fn_emergencyBrake_in);
// Fixed: CREATE (fn_emergencyBrake)-[:HAS]->(fn_emergencyBrake_out)
MATCH (fn_emergencyBrake:function {name: 'EmergencyBraking'})
MATCH (fn_emergencyBrake_out:function_output {name: 'brakeActuation'})
CREATE (fn_emergencyBrake)-[:HAS]->(fn_emergencyBrake_out);

CREATE (fn_blindSpot:function {
    name: 'BlindSpotDetection',
    description: 'Detects vehicles in blind spots',
    label: 'Blind Spot Detection Function'
})
CREATE (fn_blindSpot_in:function_input {
    name: 'ultrasonicSensorData',
    description: 'Ultrasonic sensor data input',
    label: 'Ultrasonic Sensor Data'
})
CREATE (fn_blindSpot_out:function_output {
    name: 'visualAudibleAlert',
    description: 'Visual/audible alert output',
    label: 'Visual Audible Alert'
})
// Fixed: CREATE (fn_blindSpot)-[:HAS]->(fn_blindSpot_in)
MATCH (fn_blindSpot:function {name: 'BlindSpotDetection'})
MATCH (fn_blindSpot_in:function_input {name: 'ultrasonicSensorData'})
CREATE (fn_blindSpot)-[:HAS]->(fn_blindSpot_in);
// Fixed: CREATE (fn_blindSpot)-[:HAS]->(fn_blindSpot_out)
MATCH (fn_blindSpot:function {name: 'BlindSpotDetection'})
MATCH (fn_blindSpot_out:function_output {name: 'visualAudibleAlert'})
CREATE (fn_blindSpot)-[:HAS]->(fn_blindSpot_out);

// Brake System Functions
CREATE (fn_hydraulicBrake:function {
    name: 'HydraulicBraking',
    description: 'Applies hydraulic brake force',
    label: 'Hydraulic Braking Function'
})
CREATE (fn_hydraulicBrake_in:function_input {
    name: 'brakePedalForce',
    description: 'Brake pedal force input',
    label: 'Brake Pedal Force'
})
CREATE (fn_hydraulicBrake_out:function_output {
    name: 'frictionForce',
    description: 'Friction force output',
    label: 'Friction Force'
})
// Fixed: CREATE (fn_hydraulicBrake)-[:HAS]->(fn_hydraulicBrake_in)
MATCH (fn_hydraulicBrake:function {name: 'HydraulicBraking'})
MATCH (fn_hydraulicBrake_in:function_input {name: 'brakePedalForce'})
CREATE (fn_hydraulicBrake)-[:HAS]->(fn_hydraulicBrake_in);
// Fixed: CREATE (fn_hydraulicBrake)-[:HAS]->(fn_hydraulicBrake_out)
MATCH (fn_hydraulicBrake:function {name: 'HydraulicBraking'})
MATCH (fn_hydraulicBrake_out:function_output {name: 'frictionForce'})
CREATE (fn_hydraulicBrake)-[:HAS]->(fn_hydraulicBrake_out);

CREATE (fn_regenBrake:function {
    name: 'RegenerativeBraking',
    description: 'Recovers kinetic energy',
    label: 'Regenerative Braking Function'
})
CREATE (fn_regenBrake_in:function_input {
    name: 'kineticEnergy',
    description: 'Kinetic energy input',
    label: 'Kinetic Energy'
})
CREATE (fn_regenBrake_out:function_output {
    name: 'electricalEnergy',
    description: 'Electrical energy output',
    label: 'Electrical Energy'
})
// Fixed: CREATE (fn_regenBrake)-[:HAS]->(fn_regenBrake_in)
MATCH (fn_regenBrake:function {name: 'RegenerativeBraking'})
MATCH (fn_regenBrake_in:function_input {name: 'kineticEnergy'})
CREATE (fn_regenBrake)-[:HAS]->(fn_regenBrake_in);
// Fixed: CREATE (fn_regenBrake)-[:HAS]->(fn_regenBrake_out)
MATCH (fn_regenBrake:function {name: 'RegenerativeBraking'})
MATCH (fn_regenBrake_out:function_output {name: 'electricalEnergy'})
CREATE (fn_regenBrake)-[:HAS]->(fn_regenBrake_out);

CREATE (fn_absEbd:function {
    name: 'ABSEBDControl',
    description: 'Controls ABS and EBD systems',
    label: 'ABS EBD Control Function'
})
CREATE (fn_absEbd_in:function_input {
    name: 'wheelSpeed',
    description: 'Wheel speed input',
    label: 'Wheel Speed'
})
CREATE (fn_absEbd_out:function_output {
    name: 'modulatedBrakePressure',
    description: 'Modulated brake pressure output',
    label: 'Modulated Brake Pressure'
})
// Fixed: CREATE (fn_absEbd)-[:HAS]->(fn_absEbd_in)
MATCH (fn_absEbd:function {name: 'ABSEBDControl'})
MATCH (fn_absEbd_in:function_input {name: 'wheelSpeed'})
CREATE (fn_absEbd)-[:HAS]->(fn_absEbd_in);
// Fixed: CREATE (fn_absEbd)-[:HAS]->(fn_absEbd_out)
MATCH (fn_absEbd:function {name: 'ABSEBDControl'})
MATCH (fn_absEbd_out:function_output {name: 'modulatedBrakePressure'})
CREATE (fn_absEbd)-[:HAS]->(fn_absEbd_out);

CREATE (fn_brakeWear:function {
    name: 'BrakeWearMonitoring',
    description: 'Monitors brake pad wear',
    label: 'Brake Wear Monitoring Function'
})
CREATE (fn_brakeWear_in:function_input {
    name: 'padThicknessSensor',
    description: 'Pad thickness sensor input',
    label: 'Pad Thickness Sensor'
})
CREATE (fn_brakeWear_out:function_output {
    name: 'maintenanceAlert',
    description: 'Maintenance alert output',
    label: 'Maintenance Alert'
})
// Fixed: CREATE (fn_brakeWear)-[:HAS]->(fn_brakeWear_in)
MATCH (fn_brakeWear:function {name: 'BrakeWearMonitoring'})
MATCH (fn_brakeWear_in:function_input {name: 'padThicknessSensor'})
CREATE (fn_brakeWear)-[:HAS]->(fn_brakeWear_in);
// Fixed: CREATE (fn_brakeWear)-[:HAS]->(fn_brakeWear_out)
MATCH (fn_brakeWear:function {name: 'BrakeWearMonitoring'})
MATCH (fn_brakeWear_out:function_output {name: 'maintenanceAlert'})
CREATE (fn_brakeWear)-[:HAS]->(fn_brakeWear_out);

// ==========================
// Create Logical Architecture (Solutions)
// ==========================

CREATE (sol_overallSystem:solution {
    name: 'OverallVehicleSystem',
    description: 'Coordinates all vehicle systems, provides user interface, and ensures compliance and integration.',
    label: 'Overall Vehicle System'
})

CREATE (sol_energyStorage:solution {
    name: 'EnergyStorageAndManagement',
    description: 'Manages energy storage, battery health, and safety.',
    label: 'Energy Storage and Management'
})

CREATE (sol_powerConversion:solution {
    name: 'PowerConversionAndPropulsion',
    description: 'Converts electrical energy to mechanical torque for vehicle movement.',
    label: 'Power Conversion and Propulsion'
})

CREATE (sol_energyRecovery:solution {
    name: 'EnergyRecoveryAndBraking',
    description: 'Recovers kinetic energy during braking and provides safe deceleration.',
    label: 'Energy Recovery and Braking'
})

CREATE (sol_vehicleControl:solution {
    name: 'VehicleControlAndCoordination',
    description: 'Central logic for coordinating propulsion, braking, steering, and diagnostics.',
    label: 'Vehicle Control and Coordination'
})

CREATE (sol_thermalMgmt:solution {
    name: 'ThermalManagementSystem',
    description: 'Maintains optimal temperature for battery, power electronics, and cabin.',
    label: 'Thermal Management System'
})

CREATE (sol_stability:solution {
    name: 'StabilityAndSafety',
    description: 'Ensures vehicle stability, safety, and crash protection.',
    label: 'Stability and Safety'
})

CREATE (sol_adas:solution {
    name: 'AdvancedDriverAssistanceSystems',
    description: 'Supports semi-automated driving and advanced safety features.',
    label: 'Advanced Driver Assistance Systems'
})

CREATE (sol_auxiliary:solution {
    name: 'AuxiliaryAndSupportSystems',
    description: 'Provides charging, power conversion, and user information.',
    label: 'Auxiliary and Support Systems'
})

// ==========================
// Create Physical Architecture (Products)
// ==========================

CREATE (p_batteryPack:product {
    name: 'BatteryPack',
    description: 'High-voltage lithium-ion battery storing energy for propulsion and auxiliary systems.',
    label: 'Battery Pack'
})

CREATE (p_bmsECU:product {
    name: 'BatteryManagementSystemECU',
    description: 'Embedded controller for battery monitoring, balancing, and protection.',
    label: 'Battery Management System ECU'
})

CREATE (p_cellSensors:product {
    name: 'CellVoltageTempSensors',
    description: 'Distributed sensors measuring cell voltages and temperatures.',
    label: 'Cell Voltage Temp Sensors'
})

CREATE (p_inverter:product {
    name: 'MainInverter',
    description: 'Converts DC battery power to AC for the propulsion motor.',
    label: 'Main Inverter'
})

CREATE (p_motor:product {
    name: 'ElectricDriveMotor',
    description: 'Permanent magnet synchronous machine providing vehicle propulsion.',
    label: 'Electric Drive Motor'
})

CREATE (p_transmission:product {
    name: 'TransmissionGearbox',
    description: 'Single-speed reduction gearbox transferring torque to the wheels.',
    label: 'Transmission Gearbox'
})

CREATE (p_charger:product {
    name: 'OnBoardCharger',
    description: 'AC/DC converter for charging the high-voltage battery from external sources.',
    label: 'On Board Charger'
})

CREATE (p_dcConverter:product {
    name: 'DCDCConverter',
    description: 'Steps down high-voltage battery output to 12V for auxiliary systems.',
    label: 'DC DC Converter'
})

CREATE (p_vcu:product {
    name: 'VehicleControlUnit',
    description: 'Central logic controller for all vehicle systems and safety-critical coordination.',
    label: 'Vehicle Control Unit'
})

CREATE (p_thermalController:product {
    name: 'ThermalManagementController',
    description: 'Manages operation of pumps, valves, and HVAC for thermal regulation.',
    label: 'Thermal Management Controller'
})

CREATE (p_coolantPump:product {
    name: 'CoolantPump',
    description: 'Circulates coolant through battery, motor, inverter, and cabin heat exchangers.',
    label: 'Coolant Pump'
})

CREATE (p_batteryHeater:product {
    name: 'BatteryHeater',
    description: 'PTC element for heating battery during cold conditions.',
    label: 'Battery Heater'
})

CREATE (p_hvac:product {
    name: 'HVACUnit',
    description: 'Provides cabin heating and cooling, and supports battery thermal management.',
    label: 'HVAC Unit'
})

CREATE (p_wheelSensors:product {
    name: 'WheelSpeedSensors',
    description: 'Detects rotational speed of each wheel for ABS, ESP, and ADAS.',
    label: 'Wheel Speed Sensors'
})

CREATE (p_steeringSensor:product {
    name: 'SteeringAngleSensor',
    description: 'Measures steering wheel position for stability and ADAS functions.',
    label: 'Steering Angle Sensor'
})

CREATE (p_yawSensor:product {
    name: 'YawRateSensor',
    description: 'Measures vehicle rotational rate for ESP and ADAS.',
    label: 'Yaw Rate Sensor'
})

CREATE (p_brakeActuator:product {
    name: 'HydraulicBrakeActuator',
    description: 'Applies hydraulic pressure to wheel brakes based on driver and system input.',
    label: 'Hydraulic Brake Actuator'
})

CREATE (p_brakeSensor:product {
    name: 'BrakePedalSensor',
    description: 'Measures brake pedal position and force for brake blending and control.',
    label: 'Brake Pedal Sensor'
})

CREATE (p_regenController:product {
    name: 'RegenerativeBrakingController',
    description: 'Coordinates between hydraulic and regenerative braking for optimal energy recovery.',
    label: 'Regenerative Braking Controller'
})

CREATE (p_espECU:product {
    name: 'ABSESPECU',
    description: 'Controls anti-lock braking and electronic stability interventions.',
    label: 'ABS ESP ECU'
})

CREATE (p_adasECU:product {
    name: 'ADASECU',
    description: 'Processes sensor data and executes ADAS algorithms.',
    label: 'ADAS ECU'
})

CREATE (p_camera:product {
    name: 'FrontCamera',
    description: 'Forward-facing camera for lane keeping, object detection, and traffic sign recognition.',
    label: 'Front Camera'
})

CREATE (p_radar:product {
    name: 'RadarSensor',
    description: 'Long-range radar for adaptive cruise control and collision warning.',
    label: 'Radar Sensor'
})

CREATE (p_ultrasonics:product {
    name: 'UltrasonicSensors',
    description: 'Short-range sensors for parking assistance and blind spot detection.',
    label: 'Ultrasonic Sensors'
})

CREATE (p_lidar:product {
    name: 'LidarSensor',
    description: 'High-resolution 3D mapping for ADAS and emergency braking.',
    label: 'Lidar Sensor'
})

CREATE (p_headUnit:product {
    name: 'InfotainmentHeadUnit',
    description: 'Central display and user interface for vehicle information and controls.',
    label: 'Infotainment Head Unit'
})

CREATE (p_telematics:product {
    name: 'TelematicsControlUnit',
    description: 'Manages wireless connectivity, remote diagnostics, and OTA updates.',
    label: 'Telematics Control Unit'
})

CREATE (p_canBus:product {
    name: 'CANBusNetwork',
    description: 'Primary communication backbone for E/E systems.',
    label: 'CAN Bus Network'
})

CREATE (p_powerDist:product {
    name: 'HighVoltagePowerDistributionUnit',
    description: 'Manages and protects high voltage connections between battery, inverter, and charger.',
    label: 'High Voltage Power Distribution Unit'
})

// ==========================
// Create Attributes for Products
// ==========================

// Battery Pack Attributes
CREATE (attr_batteryType:attribute {
    name: 'type',
    value: 'NMC Lithium-ion',
    description: 'Battery cell chemistry type',
    label: 'Battery Type'
})
CREATE (attr_batteryCapacity:attribute {
    name: 'capacity',
    value: '100 kWh',
    description: 'Battery energy capacity',
    label: 'Battery Capacity'
})
CREATE (attr_batteryVoltage:attribute {
    name: 'nominalVoltage',
    value: '400 V',
    description: 'Battery nominal voltage',
    label: 'Battery Voltage'
})
CREATE (attr_batteryWeight:attribute {
    name: 'weight',
    value: '550 kg',
    description: 'Battery weight',
    label: 'Battery Weight'
})
CREATE (attr_batteryCooling:attribute {
    name: 'cooling',
    value: 'Liquid',
    description: 'Battery cooling type',
    label: 'Battery Cooling'
})
CREATE (attr_batteryEnclosure:attribute {
    name: 'enclosure',
    value: 'Aluminum crash-protected',
    description: 'Battery enclosure type',
    label: 'Battery Enclosure'
})

// Fixed: CREATE (p_batteryPack)-[:HAS]->(attr_batteryType)
MATCH (p_batteryPack:product {name: 'BatteryPack'})
MATCH (attr_batteryType:attribute {name: 'type'})
CREATE (p_batteryPack)-[:HAS]->(attr_batteryType);
// Fixed: CREATE (p_batteryPack)-[:HAS]->(attr_batteryCapacity)
MATCH (p_batteryPack:product {name: 'BatteryPack'})
MATCH (attr_batteryCapacity:attribute {name: 'capacity'})
CREATE (p_batteryPack)-[:HAS]->(attr_batteryCapacity);
// Fixed: CREATE (p_batteryPack)-[:HAS]->(attr_batteryVoltage)
MATCH (p_batteryPack:product {name: 'BatteryPack'})
MATCH (attr_batteryVoltage:attribute {name: 'nominalVoltage'})
CREATE (p_batteryPack)-[:HAS]->(attr_batteryVoltage);
// Fixed: CREATE (p_batteryPack)-[:HAS]->(attr_batteryWeight)
MATCH (p_batteryPack:product {name: 'BatteryPack'})
MATCH (attr_batteryWeight:attribute {name: 'weight'})
CREATE (p_batteryPack)-[:HAS]->(attr_batteryWeight);
// Fixed: CREATE (p_batteryPack)-[:HAS]->(attr_batteryCooling)
MATCH (p_batteryPack:product {name: 'BatteryPack'})
MATCH (attr_batteryCooling:attribute {name: 'cooling'})
CREATE (p_batteryPack)-[:HAS]->(attr_batteryCooling);
// Fixed: CREATE (p_batteryPack)-[:HAS]->(attr_batteryEnclosure)
MATCH (p_batteryPack:product {name: 'BatteryPack'})
MATCH (attr_batteryEnclosure:attribute {name: 'enclosure'})
CREATE (p_batteryPack)-[:HAS]->(attr_batteryEnclosure);

// BMS ECU Attributes
CREATE (attr_bmsProcessor:attribute {
    name: 'processor',
    value: 'ARM Cortex-M7',
    description: 'BMS processor type',
    label: 'BMS Processor'
})
CREATE (attr_bmsASIL:attribute {
    name: 'ASIL',
    value: 'D',
    description: 'ASIL safety level',
    label: 'BMS ASIL'
})
CREATE (attr_bmsVoltageRange:attribute {
    name: 'voltageRange',
    value: '9-32 V',
    description: 'BMS operating voltage range',
    label: 'BMS Voltage Range'
})
CREATE (attr_bmsComm:attribute {
    name: 'communication',
    value: 'CAN FD, LIN',
    description: 'BMS communication protocols',
    label: 'BMS Communication'
})
CREATE (attr_bmsPower:attribute {
    name: 'powerConsumption',
    value: '4 W',
    description: 'BMS power consumption',
    label: 'BMS Power Consumption'
})

// Fixed: CREATE (p_bmsECU)-[:HAS]->(attr_bmsProcessor)
MATCH (p_bmsECU:product {name: 'BatteryManagementSystemECU'})
MATCH (attr_bmsProcessor:attribute {name: 'processor'})
CREATE (p_bmsECU)-[:HAS]->(attr_bmsProcessor);
// Fixed: CREATE (p_bmsECU)-[:HAS]->(attr_bmsASIL)
MATCH (p_bmsECU:product {name: 'BatteryManagementSystemECU'})
MATCH (attr_bmsASIL:attribute {name: 'ASIL'})
CREATE (p_bmsECU)-[:HAS]->(attr_bmsASIL);
// Fixed: CREATE (p_bmsECU)-[:HAS]->(attr_bmsVoltageRange)
MATCH (p_bmsECU:product {name: 'BatteryManagementSystemECU'})
MATCH (attr_bmsVoltageRange:attribute {name: 'voltageRange'})
CREATE (p_bmsECU)-[:HAS]->(attr_bmsVoltageRange);
// Fixed: CREATE (p_bmsECU)-[:HAS]->(attr_bmsComm)
MATCH (p_bmsECU:product {name: 'BatteryManagementSystemECU'})
MATCH (attr_bmsComm:attribute {name: 'communication'})
CREATE (p_bmsECU)-[:HAS]->(attr_bmsComm);
// Fixed: CREATE (p_bmsECU)-[:HAS]->(attr_bmsPower)
MATCH (p_bmsECU:product {name: 'BatteryManagementSystemECU'})
MATCH (attr_bmsPower:attribute {name: 'powerConsumption'})
CREATE (p_bmsECU)-[:HAS]->(attr_bmsPower);

// Cell Sensors Attributes
CREATE (attr_sensorAccuracy:attribute {
    name: 'accuracy',
    value: '±1 mV (voltage), ±1°C (temperature)',
    description: 'Sensor accuracy specifications',
    label: 'Sensor Accuracy'
})
CREATE (attr_sensorInterface:attribute {
    name: 'interface',
    value: 'SPI',
    description: 'Sensor communication interface',
    label: 'Sensor Interface'
})
CREATE (attr_sensorQuantity:attribute {
    name: 'quantity',
    value: '96 (voltage), 24 (temperature)',
    description: 'Number of sensors',
    label: 'Sensor Quantity'
})

// Fixed: CREATE (p_cellSensors)-[:HAS]->(attr_sensorAccuracy)
MATCH (p_cellSensors:product {name: 'CellVoltageTempSensors'})
MATCH (attr_sensorAccuracy:attribute {name: 'accuracy'})
CREATE (p_cellSensors)-[:HAS]->(attr_sensorAccuracy);
// Fixed: CREATE (p_cellSensors)-[:HAS]->(attr_sensorInterface)
MATCH (p_cellSensors:product {name: 'CellVoltageTempSensors'})
MATCH (attr_sensorInterface:attribute {name: 'interface'})
CREATE (p_cellSensors)-[:HAS]->(attr_sensorInterface);
// Fixed: CREATE (p_cellSensors)-[:HAS]->(attr_sensorQuantity)
MATCH (p_cellSensors:product {name: 'CellVoltageTempSensors'})
MATCH (attr_sensorQuantity:attribute {name: 'quantity'})
CREATE (p_cellSensors)-[:HAS]->(attr_sensorQuantity);

// Main Inverter Attributes
CREATE (attr_inverterType:attribute {
    name: 'type',
    value: 'SiC MOSFET',
    description: 'Inverter semiconductor type',
    label: 'Inverter Type'
})
CREATE (attr_inverterPeakPower:attribute {
    name: 'peakPower',
    value: '180 kW',
    description: 'Inverter peak power rating',
    label: 'Inverter Peak Power'
})
CREATE (attr_inverterEfficiency:attribute {
    name: 'efficiency',
    value: '98%',
    description: 'Inverter efficiency',
    label: 'Inverter Efficiency'
})
CREATE (attr_inverterCooling:attribute {
    name: 'cooling',
    value: 'Liquid',
    description: 'Inverter cooling type',
    label: 'Inverter Cooling'
})

// Fixed: CREATE (p_inverter)-[:HAS]->(attr_inverterType)
MATCH (p_inverter:product {name: 'MainInverter'})
MATCH (attr_inverterType:attribute {name: 'type'})
CREATE (p_inverter)-[:HAS]->(attr_inverterType);
// Fixed: CREATE (p_inverter)-[:HAS]->(attr_inverterPeakPower)
MATCH (p_inverter:product {name: 'MainInverter'})
MATCH (attr_inverterPeakPower:attribute {name: 'peakPower'})
CREATE (p_inverter)-[:HAS]->(attr_inverterPeakPower);
// Fixed: CREATE (p_inverter)-[:HAS]->(attr_inverterEfficiency)
MATCH (p_inverter:product {name: 'MainInverter'})
MATCH (attr_inverterEfficiency:attribute {name: 'efficiency'})
CREATE (p_inverter)-[:HAS]->(attr_inverterEfficiency);
// Fixed: CREATE (p_inverter)-[:HAS]->(attr_inverterCooling)
MATCH (p_inverter:product {name: 'MainInverter'})
MATCH (attr_inverterCooling:attribute {name: 'cooling'})
CREATE (p_inverter)-[:HAS]->(attr_inverterCooling);

// Electric Drive Motor Attributes
CREATE (attr_motorPeakPower:attribute {
    name: 'peakPower',
    value: '150 kW',
    description: 'Motor peak power rating',
    label: 'Motor Peak Power'
})
CREATE (attr_motorMaxTorque:attribute {
    name: 'maxTorque',
    value: '350 Nm',
    description: 'Motor maximum torque',
    label: 'Motor Max Torque'
})
CREATE (attr_motorWeight:attribute {
    name: 'weight',
    value: '80 kg',
    description: 'Motor weight',
    label: 'Motor Weight'
})
CREATE (attr_motorCooling:attribute {
    name: 'cooling',
    value: 'Oil',
    description: 'Motor cooling type',
    label: 'Motor Cooling'
})

// Fixed: CREATE (p_motor)-[:HAS]->(attr_motorPeakPower)
MATCH (p_motor:product {name: 'ElectricDriveMotor'})
MATCH (attr_motorPeakPower:attribute {name: 'peakPower'})
CREATE (p_motor)-[:HAS]->(attr_motorPeakPower);
// Fixed: CREATE (p_motor)-[:HAS]->(attr_motorMaxTorque)
MATCH (p_motor:product {name: 'ElectricDriveMotor'})
MATCH (attr_motorMaxTorque:attribute {name: 'maxTorque'})
CREATE (p_motor)-[:HAS]->(attr_motorMaxTorque);
// Fixed: CREATE (p_motor)-[:HAS]->(attr_motorWeight)
MATCH (p_motor:product {name: 'ElectricDriveMotor'})
MATCH (attr_motorWeight:attribute {name: 'weight'})
CREATE (p_motor)-[:HAS]->(attr_motorWeight);
// Fixed: CREATE (p_motor)-[:HAS]->(attr_motorCooling)
MATCH (p_motor:product {name: 'ElectricDriveMotor'})
MATCH (attr_motorCooling:attribute {name: 'cooling'})
CREATE (p_motor)-[:HAS]->(attr_motorCooling);

// Transmission Gearbox Attributes
CREATE (attr_gearRatio:attribute {
    name: 'gearRatio',
    value: '9.5:1',
    description: 'Gear reduction ratio',
    label: 'Gear Ratio'
})
CREATE (attr_gearEfficiency:attribute {
    name: 'efficiency',
    value: '97%',
    description: 'Gearbox efficiency',
    label: 'Gear Efficiency'
})
CREATE (attr_gearWeight:attribute {
    name: 'weight',
    value: '25 kg',
    description: 'Gearbox weight',
    label: 'Gear Weight'
})

// Fixed: CREATE (p_transmission)-[:HAS]->(attr_gearRatio)
MATCH (p_transmission:product {name: 'TransmissionGearbox'})
MATCH (attr_gearRatio:attribute {name: 'gearRatio'})
CREATE (p_transmission)-[:HAS]->(attr_gearRatio);
// Fixed: CREATE (p_transmission)-[:HAS]->(attr_gearEfficiency)
MATCH (p_transmission:product {name: 'TransmissionGearbox'})
MATCH (attr_gearEfficiency:attribute {name: 'efficiency'})
CREATE (p_transmission)-[:HAS]->(attr_gearEfficiency);
// Fixed: CREATE (p_transmission)-[:HAS]->(attr_gearWeight)
MATCH (p_transmission:product {name: 'TransmissionGearbox'})
MATCH (attr_gearWeight:attribute {name: 'weight'})
CREATE (p_transmission)-[:HAS]->(attr_gearWeight);

// On Board Charger Attributes
CREATE (attr_chargerInputVoltage:attribute {
    name: 'inputVoltage',
    value: '110-240V AC',
    description: 'Charger input voltage range',
    label: 'Charger Input Voltage'
})
CREATE (attr_chargerOutputPower:attribute {
    name: 'outputPower',
    value: '11 kW',
    description: 'Charger output power',
    label: 'Charger Output Power'
})
CREATE (attr_chargerEfficiency:attribute {
    name: 'efficiency',
    value: '94%',
    description: 'Charger efficiency',
    label: 'Charger Efficiency'
})
CREATE (attr_chargerWeight:attribute {
    name: 'weight',
    value: '8 kg',
    description: 'Charger weight',
    label: 'Charger Weight'
})

// Fixed: CREATE (p_charger)-[:HAS]->(attr_chargerInputVoltage)
MATCH (p_charger:product {name: 'OnBoardCharger'})
MATCH (attr_chargerInputVoltage:attribute {name: 'inputVoltage'})
CREATE (p_charger)-[:HAS]->(attr_chargerInputVoltage);
// Fixed: CREATE (p_charger)-[:HAS]->(attr_chargerOutputPower)
MATCH (p_charger:product {name: 'OnBoardCharger'})
MATCH (attr_chargerOutputPower:attribute {name: 'outputPower'})
CREATE (p_charger)-[:HAS]->(attr_chargerOutputPower);
// Fixed: CREATE (p_charger)-[:HAS]->(attr_chargerEfficiency)
MATCH (p_charger:product {name: 'OnBoardCharger'})
MATCH (attr_chargerEfficiency:attribute {name: 'efficiency'})
CREATE (p_charger)-[:HAS]->(attr_chargerEfficiency);
// Fixed: CREATE (p_charger)-[:HAS]->(attr_chargerWeight)
MATCH (p_charger:product {name: 'OnBoardCharger'})
MATCH (attr_chargerWeight:attribute {name: 'weight'})
CREATE (p_charger)-[:HAS]->(attr_chargerWeight);

// DC DC Converter Attributes
CREATE (attr_dcInputVoltage:attribute {
    name: 'inputVoltage',
    value: '250-430 V',
    description: 'DC converter input voltage range',
    label: 'DC Input Voltage'
})
CREATE (attr_dcOutputVoltage:attribute {
    name: 'outputVoltage',
    value: '12 V',
    description: 'DC converter output voltage',
    label: 'DC Output Voltage'
})
CREATE (attr_dcMaxPower:attribute {
    name: 'maxPower',
    value: '3 kW',
    description: 'DC converter maximum power',
    label: 'DC Max Power'
})
CREATE (attr_dcEfficiency:attribute {
    name: 'efficiency',
    value: '95%',
    description: 'DC converter efficiency',
    label: 'DC Efficiency'
})

// Fixed: CREATE (p_dcConverter)-[:HAS]->(attr_dcInputVoltage)
MATCH (p_dcConverter:product {name: 'DCDCConverter'})
MATCH (attr_dcInputVoltage:attribute {name: 'inputVoltage'})
CREATE (p_dcConverter)-[:HAS]->(attr_dcInputVoltage);
// Fixed: CREATE (p_dcConverter)-[:HAS]->(attr_dcOutputVoltage)
MATCH (p_dcConverter:product {name: 'DCDCConverter'})
MATCH (attr_dcOutputVoltage:attribute {name: 'outputVoltage'})
CREATE (p_dcConverter)-[:HAS]->(attr_dcOutputVoltage);
// Fixed: CREATE (p_dcConverter)-[:HAS]->(attr_dcMaxPower)
MATCH (p_dcConverter:product {name: 'DCDCConverter'})
MATCH (attr_dcMaxPower:attribute {name: 'maxPower'})
CREATE (p_dcConverter)-[:HAS]->(attr_dcMaxPower);
// Fixed: CREATE (p_dcConverter)-[:HAS]->(attr_dcEfficiency)
MATCH (p_dcConverter:product {name: 'DCDCConverter'})
MATCH (attr_dcEfficiency:attribute {name: 'efficiency'})
CREATE (p_dcConverter)-[:HAS]->(attr_dcEfficiency);

// Vehicle Control Unit Attributes
CREATE (attr_vcuProcessor:attribute {
    name: 'processor',
    value: 'Infineon AURIX',
    description: 'VCU processor type',
    label: 'VCU Processor'
})
CREATE (attr_vcuASIL:attribute {
    name: 'ASIL',
    value: 'D',
    description: 'VCU ASIL safety level',
    label: 'VCU ASIL'
})
CREATE (attr_vcuComm:attribute {
    name: 'communication',
    value: 'CAN FD, Ethernet',
    description: 'VCU communication protocols',
    label: 'VCU Communication'
})
CREATE (attr_vcuPower:attribute {
    name: 'power',
    value: '10 W',
    description: 'VCU power consumption',
    label: 'VCU Power'
})

// Fixed: CREATE (p_vcu)-[:HAS]->(attr_vcuProcessor)
MATCH (p_vcu:product {name: 'VehicleControlUnit'})
MATCH (attr_vcuProcessor:attribute {name: 'processor'})
CREATE (p_vcu)-[:HAS]->(attr_vcuProcessor);
// Fixed: CREATE (p_vcu)-[:HAS]->(attr_vcuASIL)
MATCH (p_vcu:product {name: 'VehicleControlUnit'})
MATCH (attr_vcuASIL:attribute {name: 'ASIL'})
CREATE (p_vcu)-[:HAS]->(attr_vcuASIL);
// Fixed: CREATE (p_vcu)-[:HAS]->(attr_vcuComm)
MATCH (p_vcu:product {name: 'VehicleControlUnit'})
MATCH (attr_vcuComm:attribute {name: 'communication'})
CREATE (p_vcu)-[:HAS]->(attr_vcuComm);
// Fixed: CREATE (p_vcu)-[:HAS]->(attr_vcuPower)
MATCH (p_vcu:product {name: 'VehicleControlUnit'})
MATCH (attr_vcuPower:attribute {name: 'power'})
CREATE (p_vcu)-[:HAS]->(attr_vcuPower);

// Thermal Management Controller Attributes
CREATE (attr_thermalProcessor:attribute {
    name: 'processor',
    value: 'ARM Cortex-M4',
    description: 'Thermal controller processor type',
    label: 'Thermal Processor'
})
CREATE (attr_thermalComm:attribute {
    name: 'communication',
    value: 'CAN, LIN',
    description: 'Thermal controller communication protocols',
    label: 'Thermal Communication'
})
CREATE (attr_thermalPower:attribute {
    name: 'power',
    value: '3 W',
    description: 'Thermal controller power consumption',
    label: 'Thermal Power'
})

// Fixed: CREATE (p_thermalController)-[:HAS]->(attr_thermalProcessor)
MATCH (p_thermalController:product {name: 'ThermalManagementController'})
MATCH (attr_thermalProcessor:attribute {name: 'processor'})
CREATE (p_thermalController)-[:HAS]->(attr_thermalProcessor);
// Fixed: CREATE (p_thermalController)-[:HAS]->(attr_thermalComm)
MATCH (p_thermalController:product {name: 'ThermalManagementController'})
MATCH (attr_thermalComm:attribute {name: 'communication'})
CREATE (p_thermalController)-[:HAS]->(attr_thermalComm);
// Fixed: CREATE (p_thermalController)-[:HAS]->(attr_thermalPower)
MATCH (p_thermalController:product {name: 'ThermalManagementController'})
MATCH (attr_thermalPower:attribute {name: 'power'})
CREATE (p_thermalController)-[:HAS]->(attr_thermalPower);

// Coolant Pump Attributes
CREATE (attr_pumpType:attribute {
    name: 'type',
    value: 'Brushless DC',
    description: 'Pump type',
    label: 'Pump Type'
})
CREATE (attr_pumpMaxFlow:attribute {
    name: 'maxFlow',
    value: '10 L/min',
    description: 'Pump maximum flow rate',
    label: 'Pump Max Flow'
})
CREATE (attr_pumpPower:attribute {
    name: 'power',
    value: '120 W',
    description: 'Pump power consumption',
    label: 'Pump Power'
})

// Fixed: CREATE (p_coolantPump)-[:HAS]->(attr_pumpType)
MATCH (p_coolantPump:product {name: 'CoolantPump'})
MATCH (attr_pumpType:attribute {name: 'type'})
CREATE (p_coolantPump)-[:HAS]->(attr_pumpType);
// Fixed: CREATE (p_coolantPump)-[:HAS]->(attr_pumpMaxFlow)
MATCH (p_coolantPump:product {name: 'CoolantPump'})
MATCH (attr_pumpMaxFlow:attribute {name: 'maxFlow'})
CREATE (p_coolantPump)-[:HAS]->(attr_pumpMaxFlow);
// Fixed: CREATE (p_coolantPump)-[:HAS]->(attr_pumpPower)
MATCH (p_coolantPump:product {name: 'CoolantPump'})
MATCH (attr_pumpPower:attribute {name: 'power'})
CREATE (p_coolantPump)-[:HAS]->(attr_pumpPower);

// Battery Heater Attributes
CREATE (attr_heaterPower:attribute {
    name: 'power',
    value: '2 kW',
    description: 'Heater power rating',
    label: 'Heater Power'
})
CREATE (attr_heaterVoltage:attribute {
    name: 'voltage',
    value: '400 V',
    description: 'Heater voltage',
    label: 'Heater Voltage'
})
CREATE (attr_heaterControl:attribute {
    name: 'control',
    value: 'PWM',
    description: 'Heater control method',
    label: 'Heater Control'
})

// Fixed: CREATE (p_batteryHeater)-[:HAS]->(attr_heaterPower)
MATCH (p_batteryHeater:product {name: 'BatteryHeater'})
MATCH (attr_heaterPower:attribute {name: 'power'})
CREATE (p_batteryHeater)-[:HAS]->(attr_heaterPower);
// Fixed: CREATE (p_batteryHeater)-[:HAS]->(attr_heaterVoltage)
MATCH (p_batteryHeater:product {name: 'BatteryHeater'})
MATCH (attr_heaterVoltage:attribute {name: 'voltage'})
CREATE (p_batteryHeater)-[:HAS]->(attr_heaterVoltage);
// Fixed: CREATE (p_batteryHeater)-[:HAS]->(attr_heaterControl)
MATCH (p_batteryHeater:product {name: 'BatteryHeater'})
MATCH (attr_heaterControl:attribute {name: 'control'})
CREATE (p_batteryHeater)-[:HAS]->(attr_heaterControl);

// HVAC Unit Attributes
CREATE (attr_hvacType:attribute {
    name: 'type',
    value: 'Heat pump',
    description: 'HVAC type',
    label: 'HVAC Type'
})
CREATE (attr_hvacCapacity:attribute {
    name: 'capacity',
    value: '5 kW cooling / 6 kW heating',
    description: 'HVAC capacity',
    label: 'HVAC Capacity'
})
CREATE (attr_hvacRefrigerant:attribute {
    name: 'refrigerant',
    value: 'R1234yf',
    description: 'HVAC refrigerant type',
    label: 'HVAC Refrigerant'
})

// Fixed: CREATE (p_hvac)-[:HAS]->(attr_hvacType)
MATCH (p_hvac:product {name: 'HVACUnit'})
MATCH (attr_hvacType:attribute {name: 'type'})
CREATE (p_hvac)-[:HAS]->(attr_hvacType);
// Fixed: CREATE (p_hvac)-[:HAS]->(attr_hvacCapacity)
MATCH (p_hvac:product {name: 'HVACUnit'})
MATCH (attr_hvacCapacity:attribute {name: 'capacity'})
CREATE (p_hvac)-[:HAS]->(attr_hvacCapacity);
// Fixed: CREATE (p_hvac)-[:HAS]->(attr_hvacRefrigerant)
MATCH (p_hvac:product {name: 'HVACUnit'})
MATCH (attr_hvacRefrigerant:attribute {name: 'refrigerant'})
CREATE (p_hvac)-[:HAS]->(attr_hvacRefrigerant);

// Wheel Speed Sensors Attributes
CREATE (attr_wheelSensorType:attribute {
    name: 'type',
    value: 'Hall effect',
    description: 'Wheel sensor type',
    label: 'Wheel Sensor Type'
})
CREATE (attr_wheelSensorAccuracy:attribute {
    name: 'accuracy',
    value: '±0.1 km/h',
    description: 'Wheel sensor accuracy',
    label: 'Wheel Sensor Accuracy'
})
CREATE (attr_wheelSensorQuantity:attribute {
    name: 'quantity',
    value: '4',
    description: 'Number of wheel sensors',
    label: 'Wheel Sensor Quantity'
})

// Fixed: CREATE (p_wheelSensors)-[:HAS]->(attr_wheelSensorType)
MATCH (p_wheelSensors:product {name: 'WheelSpeedSensors'})
MATCH (attr_wheelSensorType:attribute {name: 'type'})
CREATE (p_wheelSensors)-[:HAS]->(attr_wheelSensorType);
// Fixed: CREATE (p_wheelSensors)-[:HAS]->(attr_wheelSensorAccuracy)
MATCH (p_wheelSensors:product {name: 'WheelSpeedSensors'})
MATCH (attr_wheelSensorAccuracy:attribute {name: 'accuracy'})
CREATE (p_wheelSensors)-[:HAS]->(attr_wheelSensorAccuracy);
// Fixed: CREATE (p_wheelSensors)-[:HAS]->(attr_wheelSensorQuantity)
MATCH (p_wheelSensors:product {name: 'WheelSpeedSensors'})
MATCH (attr_wheelSensorQuantity:attribute {name: 'quantity'})
CREATE (p_wheelSensors)-[:HAS]->(attr_wheelSensorQuantity);

// Steering Angle Sensor Attributes
CREATE (attr_steeringRange:attribute {
    name: 'range',
    value: '±720°',
    description: 'Steering sensor range',
    label: 'Steering Range'
})
CREATE (attr_steeringResolution:attribute {
    name: 'resolution',
    value: '0.1°',
    description: 'Steering sensor resolution',
    label: 'Steering Resolution'
})

// Fixed: CREATE (p_steeringSensor)-[:HAS]->(attr_steeringRange)
MATCH (p_steeringSensor:product {name: 'SteeringAngleSensor'})
MATCH (attr_steeringRange:attribute {name: 'range'})
CREATE (p_steeringSensor)-[:HAS]->(attr_steeringRange);
// Fixed: CREATE (p_steeringSensor)-[:HAS]->(attr_steeringResolution)
MATCH (p_steeringSensor:product {name: 'SteeringAngleSensor'})
MATCH (attr_steeringResolution:attribute {name: 'resolution'})
CREATE (p_steeringSensor)-[:HAS]->(attr_steeringResolution);

// Yaw Rate Sensor Attributes
CREATE (attr_yawRange:attribute {
    name: 'range',
    value: '±250°/s',
    description: 'Yaw sensor range',
    label: 'Yaw Range'
})
CREATE (attr_yawAccuracy:attribute {
    name: 'accuracy',
    value: '±0.5°/s',
    description: 'Yaw sensor accuracy',
    label: 'Yaw Accuracy'
})

// Fixed: CREATE (p_yawSensor)-[:HAS]->(attr_yawRange)
MATCH (p_yawSensor:product {name: 'YawRateSensor'})
MATCH (attr_yawRange:attribute {name: 'range'})
CREATE (p_yawSensor)-[:HAS]->(attr_yawRange);
// Fixed: CREATE (p_yawSensor)-[:HAS]->(attr_yawAccuracy)
MATCH (p_yawSensor:product {name: 'YawRateSensor'})
MATCH (attr_yawAccuracy:attribute {name: 'accuracy'})
CREATE (p_yawSensor)-[:HAS]->(attr_yawAccuracy);

// Hydraulic Brake Actuator Attributes
CREATE (attr_brakeMaxPressure:attribute {
    name: 'maxPressure',
    value: '200 bar',
    description: 'Brake maximum pressure',
    label: 'Brake Max Pressure'
})
CREATE (attr_brakeResponseTime:attribute {
    name: 'responseTime',
    value: '10 ms',
    description: 'Brake response time',
    label: 'Brake Response Time'
})

// Fixed: CREATE (p_brakeActuator)-[:HAS]->(attr_brakeMaxPressure)
MATCH (p_brakeActuator:product {name: 'HydraulicBrakeActuator'})
MATCH (attr_brakeMaxPressure:attribute {name: 'maxPressure'})
CREATE (p_brakeActuator)-[:HAS]->(attr_brakeMaxPressure);
// Fixed: CREATE (p_brakeActuator)-[:HAS]->(attr_brakeResponseTime)
MATCH (p_brakeActuator:product {name: 'HydraulicBrakeActuator'})
MATCH (attr_brakeResponseTime:attribute {name: 'responseTime'})
CREATE (p_brakeActuator)-[:HAS]->(attr_brakeResponseTime);

// Brake Pedal Sensor Attributes
CREATE (attr_brakeSensorRange:attribute {
    name: 'range',
    value: '0-100%',
    description: 'Brake sensor range',
    label: 'Brake Sensor Range'
})
CREATE (attr_brakeSensorAccuracy:attribute {
    name: 'accuracy',
    value: '±1%',
    description: 'Brake sensor accuracy',
    label: 'Brake Sensor Accuracy'
})

// Fixed: CREATE (p_brakeSensor)-[:HAS]->(attr_brakeSensorRange)
MATCH (p_brakeSensor:product {name: 'BrakePedalSensor'})
MATCH (attr_brakeSensorRange:attribute {name: 'range'})
CREATE (p_brakeSensor)-[:HAS]->(attr_brakeSensorRange);
// Fixed: CREATE (p_brakeSensor)-[:HAS]->(attr_brakeSensorAccuracy)
MATCH (p_brakeSensor:product {name: 'BrakePedalSensor'})
MATCH (attr_brakeSensorAccuracy:attribute {name: 'accuracy'})
CREATE (p_brakeSensor)-[:HAS]->(attr_brakeSensorAccuracy);

// Regenerative Braking Controller Attributes
CREATE (attr_regenProcessor:attribute {
    name: 'processor',
    value: 'ARM Cortex-M0',
    description: 'Regen controller processor type',
    label: 'Regen Processor'
})
CREATE (attr_regenComm:attribute {
    name: 'communication',
    value: 'CAN',
    description: 'Regen controller communication protocol',
    label: 'Regen Communication'
})

// Fixed: CREATE (p_regenController)-[:HAS]->(attr_regenProcessor)
MATCH (p_regenController:product {name: 'RegenerativeBrakingController'})
MATCH (attr_regenProcessor:attribute {name: 'processor'})
CREATE (p_regenController)-[:HAS]->(attr_regenProcessor);
// Fixed: CREATE (p_regenController)-[:HAS]->(attr_regenComm)
MATCH (p_regenController:product {name: 'RegenerativeBrakingController'})
MATCH (attr_regenComm:attribute {name: 'communication'})
CREATE (p_regenController)-[:HAS]->(attr_regenComm);

// ABS ESP ECU Attributes
CREATE (attr_espASIL:attribute {
    name: 'ASIL',
    value: 'C',
    description: 'ESP ASIL safety level',
    label: 'ESP ASIL'
})
CREATE (attr_espProcessor:attribute {
    name: 'processor',
    value: 'Freescale S12',
    description: 'ESP processor type',
    label: 'ESP Processor'
})
CREATE (attr_espComm:attribute {
    name: 'communication',
    value: 'CAN',
    description: 'ESP communication protocol',
    label: 'ESP Communication'
})

// Fixed: CREATE (p_espECU)-[:HAS]->(attr_espASIL)
MATCH (p_espECU:product {name: 'ABSESPECU'})
MATCH (attr_espASIL:attribute {name: 'ASIL'})
CREATE (p_espECU)-[:HAS]->(attr_espASIL);
// Fixed: CREATE (p_espECU)-[:HAS]->(attr_espProcessor)
MATCH (p_espECU:product {name: 'ABSESPECU'})
MATCH (attr_espProcessor:attribute {name: 'processor'})
CREATE (p_espECU)-[:HAS]->(attr_espProcessor);
// Fixed: CREATE (p_espECU)-[:HAS]->(attr_espComm)
MATCH (p_espECU:product {name: 'ABSESPECU'})
MATCH (attr_espComm:attribute {name: 'communication'})
CREATE (p_espECU)-[:HAS]->(attr_espComm);

// ADAS ECU Attributes
CREATE (attr_adasProcessor:attribute {
    name: 'processor',
    value: 'NVIDIA Xavier',
    description: 'ADAS processor type',
    label: 'ADAS Processor'
})
CREATE (attr_adasASIL:attribute {
    name: 'ASIL',
    value: 'B',
    description: 'ADAS ASIL safety level',
    label: 'ADAS ASIL'
})
CREATE (attr_adasComm:attribute {
    name: 'communication',
    value: 'Ethernet, CAN',
    description: 'ADAS communication protocols',
    label: 'ADAS Communication'
})

// Fixed: CREATE (p_adasECU)-[:HAS]->(attr_adasProcessor)
MATCH (p_adasECU:product {name: 'ADASECU'})
MATCH (attr_adasProcessor:attribute {name: 'processor'})
CREATE (p_adasECU)-[:HAS]->(attr_adasProcessor);
// Fixed: CREATE (p_adasECU)-[:HAS]->(attr_adasASIL)
MATCH (p_adasECU:product {name: 'ADASECU'})
MATCH (attr_adasASIL:attribute {name: 'ASIL'})
CREATE (p_adasECU)-[:HAS]->(attr_adasASIL);
// Fixed: CREATE (p_adasECU)-[:HAS]->(attr_adasComm)
MATCH (p_adasECU:product {name: 'ADASECU'})
MATCH (attr_adasComm:attribute {name: 'communication'})
CREATE (p_adasECU)-[:HAS]->(attr_adasComm);

// Front Camera Attributes
CREATE (attr_cameraResolution:attribute {
    name: 'resolution',
    value: '1920x1080',
    description: 'Camera resolution',
    label: 'Camera Resolution'
})
CREATE (attr_cameraFrameRate:attribute {
    name: 'frameRate',
    value: '60 fps',
    description: 'Camera frame rate',
    label: 'Camera Frame Rate'
})
CREATE (attr_cameraFOV:attribute {
    name: 'fieldOfView',
    value: '120°',
    description: 'Camera field of view',
    label: 'Camera FOV'
})

// Fixed: CREATE (p_camera)-[:HAS]->(attr_cameraResolution)
MATCH (p_camera:product {name: 'FrontCamera'})
MATCH (attr_cameraResolution:attribute {name: 'resolution'})
CREATE (p_camera)-[:HAS]->(attr_cameraResolution);
// Fixed: CREATE (p_camera)-[:HAS]->(attr_cameraFrameRate)
MATCH (p_camera:product {name: 'FrontCamera'})
MATCH (attr_cameraFrameRate:attribute {name: 'frameRate'})
CREATE (p_camera)-[:HAS]->(attr_cameraFrameRate);
// Fixed: CREATE (p_camera)-[:HAS]->(attr_cameraFOV)
MATCH (p_camera:product {name: 'FrontCamera'})
MATCH (attr_cameraFOV:attribute {name: 'fieldOfView'})
CREATE (p_camera)-[:HAS]->(attr_cameraFOV);

// Radar Sensor Attributes
CREATE (attr_radarRange:attribute {
    name: 'range',
    value: '200 m',
    description: 'Radar range',
    label: 'Radar Range'
})
CREATE (attr_radarFrequency:attribute {
    name: 'frequency',
    value: '77 GHz',
    description: 'Radar frequency',
    label: 'Radar Frequency'
})
CREATE (attr_radarFOV:attribute {
    name: 'fieldOfView',
    value: '20°',
    description: 'Radar field of view',
    label: 'Radar FOV'
})

// Fixed: CREATE (p_radar)-[:HAS]->(attr_radarRange)
MATCH (p_radar:product {name: 'RadarSensor'})
MATCH (attr_radarRange:attribute {name: 'range'})
CREATE (p_radar)-[:HAS]->(attr_radarRange);
// Fixed: CREATE (p_radar)-[:HAS]->(attr_radarFrequency)
MATCH (p_radar:product {name: 'RadarSensor'})
MATCH (attr_radarFrequency:attribute {name: 'frequency'})
CREATE (p_radar)-[:HAS]->(attr_radarFrequency);
// Fixed: CREATE (p_radar)-[:HAS]->(attr_radarFOV)
MATCH (p_radar:product {name: 'RadarSensor'})
MATCH (attr_radarFOV:attribute {name: 'fieldOfView'})
CREATE (p_radar)-[:HAS]->(attr_radarFOV);

// Ultrasonic Sensors Attributes
CREATE (attr_ultrasonicRange:attribute {
    name: 'range',
    value: '0.2–5 m',
    description: 'Ultrasonic sensor range',
    label: 'Ultrasonic Range'
})
CREATE (attr_ultrasonicQuantity:attribute {
    name: 'quantity',
    value: '12',
    description: 'Number of ultrasonic sensors',
    label: 'Ultrasonic Quantity'
})

// Fixed: CREATE (p_ultrasonics)-[:HAS]->(attr_ultrasonicRange)
MATCH (p_ultrasonics:product {name: 'UltrasonicSensors'})
MATCH (attr_ultrasonicRange:attribute {name: 'range'})
CREATE (p_ultrasonics)-[:HAS]->(attr_ultrasonicRange);
// Fixed: CREATE (p_ultrasonics)-[:HAS]->(attr_ultrasonicQuantity)
MATCH (p_ultrasonics:product {name: 'UltrasonicSensors'})
MATCH (attr_ultrasonicQuantity:attribute {name: 'quantity'})
CREATE (p_ultrasonics)-[:HAS]->(attr_ultrasonicQuantity);

// Lidar Sensor Attributes
CREATE (attr_lidarRange:attribute {
    name: 'range',
    value: '150 m',
    description: 'Lidar range',
    label: 'Lidar Range'
})
CREATE (attr_lidarChannels:attribute {
    name: 'channels',
    value: '32',
    description: 'Lidar channels',
    label: 'Lidar Channels'
})
CREATE (attr_lidarRotationRate:attribute {
    name: 'rotationRate',
    value: '10 Hz',
    description: 'Lidar rotation rate',
    label: 'Lidar Rotation Rate'
})

// Fixed: CREATE (p_lidar)-[:HAS]->(attr_lidarRange)
MATCH (p_lidar:product {name: 'LidarSensor'})
MATCH (attr_lidarRange:attribute {name: 'range'})
CREATE (p_lidar)-[:HAS]->(attr_lidarRange);
// Fixed: CREATE (p_lidar)-[:HAS]->(attr_lidarChannels)
MATCH (p_lidar:product {name: 'LidarSensor'})
MATCH (attr_lidarChannels:attribute {name: 'channels'})
CREATE (p_lidar)-[:HAS]->(attr_lidarChannels);
// Fixed: CREATE (p_lidar)-[:HAS]->(attr_lidarRotationRate)
MATCH (p_lidar:product {name: 'LidarSensor'})
MATCH (attr_lidarRotationRate:attribute {name: 'rotationRate'})
CREATE (p_lidar)-[:HAS]->(attr_lidarRotationRate);

// Infotainment Head Unit Attributes
CREATE (attr_infotainmentDisplay:attribute {
    name: 'display',
    value: '12" touchscreen',
    description: 'Infotainment display specification',
    label: 'Infotainment Display'
})
CREATE (attr_infotainmentOS:attribute {
    name: 'OS',
    value: 'Linux',
    description: 'Infotainment operating system',
    label: 'Infotainment OS'
})
CREATE (attr_infotainmentWireless:attribute {
    name: 'wireless',
    value: 'Bluetooth, Wi-Fi',
    description: 'Infotainment wireless capabilities',
    label: 'Infotainment Wireless'
})

// Fixed: CREATE (p_headUnit)-[:HAS]->(attr_infotainmentDisplay)
MATCH (p_headUnit:product {name: 'InfotainmentHeadUnit'})
MATCH (attr_infotainmentDisplay:attribute {name: 'display'})
CREATE (p_headUnit)-[:HAS]->(attr_infotainmentDisplay);
// Fixed: CREATE (p_headUnit)-[:HAS]->(attr_infotainmentOS)
MATCH (p_headUnit:product {name: 'InfotainmentHeadUnit'})
MATCH (attr_infotainmentOS:attribute {name: 'OS'})
CREATE (p_headUnit)-[:HAS]->(attr_infotainmentOS);
// Fixed: CREATE (p_headUnit)-[:HAS]->(attr_infotainmentWireless)
MATCH (p_headUnit:product {name: 'InfotainmentHeadUnit'})
MATCH (attr_infotainmentWireless:attribute {name: 'wireless'})
CREATE (p_headUnit)-[:HAS]->(attr_infotainmentWireless);

// Telematics Control Unit Attributes
CREATE (attr_telematicsModem:attribute {
    name: 'modem',
    value: '4G/5G',
    description: 'Telematics modem type',
    label: 'Telematics Modem'
})
CREATE (attr_telematicsGNSS:attribute {
    name: 'GNSS',
    value: 'GPS/GLONASS',
    description: 'Telematics GNSS systems',
    label: 'Telematics GNSS'
})
CREATE (attr_telematicsMemory:attribute {
    name: 'memory',
    value: '8 GB',
    description: 'Telematics memory capacity',
    label: 'Telematics Memory'
})

// Fixed: CREATE (p_telematics)-[:HAS]->(attr_telematicsModem)
MATCH (p_telematics:product {name: 'TelematicsControlUnit'})
MATCH (attr_telematicsModem:attribute {name: 'modem'})
CREATE (p_telematics)-[:HAS]->(attr_telematicsModem);
// Fixed: CREATE (p_telematics)-[:HAS]->(attr_telematicsGNSS)
MATCH (p_telematics:product {name: 'TelematicsControlUnit'})
MATCH (attr_telematicsGNSS:attribute {name: 'GNSS'})
CREATE (p_telematics)-[:HAS]->(attr_telematicsGNSS);
// Fixed: CREATE (p_telematics)-[:HAS]->(attr_telematicsMemory)
MATCH (p_telematics:product {name: 'TelematicsControlUnit'})
MATCH (attr_telematicsMemory:attribute {name: 'memory'})
CREATE (p_telematics)-[:HAS]->(attr_telematicsMemory);

// CAN Bus Network Attributes
CREATE (attr_canSpeed:attribute {
    name: 'speed',
    value: '500 kbps/2 Mbps',
    description: 'CAN bus speed',
    label: 'CAN Speed'
})
CREATE (attr_canNodes:attribute {
    name: 'nodes',
    value: 'up to 32',
    description: 'CAN bus node capacity',
    label: 'CAN Nodes'
})

// Fixed: CREATE (p_canBus)-[:HAS]->(attr_canSpeed)
MATCH (p_canBus:product {name: 'CANBusNetwork'})
MATCH (attr_canSpeed:attribute {name: 'speed'})
CREATE (p_canBus)-[:HAS]->(attr_canSpeed);
// Fixed: CREATE (p_canBus)-[:HAS]->(attr_canNodes)
MATCH (p_canBus:product {name: 'CANBusNetwork'})
MATCH (attr_canNodes:attribute {name: 'nodes'})
CREATE (p_canBus)-[:HAS]->(attr_canNodes);

// High Voltage Power Distribution Unit Attributes
CREATE (attr_pdMaxCurrent:attribute {
    name: 'maxCurrent',
    value: '400 A',
    description: 'Power distribution maximum current',
    label: 'PD Max Current'
})
CREATE (attr_pdFuses:attribute {
    name: 'fuses',
    value: 'integrated',
    description: 'Power distribution fuses',
    label: 'PD Fuses'
})
CREATE (attr_pdRelays:attribute {
    name: 'relays',
    value: 'contactor-based',
    description: 'Power distribution relays',
    label: 'PD Relays'
})

// Fixed: CREATE (p_powerDist)-[:HAS]->(attr_pdMaxCurrent)
MATCH (p_powerDist:product {name: 'HighVoltagePowerDistributionUnit'})
MATCH (attr_pdMaxCurrent:attribute {name: 'maxCurrent'})
CREATE (p_powerDist)-[:HAS]->(attr_pdMaxCurrent);
// Fixed: CREATE (p_powerDist)-[:HAS]->(attr_pdFuses)
MATCH (p_powerDist:product {name: 'HighVoltagePowerDistributionUnit'})
MATCH (attr_pdFuses:attribute {name: 'fuses'})
CREATE (p_powerDist)-[:HAS]->(attr_pdFuses);
// Fixed: CREATE (p_powerDist)-[:HAS]->(attr_pdRelays)
MATCH (p_powerDist:product {name: 'HighVoltagePowerDistributionUnit'})
MATCH (attr_pdRelays:attribute {name: 'relays'})
CREATE (p_powerDist)-[:HAS]->(attr_pdRelays);

// ==========================
// Create Product to Solution Relationships
// ==========================

// Products to Energy Storage and Management
// Fixed: CREATE (p_batteryPack)-[:REALIZES]->(sol_energyStorage)
MATCH (p_batteryPack:product {name: 'BatteryPack'})
MATCH (sol_energyStorage:solution {name: 'EnergyStorageAndManagement'})
CREATE (p_batteryPack)-[:REALIZES]->(sol_energyStorage);
// Fixed: CREATE (p_bmsECU)-[:REALIZES]->(sol_energyStorage)
MATCH (p_bmsECU:product {name: 'BatteryManagementSystemECU'})
MATCH (sol_energyStorage:solution {name: 'EnergyStorageAndManagement'})
CREATE (p_bmsECU)-[:REALIZES]->(sol_energyStorage);
// Fixed: CREATE (p_cellSensors)-[:REALIZES]->(sol_energyStorage)
MATCH (p_cellSensors:product {name: 'CellVoltageTempSensors'})
MATCH (sol_energyStorage:solution {name: 'EnergyStorageAndManagement'})
CREATE (p_cellSensors)-[:REALIZES]->(sol_energyStorage);

// Products to Power Conversion and Propulsion
// Fixed: CREATE (p_inverter)-[:REALIZES]->(sol_powerConversion)
MATCH (p_inverter:product {name: 'MainInverter'})
MATCH (sol_powerConversion:solution {name: 'PowerConversionAndPropulsion'})
CREATE (p_inverter)-[:REALIZES]->(sol_powerConversion);
// Fixed: CREATE (p_motor)-[:REALIZES]->(sol_powerConversion)
MATCH (p_motor:product {name: 'ElectricDriveMotor'})
MATCH (sol_powerConversion:solution {name: 'PowerConversionAndPropulsion'})
CREATE (p_motor)-[:REALIZES]->(sol_powerConversion);
// Fixed: CREATE (p_transmission)-[:REALIZES]->(sol_powerConversion)
MATCH (p_transmission:product {name: 'TransmissionGearbox'})
MATCH (sol_powerConversion:solution {name: 'PowerConversionAndPropulsion'})
CREATE (p_transmission)-[:REALIZES]->(sol_powerConversion);

// Products to Energy Recovery and Braking
// Fixed: CREATE (p_brakeActuator)-[:REALIZES]->(sol_energyRecovery)
MATCH (p_brakeActuator:product {name: 'HydraulicBrakeActuator'})
MATCH (sol_energyRecovery:solution {name: 'EnergyRecoveryAndBraking'})
CREATE (p_brakeActuator)-[:REALIZES]->(sol_energyRecovery);
// Fixed: CREATE (p_brakeSensor)-[:REALIZES]->(sol_energyRecovery)
MATCH (p_brakeSensor:product {name: 'BrakePedalSensor'})
MATCH (sol_energyRecovery:solution {name: 'EnergyRecoveryAndBraking'})
CREATE (p_brakeSensor)-[:REALIZES]->(sol_energyRecovery);
// Fixed: CREATE (p_regenController)-[:REALIZES]->(sol_energyRecovery)
MATCH (p_regenController:product {name: 'RegenerativeBrakingController'})
MATCH (sol_energyRecovery:solution {name: 'EnergyRecoveryAndBraking'})
CREATE (p_regenController)-[:REALIZES]->(sol_energyRecovery);

// Products to Vehicle Control and Coordination
// Fixed: CREATE (p_vcu)-[:REALIZES]->(sol_vehicleControl)
MATCH (p_vcu:product {name: 'VehicleControlUnit'})
MATCH (sol_vehicleControl:solution {name: 'VehicleControlAndCoordination'})
CREATE (p_vcu)-[:REALIZES]->(sol_vehicleControl);

// Products to Thermal Management System
// Fixed: CREATE (p_thermalController)-[:REALIZES]->(sol_thermalMgmt)
MATCH (p_thermalController:product {name: 'ThermalManagementController'})
MATCH (sol_thermalMgmt:solution {name: 'ThermalManagementSystem'})
CREATE (p_thermalController)-[:REALIZES]->(sol_thermalMgmt);
// Fixed: CREATE (p_coolantPump)-[:REALIZES]->(sol_thermalMgmt)
MATCH (p_coolantPump:product {name: 'CoolantPump'})
MATCH (sol_thermalMgmt:solution {name: 'ThermalManagementSystem'})
CREATE (p_coolantPump)-[:REALIZES]->(sol_thermalMgmt);
// Fixed: CREATE (p_batteryHeater)-[:REALIZES]->(sol_thermalMgmt)
MATCH (p_batteryHeater:product {name: 'BatteryHeater'})
MATCH (sol_thermalMgmt:solution {name: 'ThermalManagementSystem'})
CREATE (p_batteryHeater)-[:REALIZES]->(sol_thermalMgmt);
// Fixed: CREATE (p_hvac)-[:REALIZES]->(sol_thermalMgmt)
MATCH (p_hvac:product {name: 'HVACUnit'})
MATCH (sol_thermalMgmt:solution {name: 'ThermalManagementSystem'})
CREATE (p_hvac)-[:REALIZES]->(sol_thermalMgmt);

// Products to Stability and Safety
// Fixed: CREATE (p_wheelSensors)-[:REALIZES]->(sol_stability)
MATCH (p_wheelSensors:product {name: 'WheelSpeedSensors'})
MATCH (sol_stability:solution {name: 'StabilityAndSafety'})
CREATE (p_wheelSensors)-[:REALIZES]->(sol_stability);
// Fixed: CREATE (p_steeringSensor)-[:REALIZES]->(sol_stability)
MATCH (p_steeringSensor:product {name: 'SteeringAngleSensor'})
MATCH (sol_stability:solution {name: 'StabilityAndSafety'})
CREATE (p_steeringSensor)-[:REALIZES]->(sol_stability);
// Fixed: CREATE (p_yawSensor)-[:REALIZES]->(sol_stability)
MATCH (p_yawSensor:product {name: 'YawRateSensor'})
MATCH (sol_stability:solution {name: 'StabilityAndSafety'})
CREATE (p_yawSensor)-[:REALIZES]->(sol_stability);
// Fixed: CREATE (p_espECU)-[:REALIZES]->(sol_stability)
MATCH (p_espECU:product {name: 'ABSESPECU'})
MATCH (sol_stability:solution {name: 'StabilityAndSafety'})
CREATE (p_espECU)-[:REALIZES]->(sol_stability);

// Products to ADAS
// Fixed: CREATE (p_adasECU)-[:REALIZES]->(sol_adas)
MATCH (p_adasECU:product {name: 'ADASECU'})
MATCH (sol_adas:solution {name: 'AdvancedDriverAssistanceSystems'})
CREATE (p_adasECU)-[:REALIZES]->(sol_adas);
// Fixed: CREATE (p_camera)-[:REALIZES]->(sol_adas)
MATCH (p_camera:product {name: 'FrontCamera'})
MATCH (sol_adas:solution {name: 'AdvancedDriverAssistanceSystems'})
CREATE (p_camera)-[:REALIZES]->(sol_adas);
// Fixed: CREATE (p_radar)-[:REALIZES]->(sol_adas)
MATCH (p_radar:product {name: 'RadarSensor'})
MATCH (sol_adas:solution {name: 'AdvancedDriverAssistanceSystems'})
CREATE (p_radar)-[:REALIZES]->(sol_adas);
// Fixed: CREATE (p_ultrasonics)-[:REALIZES]->(sol_adas)
MATCH (p_ultrasonics:product {name: 'UltrasonicSensors'})
MATCH (sol_adas:solution {name: 'AdvancedDriverAssistanceSystems'})
CREATE (p_ultrasonics)-[:REALIZES]->(sol_adas);
// Fixed: CREATE (p_lidar)-[:REALIZES]->(sol_adas)
MATCH (p_lidar:product {name: 'LidarSensor'})
MATCH (sol_adas:solution {name: 'AdvancedDriverAssistanceSystems'})
CREATE (p_lidar)-[:REALIZES]->(sol_adas);

// Products to Auxiliary and Support Systems
// Fixed: CREATE (p_charger)-[:REALIZES]->(sol_auxiliary)
MATCH (p_charger:product {name: 'OnBoardCharger'})
MATCH (sol_auxiliary:solution {name: 'AuxiliaryAndSupportSystems'})
CREATE (p_charger)-[:REALIZES]->(sol_auxiliary);
// Fixed: CREATE (p_dcConverter)-[:REALIZES]->(sol_auxiliary)
MATCH (p_dcConverter:product {name: 'DCDCConverter'})
MATCH (sol_auxiliary:solution {name: 'AuxiliaryAndSupportSystems'})
CREATE (p_dcConverter)-[:REALIZES]->(sol_auxiliary);
// Fixed: CREATE (p_headUnit)-[:REALIZES]->(sol_auxiliary)
MATCH (p_headUnit:product {name: 'InfotainmentHeadUnit'})
MATCH (sol_auxiliary:solution {name: 'AuxiliaryAndSupportSystems'})
CREATE (p_headUnit)-[:REALIZES]->(sol_auxiliary);
// Fixed: CREATE (p_telematics)-[:REALIZES]->(sol_auxiliary)
MATCH (p_telematics:product {name: 'TelematicsControlUnit'})
MATCH (sol_auxiliary:solution {name: 'AuxiliaryAndSupportSystems'})
CREATE (p_telematics)-[:REALIZES]->(sol_auxiliary);
// Fixed: CREATE (p_canBus)-[:REALIZES]->(sol_auxiliary)
MATCH (p_canBus:product {name: 'CANBusNetwork'})
MATCH (sol_auxiliary:solution {name: 'AuxiliaryAndSupportSystems'})
CREATE (p_canBus)-[:REALIZES]->(sol_auxiliary);
// Fixed: CREATE (p_powerDist)-[:REALIZES]->(sol_auxiliary)
MATCH (p_powerDist:product {name: 'HighVoltagePowerDistributionUnit'})
MATCH (sol_auxiliary:solution {name: 'AuxiliaryAndSupportSystems'})
CREATE (p_powerDist)-[:REALIZES]->(sol_auxiliary);

// Products to Overall Vehicle System
// Fixed: CREATE (p_canBus)-[:REALIZES]->(sol_overallSystem)
MATCH (p_canBus:product {name: 'CANBusNetwork'})
MATCH (sol_overallSystem:solution {name: 'OverallVehicleSystem'})
CREATE (p_canBus)-[:REALIZES]->(sol_overallSystem);
// Fixed: CREATE (p_headUnit)-[:REALIZES]->(sol_overallSystem)
MATCH (p_headUnit:product {name: 'InfotainmentHeadUnit'})
MATCH (sol_overallSystem:solution {name: 'OverallVehicleSystem'})
CREATE (p_headUnit)-[:REALIZES]->(sol_overallSystem);
// Fixed: CREATE (p_telematics)-[:REALIZES]->(sol_overallSystem)
MATCH (p_telematics:product {name: 'TelematicsControlUnit'})
MATCH (sol_overallSystem:solution {name: 'OverallVehicleSystem'})
CREATE (p_telematics)-[:REALIZES]->(sol_overallSystem);
// Fixed: CREATE (p_dcConverter)-[:REALIZES]->(sol_overallSystem)
MATCH (p_dcConverter:product {name: 'DCDCConverter'})
MATCH (sol_overallSystem:solution {name: 'OverallVehicleSystem'})
CREATE (p_dcConverter)-[:REALIZES]->(sol_overallSystem);

// ==========================
// Create Solution Hierarchy (IS_COMPOSED_OF)
// ==========================

// Overall Vehicle System is composed of all other solutions
// Fixed: CREATE (sol_overallSystem)-[:IS_COMPOSED_OF]->(sol_energyStorage)
MATCH (sol_overallSystem:solution {name: 'OverallVehicleSystem'})
MATCH (sol_energyStorage:solution {name: 'EnergyStorageAndManagement'})
CREATE (sol_overallSystem)-[:IS_COMPOSED_OF]->(sol_energyStorage);
// Fixed: CREATE (sol_overallSystem)-[:IS_COMPOSED_OF]->(sol_powerConversion)
MATCH (sol_overallSystem:solution {name: 'OverallVehicleSystem'})
MATCH (sol_powerConversion:solution {name: 'PowerConversionAndPropulsion'})
CREATE (sol_overallSystem)-[:IS_COMPOSED_OF]->(sol_powerConversion);
// Fixed: CREATE (sol_overallSystem)-[:IS_COMPOSED_OF]->(sol_energyRecovery)
MATCH (sol_overallSystem:solution {name: 'OverallVehicleSystem'})
MATCH (sol_energyRecovery:solution {name: 'EnergyRecoveryAndBraking'})
CREATE (sol_overallSystem)-[:IS_COMPOSED_OF]->(sol_energyRecovery);
// Fixed: CREATE (sol_overallSystem)-[:IS_COMPOSED_OF]->(sol_vehicleControl)
MATCH (sol_overallSystem:solution {name: 'OverallVehicleSystem'})
MATCH (sol_vehicleControl:solution {name: 'VehicleControlAndCoordination'})
CREATE (sol_overallSystem)-[:IS_COMPOSED_OF]->(sol_vehicleControl);
// Fixed: CREATE (sol_overallSystem)-[:IS_COMPOSED_OF]->(sol_thermalMgmt)
MATCH (sol_overallSystem:solution {name: 'OverallVehicleSystem'})
MATCH (sol_thermalMgmt:solution {name: 'ThermalManagementSystem'})
CREATE (sol_overallSystem)-[:IS_COMPOSED_OF]->(sol_thermalMgmt);
// Fixed: CREATE (sol_overallSystem)-[:IS_COMPOSED_OF]->(sol_stability)
MATCH (sol_overallSystem:solution {name: 'OverallVehicleSystem'})
MATCH (sol_stability:solution {name: 'StabilityAndSafety'})
CREATE (sol_overallSystem)-[:IS_COMPOSED_OF]->(sol_stability);
// Fixed: CREATE (sol_overallSystem)-[:IS_COMPOSED_OF]->(sol_adas)
MATCH (sol_overallSystem:solution {name: 'OverallVehicleSystem'})
MATCH (sol_adas:solution {name: 'AdvancedDriverAssistanceSystems'})
CREATE (sol_overallSystem)-[:IS_COMPOSED_OF]->(sol_adas);
// Fixed: CREATE (sol_overallSystem)-[:IS_COMPOSED_OF]->(sol_auxiliary)
MATCH (sol_overallSystem:solution {name: 'OverallVehicleSystem'})
MATCH (sol_auxiliary:solution {name: 'AuxiliaryAndSupportSystems'})
CREATE (sol_overallSystem)-[:IS_COMPOSED_OF]->(sol_auxiliary);

// ==========================
// Create Solution to Function Relationships
// ==========================

// Overall Vehicle System performs functions
// Fixed: CREATE (sol_overallSystem)-[:PERFORMS]->(fn_userAuth)
MATCH (sol_overallSystem:solution {name: 'OverallVehicleSystem'})
MATCH (fn_userAuth:function {name: 'UserAuthentication'})
CREATE (sol_overallSystem)-[:PERFORMS]->(fn_userAuth);
// Fixed: CREATE (sol_overallSystem)-[:PERFORMS]->(fn_realTimeDiag)
MATCH (sol_overallSystem:solution {name: 'OverallVehicleSystem'})
MATCH (fn_realTimeDiag:function {name: 'RealTimeDiagnostics'})
CREATE (sol_overallSystem)-[:PERFORMS]->(fn_realTimeDiag);
// Fixed: CREATE (sol_overallSystem)-[:PERFORMS]->(fn_remoteSW)
MATCH (sol_overallSystem:solution {name: 'OverallVehicleSystem'})
MATCH (fn_remoteSW:function {name: 'RemoteSoftwareUpdates'})
CREATE (sol_overallSystem)-[:PERFORMS]->(fn_remoteSW);
// Fixed: CREATE (sol_overallSystem)-[:PERFORMS]->(fn_mobileApp)
MATCH (sol_overallSystem:solution {name: 'OverallVehicleSystem'})
MATCH (fn_mobileApp:function {name: 'MobileAppIntegration'})
CREATE (sol_overallSystem)-[:PERFORMS]->(fn_mobileApp);
// Fixed: CREATE (sol_overallSystem)-[:PERFORMS]->(fn_hmiInteract)
MATCH (sol_overallSystem:solution {name: 'OverallVehicleSystem'})
MATCH (fn_hmiInteract:function {name: 'HMIInteraction'})
CREATE (sol_overallSystem)-[:PERFORMS]->(fn_hmiInteract);

// Energy Recovery performs regenerative braking functions
// Fixed: CREATE (sol_energyRecovery)-[:PERFORMS]->(fn_regenBrakeCtrl)
MATCH (sol_energyRecovery:solution {name: 'EnergyRecoveryAndBraking'})
MATCH (fn_regenBrakeCtrl:function {name: 'RegenerativeBrakingControl'})
CREATE (sol_energyRecovery)-[:PERFORMS]->(fn_regenBrakeCtrl);
// Fixed: CREATE (sol_energyRecovery)-[:PERFORMS]->(fn_regenBraking)
MATCH (sol_energyRecovery:solution {name: 'EnergyRecoveryAndBraking'})
MATCH (fn_regenBraking:function {name: 'RegenerativeBrakingIntegration'})
CREATE (sol_energyRecovery)-[:PERFORMS]->(fn_regenBraking);
// Fixed: CREATE (sol_energyRecovery)-[:PERFORMS]->(fn_hydraulicBrake)
MATCH (sol_energyRecovery:solution {name: 'EnergyRecoveryAndBraking'})
MATCH (fn_hydraulicBrake:function {name: 'HydraulicBraking'})
CREATE (sol_energyRecovery)-[:PERFORMS]->(fn_hydraulicBrake);
// Fixed: CREATE (sol_energyRecovery)-[:PERFORMS]->(fn_regenBrake)
MATCH (sol_energyRecovery:solution {name: 'EnergyRecoveryAndBraking'})
MATCH (fn_regenBrake:function {name: 'RegenerativeBraking'})
CREATE (sol_energyRecovery)-[:PERFORMS]->(fn_regenBrake);
// Fixed: CREATE (sol_energyRecovery)-[:PERFORMS]->(fn_absEbd)
MATCH (sol_energyRecovery:solution {name: 'EnergyRecoveryAndBraking'})
MATCH (fn_absEbd:function {name: 'ABSEBDControl'})
CREATE (sol_energyRecovery)-[:PERFORMS]->(fn_absEbd);
// Fixed: CREATE (sol_energyRecovery)-[:PERFORMS]->(fn_brakeWear)
MATCH (sol_energyRecovery:solution {name: 'EnergyRecoveryAndBraking'})
MATCH (fn_brakeWear:function {name: 'BrakeWearMonitoring'})
CREATE (sol_energyRecovery)-[:PERFORMS]->(fn_brakeWear);

// Auxiliary systems perform charging compatibility
// Fixed: CREATE (sol_auxiliary)-[:PERFORMS]->(fn_chargingCompat)
MATCH (sol_auxiliary:solution {name: 'AuxiliaryAndSupportSystems'})
MATCH (fn_chargingCompat:function {name: 'ChargingStandardCompatibility'})
CREATE (sol_auxiliary)-[:PERFORMS]->(fn_chargingCompat);

// Power Conversion & Propulsion performs functions
// Fixed: CREATE (sol_powerConversion)-[:PERFORMS]->(fn_torqueDelivery)
MATCH (sol_powerConversion:solution {name: 'PowerConversionAndPropulsion'})
MATCH (fn_torqueDelivery:function {name: 'TorqueDelivery'})
CREATE (sol_powerConversion)-[:PERFORMS]->(fn_torqueDelivery);
// Fixed: CREATE (sol_powerConversion)-[:PERFORMS]->(fn_driveModes)
MATCH (sol_powerConversion:solution {name: 'PowerConversionAndPropulsion'})
MATCH (fn_driveModes:function {name: 'ForwardReverseDriveModes'})
CREATE (sol_powerConversion)-[:PERFORMS]->(fn_driveModes);
// Fixed: CREATE (sol_powerConversion)-[:PERFORMS]->(fn_hillHold)
MATCH (sol_powerConversion:solution {name: 'PowerConversionAndPropulsion'})
MATCH (fn_hillHold:function {name: 'HillHoldAssist'})
CREATE (sol_powerConversion)-[:PERFORMS]->(fn_hillHold);

// Energy Storage performs BMS functions
// Fixed: CREATE (sol_energyStorage)-[:PERFORMS]->(fn_cellMonitoring)
MATCH (sol_energyStorage:solution {name: 'EnergyStorageAndManagement'})
MATCH (fn_cellMonitoring:function {name: 'CellVoltageMonitoring'})
CREATE (sol_energyStorage)-[:PERFORMS]->(fn_cellMonitoring);
// Fixed: CREATE (sol_energyStorage)-[:PERFORMS]->(fn_socSohEst)
MATCH (sol_energyStorage:solution {name: 'EnergyStorageAndManagement'})
MATCH (fn_socSohEst:function {name: 'SOCSOHEstimation'})
CREATE (sol_energyStorage)-[:PERFORMS]->(fn_socSohEst);
// Fixed: CREATE (sol_energyStorage)-[:PERFORMS]->(fn_cellBalancing)
MATCH (sol_energyStorage:solution {name: 'EnergyStorageAndManagement'})
MATCH (fn_cellBalancing:function {name: 'ActiveCellBalancing'})
CREATE (sol_energyStorage)-[:PERFORMS]->(fn_cellBalancing);
// Fixed: CREATE (sol_energyStorage)-[:PERFORMS]->(fn_faultDetect)
MATCH (sol_energyStorage:solution {name: 'EnergyStorageAndManagement'})
MATCH (fn_faultDetect:function {name: 'FaultDetection'})
CREATE (sol_energyStorage)-[:PERFORMS]->(fn_faultDetect);
// Fixed: CREATE (sol_energyStorage)-[:PERFORMS]->(fn_thermalCtrl)
MATCH (sol_energyStorage:solution {name: 'EnergyStorageAndManagement'})
MATCH (fn_thermalCtrl:function {name: 'ThermalManagementControl'})
CREATE (sol_energyStorage)-[:PERFORMS]->(fn_thermalCtrl);
// Fixed: CREATE (sol_energyStorage)-[:PERFORMS]->(fn_safetyComply)
MATCH (sol_energyStorage:solution {name: 'EnergyStorageAndManagement'})
MATCH (fn_safetyComply:function {name: 'SafetyCompliance'})
CREATE (sol_energyStorage)-[:PERFORMS]->(fn_safetyComply);
// Fixed: CREATE (sol_energyStorage)-[:PERFORMS]->(fn_dataLog)
MATCH (sol_energyStorage:solution {name: 'EnergyStorageAndManagement'})
MATCH (fn_dataLog:function {name: 'DataLogging'})
CREATE (sol_energyStorage)-[:PERFORMS]->(fn_dataLog);

// Thermal Management performs functions
// Fixed: CREATE (sol_thermalMgmt)-[:PERFORMS]->(fn_batteryCooling)
MATCH (sol_thermalMgmt:solution {name: 'ThermalManagementSystem'})
MATCH (fn_batteryCooling:function {name: 'BatteryCoolingHeating'})
CREATE (sol_thermalMgmt)-[:PERFORMS]->(fn_batteryCooling);
// Fixed: CREATE (sol_thermalMgmt)-[:PERFORMS]->(fn_wasteHeat)
MATCH (sol_thermalMgmt:solution {name: 'ThermalManagementSystem'})
MATCH (fn_wasteHeat:function {name: 'WasteHeatRecovery'})
CREATE (sol_thermalMgmt)-[:PERFORMS]->(fn_wasteHeat);
// Fixed: CREATE (sol_thermalMgmt)-[:PERFORMS]->(fn_coolantMonitor)
MATCH (sol_thermalMgmt:solution {name: 'ThermalManagementSystem'})
MATCH (fn_coolantMonitor:function {name: 'CoolantFlowMonitoring'})
CREATE (sol_thermalMgmt)-[:PERFORMS]->(fn_coolantMonitor);
// Fixed: CREATE (sol_thermalMgmt)-[:PERFORMS]->(fn_powerElecCool)
MATCH (sol_thermalMgmt:solution {name: 'ThermalManagementSystem'})
MATCH (fn_powerElecCool:function {name: 'PowerElectronicsCooling'})
CREATE (sol_thermalMgmt)-[:PERFORMS]->(fn_powerElecCool);

// Stability performs ESP functions
// Fixed: CREATE (sol_stability)-[:PERFORMS]->(fn_yawMonitor)
MATCH (sol_stability:solution {name: 'StabilityAndSafety'})
MATCH (fn_yawMonitor:function {name: 'YawRateMonitoring'})
CREATE (sol_stability)-[:PERFORMS]->(fn_yawMonitor);
// Fixed: CREATE (sol_stability)-[:PERFORMS]->(fn_torqueReduce)
MATCH (sol_stability:solution {name: 'StabilityAndSafety'})
MATCH (fn_torqueReduce:function {name: 'TorqueReduction'})
CREATE (sol_stability)-[:PERFORMS]->(fn_torqueReduce);
// Fixed: CREATE (sol_stability)-[:PERFORMS]->(fn_wheelBrake)
MATCH (sol_stability:solution {name: 'StabilityAndSafety'})
MATCH (fn_wheelBrake:function {name: 'IndividualWheelBraking'})
CREATE (sol_stability)-[:PERFORMS]->(fn_wheelBrake);
// Fixed: CREATE (sol_stability)-[:PERFORMS]->(fn_trailerStab)
MATCH (sol_stability:solution {name: 'StabilityAndSafety'})
MATCH (fn_trailerStab:function {name: 'TrailerStabilityControl'})
CREATE (sol_stability)-[:PERFORMS]->(fn_trailerStab);

// Vehicle Control performs functions
// Fixed: CREATE (sol_vehicleControl)-[:PERFORMS]->(fn_driveMode)
MATCH (sol_vehicleControl:solution {name: 'VehicleControlAndCoordination'})
MATCH (fn_driveMode:function {name: 'DriveModeCoordination'})
CREATE (sol_vehicleControl)-[:PERFORMS]->(fn_driveMode);
// Fixed: CREATE (sol_vehicleControl)-[:PERFORMS]->(fn_subsysInteg)
MATCH (sol_vehicleControl:solution {name: 'VehicleControlAndCoordination'})
MATCH (fn_subsysInteg:function {name: 'SubsystemIntegration'})
CREATE (sol_vehicleControl)-[:PERFORMS]->(fn_subsysInteg);
// Fixed: CREATE (sol_vehicleControl)-[:PERFORMS]->(fn_failSafe)
MATCH (sol_vehicleControl:solution {name: 'VehicleControlAndCoordination'})
MATCH (fn_failSafe:function {name: 'FailSafeActivation'})
CREATE (sol_vehicleControl)-[:PERFORMS]->(fn_failSafe);
// Fixed: CREATE (sol_vehicleControl)-[:PERFORMS]->(fn_realTimeDiag2)
MATCH (sol_vehicleControl:solution {name: 'VehicleControlAndCoordination'})
MATCH (fn_realTimeDiag2:function {name: 'RealTimeDiagnostics'})
CREATE (sol_vehicleControl)-[:PERFORMS]->(fn_realTimeDiag2);

// ADAS performs functions
// Fixed: CREATE (sol_adas)-[:PERFORMS]->(fn_adaptiveCruise)
MATCH (sol_adas:solution {name: 'AdvancedDriverAssistanceSystems'})
MATCH (fn_adaptiveCruise:function {name: 'AdaptiveCruiseControl'})
CREATE (sol_adas)-[:PERFORMS]->(fn_adaptiveCruise);
// Fixed: CREATE (sol_adas)-[:PERFORMS]->(fn_laneKeeping)
MATCH (sol_adas:solution {name: 'AdvancedDriverAssistanceSystems'})
MATCH (fn_laneKeeping:function {name: 'LaneKeepingAssist'})
CREATE (sol_adas)-[:PERFORMS]->(fn_laneKeeping);
// Fixed: CREATE (sol_adas)-[:PERFORMS]->(fn_emergencyBrake)
MATCH (sol_adas:solution {name: 'AdvancedDriverAssistanceSystems'})
MATCH (fn_emergencyBrake:function {name: 'EmergencyBraking'})
CREATE (sol_adas)-[:PERFORMS]->(fn_emergencyBrake);
// Fixed: CREATE (sol_adas)-[:PERFORMS]->(fn_blindSpot)
MATCH (sol_adas:solution {name: 'AdvancedDriverAssistanceSystems'})
MATCH (fn_blindSpot:function {name: 'BlindSpotDetection'})
CREATE (sol_adas)-[:PERFORMS]->(fn_blindSpot);

// ==========================
// Create Function to Functional Requirement Relationships
// ==========================

// Fixed: CREATE (fn_userAuth)-[:MUST_SATISFY]->(fr_userAuth)
MATCH (fn_userAuth:function {name: 'UserAuthentication'})
MATCH (fr_userAuth:functional_requirement {name: 'UserAuthentication'})
CREATE (fn_userAuth)-[:MUST_SATISFY]->(fr_userAuth);
// Fixed: CREATE (fn_realTimeDiag)-[:MUST_SATISFY]->(fr_realTimeDiag)
MATCH (fn_realTimeDiag:function {name: 'RealTimeDiagnostics'})
MATCH (fr_realTimeDiag:functional_requirement {name: 'RealTimeDiagnostics'})
CREATE (fn_realTimeDiag)-[:MUST_SATISFY]->(fr_realTimeDiag);
// Fixed: CREATE (fn_remoteSW)-[:MUST_SATISFY]->(fr_remoteSW)
MATCH (fn_remoteSW:function {name: 'RemoteSoftwareUpdates'})
MATCH (fr_remoteSW:functional_requirement {name: 'RemoteSoftwareUpdates'})
CREATE (fn_remoteSW)-[:MUST_SATISFY]->(fr_remoteSW);
// Fixed: CREATE (fn_mobileApp)-[:MUST_SATISFY]->(fr_mobileApp)
MATCH (fn_mobileApp:function {name: 'MobileAppIntegration'})
MATCH (fr_mobileApp:functional_requirement {name: 'MobileAppIntegration'})
CREATE (fn_mobileApp)-[:MUST_SATISFY]->(fr_mobileApp);
// Fixed: CREATE (fn_regenBrakeCtrl)-[:MUST_SATISFY]->(fr_regenBraking)
MATCH (fn_regenBrakeCtrl:function {name: 'RegenerativeBrakingControl'})
MATCH (fr_regenBraking:functional_requirement {name: 'RegenerativeBraking'})
CREATE (fn_regenBrakeCtrl)-[:MUST_SATISFY]->(fr_regenBraking);
// Fixed: CREATE (fn_chargingCompat)-[:MUST_SATISFY]->(fr_chargingStandards)
MATCH (fn_chargingCompat:function {name: 'ChargingStandardCompatibility'})
MATCH (fr_chargingStandards:functional_requirement {name: 'ChargingStandards'})
CREATE (fn_chargingCompat)-[:MUST_SATISFY]->(fr_chargingStandards);
// Fixed: CREATE (fn_hmiInteract)-[:MUST_SATISFY]->(fr_userFriendlyHMI)
MATCH (fn_hmiInteract:function {name: 'HMIInteraction'})
MATCH (fr_userFriendlyHMI:functional_requirement {name: 'UserFriendlyHMI'})
CREATE (fn_hmiInteract)-[:MUST_SATISFY]->(fr_userFriendlyHMI);

// Fixed: CREATE (fn_torqueDelivery)-[:MUST_SATISFY]->(fr_seamlessTorque)
MATCH (fn_torqueDelivery:function {name: 'TorqueDelivery'})
MATCH (fr_seamlessTorque:functional_requirement {name: 'SeamlessTorqueDelivery'})
CREATE (fn_torqueDelivery)-[:MUST_SATISFY]->(fr_seamlessTorque);
// Fixed: CREATE (fn_driveModes)-[:MUST_SATISFY]->(fr_driveModes)
MATCH (fn_driveModes:function {name: 'ForwardReverseDriveModes'})
MATCH (fr_driveModes:functional_requirement {name: 'DriveModesSupport'})
CREATE (fn_driveModes)-[:MUST_SATISFY]->(fr_driveModes);
// Fixed: CREATE (fn_regenBraking)-[:MUST_SATISFY]->(fr_regenBrakingInt)
MATCH (fn_regenBraking:function {name: 'RegenerativeBrakingIntegration'})
MATCH (fr_regenBrakingInt:functional_requirement {name: 'RegenBrakingIntegration'})
CREATE (fn_regenBraking)-[:MUST_SATISFY]->(fr_regenBrakingInt);
// Fixed: CREATE (fn_hillHold)-[:MUST_SATISFY]->(fr_hillAssist)
MATCH (fn_hillHold:function {name: 'HillHoldAssist'})
MATCH (fr_hillAssist:functional_requirement {name: 'HillAssist'})
CREATE (fn_hillHold)-[:MUST_SATISFY]->(fr_hillAssist);

// Fixed: CREATE (fn_cellMonitoring)-[:MUST_SATISFY]->(fr_cellMonitoring)
MATCH (fn_cellMonitoring:function {name: 'CellVoltageMonitoring'})
MATCH (fr_cellMonitoring:functional_requirement {name: 'CellMonitoring'})
CREATE (fn_cellMonitoring)-[:MUST_SATISFY]->(fr_cellMonitoring);
// Fixed: CREATE (fn_socSohEst)-[:MUST_SATISFY]->(fr_stateEstimation)
MATCH (fn_socSohEst:function {name: 'SOCSOHEstimation'})
MATCH (fr_stateEstimation:functional_requirement {name: 'StateEstimation'})
CREATE (fn_socSohEst)-[:MUST_SATISFY]->(fr_stateEstimation);
// Fixed: CREATE (fn_cellBalancing)-[:MUST_SATISFY]->(fr_cellBalancing)
MATCH (fn_cellBalancing:function {name: 'ActiveCellBalancing'})
MATCH (fr_cellBalancing:functional_requirement {name: 'CellBalancing'})
CREATE (fn_cellBalancing)-[:MUST_SATISFY]->(fr_cellBalancing);
// Fixed: CREATE (fn_faultDetect)-[:MUST_SATISFY]->(fr_faultDetection)
MATCH (fn_faultDetect:function {name: 'FaultDetection'})
MATCH (fr_faultDetection:functional_requirement {name: 'FaultDetection'})
CREATE (fn_faultDetect)-[:MUST_SATISFY]->(fr_faultDetection);
// Fixed: CREATE (fn_thermalCtrl)-[:MUST_SATISFY]->(fr_thermalControl)
MATCH (fn_thermalCtrl:function {name: 'ThermalManagementControl'})
MATCH (fr_thermalControl:functional_requirement {name: 'ThermalControl'})
CREATE (fn_thermalCtrl)-[:MUST_SATISFY]->(fr_thermalControl);
// Fixed: CREATE (fn_safetyComply)-[:MUST_SATISFY]->(fr_safetyCompliance)
MATCH (fn_safetyComply:function {name: 'SafetyCompliance'})
MATCH (fr_safetyCompliance:functional_requirement {name: 'SafetyCompliance'})
CREATE (fn_safetyComply)-[:MUST_SATISFY]->(fr_safetyCompliance);
// Fixed: CREATE (fn_dataLog)-[:MUST_SATISFY]->(fr_dataLogging)
MATCH (fn_dataLog:function {name: 'DataLogging'})
MATCH (fr_dataLogging:functional_requirement {name: 'DataLogging'})
CREATE (fn_dataLog)-[:MUST_SATISFY]->(fr_dataLogging);

// Fixed: CREATE (fn_batteryCooling)-[:MUST_SATISFY]->(fr_activeThermal)
MATCH (fn_batteryCooling:function {name: 'BatteryCoolingHeating'})
MATCH (fr_activeThermal:functional_requirement {name: 'ActiveThermalControl'})
CREATE (fn_batteryCooling)-[:MUST_SATISFY]->(fr_activeThermal);
// Fixed: CREATE (fn_wasteHeat)-[:MUST_SATISFY]->(fr_hvacIntegration)
MATCH (fn_wasteHeat:function {name: 'WasteHeatRecovery'})
MATCH (fr_hvacIntegration:functional_requirement {name: 'HVACIntegration'})
CREATE (fn_wasteHeat)-[:MUST_SATISFY]->(fr_hvacIntegration);
// Fixed: CREATE (fn_coolantMonitor)-[:MUST_SATISFY]->(fr_coolantMonitor)
MATCH (fn_coolantMonitor:function {name: 'CoolantFlowMonitoring'})
MATCH (fr_coolantMonitor:functional_requirement {name: 'CoolantMonitoring'})
CREATE (fn_coolantMonitor)-[:MUST_SATISFY]->(fr_coolantMonitor);
// Fixed: CREATE (fn_powerElecCool)-[:MUST_SATISFY]->(fr_powerElecCooling)
MATCH (fn_powerElecCool:function {name: 'PowerElectronicsCooling'})
MATCH (fr_powerElecCooling:functional_requirement {name: 'PowerElectronicsCooling'})
CREATE (fn_powerElecCool)-[:MUST_SATISFY]->(fr_powerElecCooling);

// Fixed: CREATE (fn_yawMonitor)-[:MUST_SATISFY]->(fr_sensorMonitor)
MATCH (fn_yawMonitor:function {name: 'YawRateMonitoring'})
MATCH (fr_sensorMonitor:functional_requirement {name: 'SensorMonitoring'})
CREATE (fn_yawMonitor)-[:MUST_SATISFY]->(fr_sensorMonitor);
// Fixed: CREATE (fn_torqueReduce)-[:MUST_SATISFY]->(fr_stabilityIntervention)
MATCH (fn_torqueReduce:function {name: 'TorqueReduction'})
MATCH (fr_stabilityIntervention:functional_requirement {name: 'StabilityIntervention'})
CREATE (fn_torqueReduce)-[:MUST_SATISFY]->(fr_stabilityIntervention);
// Fixed: CREATE (fn_wheelBrake)-[:MUST_SATISFY]->(fr_stabilityIntervention)
MATCH (fn_wheelBrake:function {name: 'IndividualWheelBraking'})
MATCH (fr_stabilityIntervention:functional_requirement {name: 'StabilityIntervention'})
CREATE (fn_wheelBrake)-[:MUST_SATISFY]->(fr_stabilityIntervention);
// Fixed: CREATE (fn_trailerStab)-[:MUST_SATISFY]->(fr_trailerStability)
MATCH (fn_trailerStab:function {name: 'TrailerStabilityControl'})
MATCH (fr_trailerStability:functional_requirement {name: 'TrailerStability'})
CREATE (fn_trailerStab)-[:MUST_SATISFY]->(fr_trailerStability);

// Fixed: CREATE (fn_driveMode)-[:MUST_SATISFY]->(fr_driveModesSupport)
MATCH (fn_driveMode:function {name: 'DriveModeCoordination'})
MATCH (fr_driveModesSupport:functional_requirement {name: 'DriveModesSupport'})
CREATE (fn_driveMode)-[:MUST_SATISFY]->(fr_driveModesSupport);
// Fixed: CREATE (fn_subsysInteg)-[:MUST_SATISFY]->(fr_systemIntegration)
MATCH (fn_subsysInteg:function {name: 'SubsystemIntegration'})
MATCH (fr_systemIntegration:functional_requirement {name: 'SystemIntegration'})
CREATE (fn_subsysInteg)-[:MUST_SATISFY]->(fr_systemIntegration);
// Fixed: CREATE (fn_failSafe)-[:MUST_SATISFY]->(fr_failSafeOp)
MATCH (fn_failSafe:function {name: 'FailSafeActivation'})
MATCH (fr_failSafeOp:functional_requirement {name: 'FailSafeOperation'})
CREATE (fn_failSafe)-[:MUST_SATISFY]->(fr_failSafeOp);
// Fixed: CREATE (fn_realTimeDiag2)-[:MUST_SATISFY]->(fr_systemCoord)
MATCH (fn_realTimeDiag2:function {name: 'RealTimeDiagnostics'})
MATCH (fr_systemCoord:functional_requirement {name: 'SystemCoordination'})
CREATE (fn_realTimeDiag2)-[:MUST_SATISFY]->(fr_systemCoord);

// Fixed: CREATE (fn_adaptiveCruise)-[:MUST_SATISFY]->(fr_coreFeatures)
MATCH (fn_adaptiveCruise:function {name: 'AdaptiveCruiseControl'})
MATCH (fr_coreFeatures:functional_requirement {name: 'CoreFeatures'})
CREATE (fn_adaptiveCruise)-[:MUST_SATISFY]->(fr_coreFeatures);
// Fixed: CREATE (fn_laneKeeping)-[:MUST_SATISFY]->(fr_coreFeatures)
MATCH (fn_laneKeeping:function {name: 'LaneKeepingAssist'})
MATCH (fr_coreFeatures:functional_requirement {name: 'CoreFeatures'})
CREATE (fn_laneKeeping)-[:MUST_SATISFY]->(fr_coreFeatures);
// Fixed: CREATE (fn_emergencyBrake)-[:MUST_SATISFY]->(fr_coreFeatures)
MATCH (fn_emergencyBrake:function {name: 'EmergencyBraking'})
MATCH (fr_coreFeatures:functional_requirement {name: 'CoreFeatures'})
CREATE (fn_emergencyBrake)-[:MUST_SATISFY]->(fr_coreFeatures);
// Fixed: CREATE (fn_blindSpot)-[:MUST_SATISFY]->(fr_safetyFeatures)
MATCH (fn_blindSpot:function {name: 'BlindSpotDetection'})
MATCH (fr_safetyFeatures:functional_requirement {name: 'SafetyFeatures'})
CREATE (fn_blindSpot)-[:MUST_SATISFY]->(fr_safetyFeatures);

// Fixed: CREATE (fn_hydraulicBrake)-[:MUST_SATISFY]->(fr_dualBraking)
MATCH (fn_hydraulicBrake:function {name: 'HydraulicBraking'})
MATCH (fr_dualBraking:functional_requirement {name: 'DualBraking'})
CREATE (fn_hydraulicBrake)-[:MUST_SATISFY]->(fr_dualBraking);
// Fixed: CREATE (fn_regenBrake)-[:MUST_SATISFY]->(fr_dualBraking)
MATCH (fn_regenBrake:function {name: 'RegenerativeBraking'})
MATCH (fr_dualBraking:functional_requirement {name: 'DualBraking'})
CREATE (fn_regenBrake)-[:MUST_SATISFY]->(fr_dualBraking);
// Fixed: CREATE (fn_absEbd)-[:MUST_SATISFY]->(fr_absEbd)
MATCH (fn_absEbd:function {name: 'ABSEBDControl'})
MATCH (fr_absEbd:functional_requirement {name: 'ABSandEBD'})
CREATE (fn_absEbd)-[:MUST_SATISFY]->(fr_absEbd);
// Fixed: CREATE (fn_brakeWear)-[:MUST_SATISFY]->(fr_wearFeedback)
MATCH (fn_brakeWear:function {name: 'BrakeWearMonitoring'})
MATCH (fr_wearFeedback:functional_requirement {name: 'WearFeedback'})
CREATE (fn_brakeWear)-[:MUST_SATISFY]->(fr_wearFeedback);

// ==========================
// Create Solution to Performance Requirement Relationships
// ==========================

// Fixed: CREATE (sol_energyStorage)-[:MUST_SATISFY]->(pr_chargeDischargeRate)
MATCH (sol_energyStorage:solution {name: 'EnergyStorageAndManagement'})
MATCH (pr_chargeDischargeRate:performance_requirement {name: 'ChargeDischargeRate'})
CREATE (sol_energyStorage)-[:MUST_SATISFY]->(pr_chargeDischargeRate);
// Fixed: CREATE (sol_energyStorage)-[:MUST_SATISFY]->(pr_voltageTolerance)
MATCH (sol_energyStorage:solution {name: 'EnergyStorageAndManagement'})
MATCH (pr_voltageTolerance:performance_requirement {name: 'VoltageTolerance'})
CREATE (sol_energyStorage)-[:MUST_SATISFY]->(pr_voltageTolerance);
// Fixed: CREATE (sol_energyStorage)-[:MUST_SATISFY]->(pr_thermalRunaway)
MATCH (sol_energyStorage:solution {name: 'EnergyStorageAndManagement'})
MATCH (pr_thermalRunaway:performance_requirement {name: 'ThermalRunawayDetection'})
CREATE (sol_energyStorage)-[:MUST_SATISFY]->(pr_thermalRunaway);
// Fixed: CREATE (sol_energyStorage)-[:MUST_SATISFY]->(pr_cycleLife)
MATCH (sol_energyStorage:solution {name: 'EnergyStorageAndManagement'})
MATCH (pr_cycleLife:performance_requirement {name: 'CycleLife'})
CREATE (sol_energyStorage)-[:MUST_SATISFY]->(pr_cycleLife);

// Fixed: CREATE (sol_powerConversion)-[:MUST_SATISFY]->(pr_peakPower)
MATCH (sol_powerConversion:solution {name: 'PowerConversionAndPropulsion'})
MATCH (pr_peakPower:performance_requirement {name: 'PeakPower'})
CREATE (sol_powerConversion)-[:MUST_SATISFY]->(pr_peakPower);
// Fixed: CREATE (sol_powerConversion)-[:MUST_SATISFY]->(pr_maxTorque)
MATCH (sol_powerConversion:solution {name: 'PowerConversionAndPropulsion'})
MATCH (pr_maxTorque:performance_requirement {name: 'MaxTorque'})
CREATE (sol_powerConversion)-[:MUST_SATISFY]->(pr_maxTorque);
// Fixed: CREATE (sol_powerConversion)-[:MUST_SATISFY]->(pr_continuousOp)
MATCH (sol_powerConversion:solution {name: 'PowerConversionAndPropulsion'})
MATCH (pr_continuousOp:performance_requirement {name: 'ContinuousOperation'})
CREATE (sol_powerConversion)-[:MUST_SATISFY]->(pr_continuousOp);
// Fixed: CREATE (sol_powerConversion)-[:MUST_SATISFY]->(pr_gradeability)
MATCH (sol_powerConversion:solution {name: 'PowerConversionAndPropulsion'})
MATCH (pr_gradeability:performance_requirement {name: 'Gradeability'})
CREATE (sol_powerConversion)-[:MUST_SATISFY]->(pr_gradeability);

// Fixed: CREATE (sol_thermalMgmt)-[:MUST_SATISFY]->(pr_batteryTemp)
MATCH (sol_thermalMgmt:solution {name: 'ThermalManagementSystem'})
MATCH (pr_batteryTemp:performance_requirement {name: 'BatteryTemperature'})
CREATE (sol_thermalMgmt)-[:MUST_SATISFY]->(pr_batteryTemp);
// Fixed: CREATE (sol_thermalMgmt)-[:MUST_SATISFY]->(pr_preConditioning)
MATCH (sol_thermalMgmt:solution {name: 'ThermalManagementSystem'})
MATCH (pr_preConditioning:performance_requirement {name: 'PreConditioning'})
CREATE (sol_thermalMgmt)-[:MUST_SATISFY]->(pr_preConditioning);
// Fixed: CREATE (sol_thermalMgmt)-[:MUST_SATISFY]->(pr_peakLoadCooling)
MATCH (sol_thermalMgmt:solution {name: 'ThermalManagementSystem'})
MATCH (pr_peakLoadCooling:performance_requirement {name: 'PeakLoadCooling'})
CREATE (sol_thermalMgmt)-[:MUST_SATISFY]->(pr_peakLoadCooling);

// Fixed: CREATE (sol_stability)-[:MUST_SATISFY]->(pr_responseTime)
MATCH (sol_stability:solution {name: 'StabilityAndSafety'})
MATCH (pr_responseTime:performance_requirement {name: 'ResponseTime'})
CREATE (sol_stability)-[:MUST_SATISFY]->(pr_responseTime);
// Fixed: CREATE (sol_stability)-[:MUST_SATISFY]->(pr_rolloverPrev)
MATCH (sol_stability:solution {name: 'StabilityAndSafety'})
MATCH (pr_rolloverPrev:performance_requirement {name: 'RolloverPrevention'})
CREATE (sol_stability)-[:MUST_SATISFY]->(pr_rolloverPrev);
// Fixed: CREATE (sol_stability)-[:MUST_SATISFY]->(pr_speedRange)
MATCH (sol_stability:solution {name: 'StabilityAndSafety'})
MATCH (pr_speedRange:performance_requirement {name: 'SpeedRange'})
CREATE (sol_stability)-[:MUST_SATISFY]->(pr_speedRange);

// Fixed: CREATE (sol_vehicleControl)-[:MUST_SATISFY]->(pr_controlLoopRate)
MATCH (sol_vehicleControl:solution {name: 'VehicleControlAndCoordination'})
MATCH (pr_controlLoopRate:performance_requirement {name: 'ControlLoopRate'})
CREATE (sol_vehicleControl)-[:MUST_SATISFY]->(pr_controlLoopRate);
// Fixed: CREATE (sol_vehicleControl)-[:MUST_SATISFY]->(pr_diagnosticsSupport)
MATCH (sol_vehicleControl:solution {name: 'VehicleControlAndCoordination'})
MATCH (pr_diagnosticsSupport:performance_requirement {name: 'DiagnosticsSupport'})
CREATE (sol_vehicleControl)-[:MUST_SATISFY]->(pr_diagnosticsSupport);
// Fixed: CREATE (sol_vehicleControl)-[:MUST_SATISFY]->(pr_bootTime)
MATCH (sol_vehicleControl:solution {name: 'VehicleControlAndCoordination'})
MATCH (pr_bootTime:performance_requirement {name: 'BootTime'})
CREATE (sol_vehicleControl)-[:MUST_SATISFY]->(pr_bootTime);

// Fixed: CREATE (sol_adas)-[:MUST_SATISFY]->(pr_detectionRange)
MATCH (sol_adas:solution {name: 'AdvancedDriverAssistanceSystems'})
MATCH (pr_detectionRange:performance_requirement {name: 'DetectionRange'})
CREATE (sol_adas)-[:MUST_SATISFY]->(pr_detectionRange);
// Fixed: CREATE (sol_adas)-[:MUST_SATISFY]->(pr_laneKeepingAccuracy)
MATCH (sol_adas:solution {name: 'AdvancedDriverAssistanceSystems'})
MATCH (pr_laneKeepingAccuracy:performance_requirement {name: 'LaneKeepingAccuracy'})
CREATE (sol_adas)-[:MUST_SATISFY]->(pr_laneKeepingAccuracy);
// Fixed: CREATE (sol_adas)-[:MUST_SATISFY]->(pr_brakingActivation)
MATCH (sol_adas:solution {name: 'AdvancedDriverAssistanceSystems'})
MATCH (pr_brakingActivation:performance_requirement {name: 'BrakingActivation'})
CREATE (sol_adas)-[:MUST_SATISFY]->(pr_brakingActivation);

// Fixed: CREATE (sol_energyRecovery)-[:MUST_SATISFY]->(pr_stoppingDistance)
MATCH (sol_energyRecovery:solution {name: 'EnergyRecoveryAndBraking'})
MATCH (pr_stoppingDistance:performance_requirement {name: 'StoppingDistance'})
CREATE (sol_energyRecovery)-[:MUST_SATISFY]->(pr_stoppingDistance);
// Fixed: CREATE (sol_energyRecovery)-[:MUST_SATISFY]->(pr_energyRecovery)
MATCH (sol_energyRecovery:solution {name: 'EnergyRecoveryAndBraking'})
MATCH (pr_energyRecovery:performance_requirement {name: 'EnergyRecovery'})
CREATE (sol_energyRecovery)-[:MUST_SATISFY]->(pr_energyRecovery);
// Fixed: CREATE (sol_energyRecovery)-[:MUST_SATISFY]->(pr_brakeResponseTime)
MATCH (sol_energyRecovery:solution {name: 'EnergyRecoveryAndBraking'})
MATCH (pr_brakeResponseTime:performance_requirement {name: 'ResponseTime'})
CREATE (sol_energyRecovery)-[:MUST_SATISFY]->(pr_brakeResponseTime);

// ==========================
// Create Solution to Resource Requirement Relationships
// ==========================

// Fixed: CREATE (sol_energyStorage)-[:MUST_SATISFY]->(rr_bmsPower)
MATCH (sol_energyStorage:solution {name: 'EnergyStorageAndManagement'})
MATCH (rr_bmsPower:ressource_requirement {name: 'PowerConsumption'})
CREATE (sol_energyStorage)-[:MUST_SATISFY]->(rr_bmsPower);
// Fixed: CREATE (sol_energyStorage)-[:MUST_SATISFY]->(rr_bmsOpTemp)
MATCH (sol_energyStorage:solution {name: 'EnergyStorageAndManagement'})
MATCH (rr_bmsOpTemp:ressource_requirement {name: 'OperatingTemperature'})
CREATE (sol_energyStorage)-[:MUST_SATISFY]->(rr_bmsOpTemp);

// Fixed: CREATE (sol_powerConversion)-[:MUST_SATISFY]->(rr_powertrainEff)
MATCH (sol_powerConversion:solution {name: 'PowerConversionAndPropulsion'})
MATCH (rr_powertrainEff:ressource_requirement {name: 'PowertrainEfficiency'})
CREATE (sol_powerConversion)-[:MUST_SATISFY]->(rr_powertrainEff);
// Fixed: CREATE (sol_powerConversion)-[:MUST_SATISFY]->(rr_emiEmissions)
MATCH (sol_powerConversion:solution {name: 'PowerConversionAndPropulsion'})
MATCH (rr_emiEmissions:ressource_requirement {name: 'EMIEmissions'})
CREATE (sol_powerConversion)-[:MUST_SATISFY]->(rr_emiEmissions);

// Fixed: CREATE (sol_thermalMgmt)-[:MUST_SATISFY]->(rr_energyUsage)
MATCH (sol_thermalMgmt:solution {name: 'ThermalManagementSystem'})
MATCH (rr_energyUsage:ressource_requirement {name: 'EnergyUsage'})
CREATE (sol_thermalMgmt)-[:MUST_SATISFY]->(rr_energyUsage);
// Fixed: CREATE (sol_thermalMgmt)-[:MUST_SATISFY]->(rr_refrigerantGWP)
MATCH (sol_thermalMgmt:solution {name: 'ThermalManagementSystem'})
MATCH (rr_refrigerantGWP:ressource_requirement {name: 'RefrigerantGWP'})
CREATE (sol_thermalMgmt)-[:MUST_SATISFY]->(rr_refrigerantGWP);

// Fixed: CREATE (sol_stability)-[:MUST_SATISFY]->(rr_espPowerDraw)
MATCH (sol_stability:solution {name: 'StabilityAndSafety'})
MATCH (rr_espPowerDraw:ressource_requirement {name: 'PowerDraw'})
CREATE (sol_stability)-[:MUST_SATISFY]->(rr_espPowerDraw);
// Fixed: CREATE (sol_stability)-[:MUST_SATISFY]->(rr_espOpTemp)
MATCH (sol_stability:solution {name: 'StabilityAndSafety'})
MATCH (rr_espOpTemp:ressource_requirement {name: 'OperatingTemperature'})
CREATE (sol_stability)-[:MUST_SATISFY]->(rr_espOpTemp);

// Fixed: CREATE (sol_vehicleControl)-[:MUST_SATISFY]->(rr_vcuPower)
MATCH (sol_vehicleControl:solution {name: 'VehicleControlAndCoordination'})
MATCH (rr_vcuPower:ressource_requirement {name: 'PowerConsumption'})
CREATE (sol_vehicleControl)-[:MUST_SATISFY]->(rr_vcuPower);
// Fixed: CREATE (sol_vehicleControl)-[:MUST_SATISFY]->(rr_processorGrade)
MATCH (sol_vehicleControl:solution {name: 'VehicleControlAndCoordination'})
MATCH (rr_processorGrade:ressource_requirement {name: 'ProcessorGrade'})
CREATE (sol_vehicleControl)-[:MUST_SATISFY]->(rr_processorGrade);

// Fixed: CREATE (sol_adas)-[:MUST_SATISFY]->(rr_adasPowerDraw)
MATCH (sol_adas:solution {name: 'AdvancedDriverAssistanceSystems'})
MATCH (rr_adasPowerDraw:ressource_requirement {name: 'PowerDraw'})
CREATE (sol_adas)-[:MUST_SATISFY]->(rr_adasPowerDraw);
// Fixed: CREATE (sol_adas)-[:MUST_SATISFY]->(rr_sensorGrade)
MATCH (sol_adas:solution {name: 'AdvancedDriverAssistanceSystems'})
MATCH (rr_sensorGrade:ressource_requirement {name: 'SensorGrade'})
CREATE (sol_adas)-[:MUST_SATISFY]->(rr_sensorGrade);

// Fixed: CREATE (sol_energyRecovery)-[:MUST_SATISFY]->(rr_brakePowerDraw)
MATCH (sol_energyRecovery:solution {name: 'EnergyRecoveryAndBraking'})
MATCH (rr_brakePowerDraw:ressource_requirement {name: 'PowerDraw'})
CREATE (sol_energyRecovery)-[:MUST_SATISFY]->(rr_brakePowerDraw);
// Fixed: CREATE (sol_energyRecovery)-[:MUST_SATISFY]->(rr_brakeMaterials)
MATCH (sol_energyRecovery:solution {name: 'EnergyRecoveryAndBraking'})
MATCH (rr_brakeMaterials:ressource_requirement {name: 'BrakeMaterials'})
CREATE (sol_energyRecovery)-[:MUST_SATISFY]->(rr_brakeMaterials);

// ==========================
// Create Product to Design Requirement Relationships
// ==========================

// Fixed: CREATE (p_bmsECU)-[:MUST_SATISFY]->(dr_pcbArea)
MATCH (p_bmsECU:product {name: 'BatteryManagementSystemECU'})
MATCH (dr_pcbArea:design_requirement {name: 'PCBArea'})
CREATE (p_bmsECU)-[:MUST_SATISFY]->(dr_pcbArea);
// Fixed: CREATE (p_bmsECU)-[:MUST_SATISFY]->(dr_modularSupport)
MATCH (p_bmsECU:product {name: 'BatteryManagementSystemECU'})
MATCH (dr_modularSupport:design_requirement {name: 'ModularSupport'})
CREATE (p_bmsECU)-[:MUST_SATISFY]->(dr_modularSupport);

// Fixed: CREATE (p_motor)-[:MUST_SATISFY]->(dr_motorMass)
MATCH (p_motor:product {name: 'ElectricDriveMotor'})
MATCH (dr_motorMass:design_requirement {name: 'MotorMass'})
CREATE (p_motor)-[:MUST_SATISFY]->(dr_motorMass);
// Fixed: CREATE (p_motor)-[:MUST_SATISFY]->(dr_systemVolume)
MATCH (p_motor:product {name: 'ElectricDriveMotor'})
MATCH (dr_systemVolume:design_requirement {name: 'SystemVolume'})
CREATE (p_motor)-[:MUST_SATISFY]->(dr_systemVolume);

// Fixed: CREATE (p_thermalController)-[:MUST_SATISFY]->(dr_systemMass)
MATCH (p_thermalController:product {name: 'ThermalManagementController'})
MATCH (dr_systemMass:design_requirement {name: 'SystemMass'})
CREATE (p_thermalController)-[:MUST_SATISFY]->(dr_systemMass);
// Fixed: CREATE (p_thermalController)-[:MUST_SATISFY]->(dr_thermalSystemVol)
MATCH (p_thermalController:product {name: 'ThermalManagementController'})
MATCH (dr_thermalSystemVol:design_requirement {name: 'SystemVolume'})
CREATE (p_thermalController)-[:MUST_SATISFY]->(dr_thermalSystemVol);

// Fixed: CREATE (p_espECU)-[:MUST_SATISFY]->(dr_controllerFit)
MATCH (p_espECU:product {name: 'ABSESPECU'})
MATCH (dr_controllerFit:design_requirement {name: 'ControllerFit'})
CREATE (p_espECU)-[:MUST_SATISFY]->(dr_controllerFit);
// Fixed: CREATE (p_wheelSensors)-[:MUST_SATISFY]->(dr_sensorWiring)
MATCH (p_wheelSensors:product {name: 'WheelSpeedSensors'})
MATCH (dr_sensorWiring:design_requirement {name: 'SensorWiring'})
CREATE (p_wheelSensors)-[:MUST_SATISFY]->(dr_sensorWiring);

// Fixed: CREATE (p_vcu)-[:MUST_SATISFY]->(dr_vcuPcbArea)
MATCH (p_vcu:product {name: 'VehicleControlUnit'})
MATCH (dr_vcuPcbArea:design_requirement {name: 'PCBArea'})
CREATE (p_vcu)-[:MUST_SATISFY]->(dr_vcuPcbArea);
// Fixed: CREATE (p_vcu)-[:MUST_SATISFY]->(dr_softwareModularity)
MATCH (p_vcu:product {name: 'VehicleControlUnit'})
MATCH (dr_softwareModularity:design_requirement {name: 'SoftwareModularity'})
CREATE (p_vcu)-[:MUST_SATISFY]->(dr_softwareModularity);

// Fixed: CREATE (p_adasECU)-[:MUST_SATISFY]->(dr_ecuVolume)
MATCH (p_adasECU:product {name: 'ADASECU'})
MATCH (dr_ecuVolume:design_requirement {name: 'ECUVolume'})
CREATE (p_adasECU)-[:MUST_SATISFY]->(dr_ecuVolume);
// Fixed: CREATE (p_camera)-[:MUST_SATISFY]->(dr_sensorIntegration)
MATCH (p_camera:product {name: 'FrontCamera'})
MATCH (dr_sensorIntegration:design_requirement {name: 'SensorIntegration'})
CREATE (p_camera)-[:MUST_SATISFY]->(dr_sensorIntegration);
// Fixed: CREATE (p_radar)-[:MUST_SATISFY]->(dr_sensorIntegration)
MATCH (p_radar:product {name: 'RadarSensor'})
MATCH (dr_sensorIntegration:design_requirement {name: 'SensorIntegration'})
CREATE (p_radar)-[:MUST_SATISFY]->(dr_sensorIntegration);
// Fixed: CREATE (p_lidar)-[:MUST_SATISFY]->(dr_sensorIntegration)
MATCH (p_lidar:product {name: 'LidarSensor'})
MATCH (dr_sensorIntegration:design_requirement {name: 'SensorIntegration'})
CREATE (p_lidar)-[:MUST_SATISFY]->(dr_sensorIntegration);
// Fixed: CREATE (p_ultrasonics)-[:MUST_SATISFY]->(dr_sensorIntegration)
MATCH (p_ultrasonics:product {name: 'UltrasonicSensors'})
MATCH (dr_sensorIntegration:design_requirement {name: 'SensorIntegration'})
CREATE (p_ultrasonics)-[:MUST_SATISFY]->(dr_sensorIntegration);

// Fixed: CREATE (p_brakeActuator)-[:MUST_SATISFY]->(dr_caliperMass)
MATCH (p_brakeActuator:product {name: 'HydraulicBrakeActuator'})
MATCH (dr_caliperMass:design_requirement {name: 'CaliperMass'})
CREATE (p_brakeActuator)-[:MUST_SATISFY]->(dr_caliperMass);
// Fixed: CREATE (p_brakeActuator)-[:MUST_SATISFY]->(dr_systemFit)
MATCH (p_brakeActuator:product {name: 'HydraulicBrakeActuator'})
MATCH (dr_systemFit:design_requirement {name: 'SystemFit'})
CREATE (p_brakeActuator)-[:MUST_SATISFY]->(dr_systemFit);

// ==========================
// Create Top-Level Product (Vehicle)
// ==========================

CREATE (p_vehicle:product {
    name: 'BatteryElectricVehicle',
    description: 'Complete battery electric vehicle system',
    label: 'Battery Electric Vehicle'
})

// Top-level vehicle is composed of all major systems
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_batteryPack)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_batteryPack:product {name: 'BatteryPack'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_batteryPack);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_bmsECU)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_bmsECU:product {name: 'BatteryManagementSystemECU'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_bmsECU);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_cellSensors)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_cellSensors:product {name: 'CellVoltageTempSensors'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_cellSensors);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_inverter)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_inverter:product {name: 'MainInverter'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_inverter);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_motor)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_motor:product {name: 'ElectricDriveMotor'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_motor);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_transmission)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_transmission:product {name: 'TransmissionGearbox'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_transmission);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_charger)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_charger:product {name: 'OnBoardCharger'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_charger);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_dcConverter)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_dcConverter:product {name: 'DCDCConverter'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_dcConverter);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_vcu)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_vcu:product {name: 'VehicleControlUnit'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_vcu);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_thermalController)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_thermalController:product {name: 'ThermalManagementController'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_thermalController);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_coolantPump)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_coolantPump:product {name: 'CoolantPump'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_coolantPump);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_batteryHeater)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_batteryHeater:product {name: 'BatteryHeater'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_batteryHeater);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_hvac)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_hvac:product {name: 'HVACUnit'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_hvac);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_wheelSensors)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_wheelSensors:product {name: 'WheelSpeedSensors'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_wheelSensors);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_steeringSensor)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_steeringSensor:product {name: 'SteeringAngleSensor'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_steeringSensor);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_yawSensor)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_yawSensor:product {name: 'YawRateSensor'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_yawSensor);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_brakeActuator)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_brakeActuator:product {name: 'HydraulicBrakeActuator'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_brakeActuator);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_brakeSensor)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_brakeSensor:product {name: 'BrakePedalSensor'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_brakeSensor);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_regenController)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_regenController:product {name: 'RegenerativeBrakingController'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_regenController);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_espECU)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_espECU:product {name: 'ABSESPECU'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_espECU);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_adasECU)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_adasECU:product {name: 'ADASECU'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_adasECU);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_camera)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_camera:product {name: 'FrontCamera'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_camera);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_radar)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_radar:product {name: 'RadarSensor'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_radar);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_ultrasonics)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_ultrasonics:product {name: 'UltrasonicSensors'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_ultrasonics);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_lidar)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_lidar:product {name: 'LidarSensor'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_lidar);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_headUnit)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_headUnit:product {name: 'InfotainmentHeadUnit'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_headUnit);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_telematics)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_telematics:product {name: 'TelematicsControlUnit'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_telematics);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_canBus)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_canBus:product {name: 'CANBusNetwork'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_canBus);
// Fixed: CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_powerDist)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (p_powerDist:product {name: 'HighVoltagePowerDistributionUnit'})
CREATE (p_vehicle)-[:IS_COMPOSED_OF]->(p_powerDist);

// Connect top-level vehicle to overall vehicle design requirements
// Fixed: CREATE (p_vehicle)-[:MUST_SATISFY]->(dr_curbWeight)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (dr_curbWeight:design_requirement {name: 'CurbWeight'})
CREATE (p_vehicle)-[:MUST_SATISFY]->(dr_curbWeight);
// Fixed: CREATE (p_vehicle)-[:MUST_SATISFY]->(dr_passengerCap)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (dr_passengerCap:design_requirement {name: 'PassengerCapacity'})
CREATE (p_vehicle)-[:MUST_SATISFY]->(dr_passengerCap);
// Fixed: CREATE (p_vehicle)-[:MUST_SATISFY]->(dr_luggageVol)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (dr_luggageVol:design_requirement {name: 'LuggageVolume'})
CREATE (p_vehicle)-[:MUST_SATISFY]->(dr_luggageVol);
// Fixed: CREATE (p_vehicle)-[:MUST_SATISFY]->(dr_safetyStandards)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (dr_safetyStandards:design_requirement {name: 'SafetyStandards'})
CREATE (p_vehicle)-[:MUST_SATISFY]->(dr_safetyStandards);
// Fixed: CREATE (p_vehicle)-[:MUST_SATISFY]->(dr_exteriorLength)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (dr_exteriorLength:design_requirement {name: 'ExteriorLength'})
CREATE (p_vehicle)-[:MUST_SATISFY]->(dr_exteriorLength);

// Connect vehicle to overall solution
// Fixed: CREATE (p_vehicle)-[:REALIZES]->(sol_overallSystem)
MATCH (p_vehicle:product {name: 'BatteryElectricVehicle'})
MATCH (sol_overallSystem:solution {name: 'OverallVehicleSystem'})
CREATE (p_vehicle)-[:REALIZES]->(sol_overallSystem);

// ==========================
// Create Models and their relationships
// ==========================

// Note: The SysML model doesn't explicitly define models, but based on typical engineering practice,
// we can create high-level models for simulation and analysis

CREATE (m_batteryModel:model {
    name: 'BatteryThermalModel',
    description: 'Thermal and electrical simulation model for battery pack',
    label: 'Battery Thermal Model',
    fidelity: 'High',
    purpose: 'Performance and safety analysis',
    scope: 'Battery pack thermal behavior'
})

CREATE (m_powertrainModel:model {
    name: 'PowertrainEfficiencyModel',
    description: 'Efficiency and performance model for electric powertrain',
    label: 'Powertrain Efficiency Model',
    fidelity: 'High',
    purpose: 'Performance optimization',
    scope: 'Motor and inverter efficiency'
})

CREATE (m_vehicleDynamicsModel:model {
    name: 'VehicleDynamicsModel',
    description: 'Dynamic behavior model for vehicle stability and control',
    label: 'Vehicle Dynamics Model',
    fidelity: 'Medium',
    purpose: 'Stability and control analysis',
    scope: 'Full vehicle dynamics'
})

// Connect models to solutions
// Fixed: CREATE (sol_energyStorage)-[:HAS]->(m_batteryModel)
MATCH (sol_energyStorage:solution {name: 'EnergyStorageAndManagement'})
MATCH (m_batteryModel:model {name: 'BatteryThermalModel'})
CREATE (sol_energyStorage)-[:HAS]->(m_batteryModel);
// Fixed: CREATE (sol_powerConversion)-[:HAS]->(m_powertrainModel)
MATCH (sol_powerConversion:solution {name: 'PowerConversionAndPropulsion'})
MATCH (m_powertrainModel:model {name: 'PowertrainEfficiencyModel'})
CREATE (sol_powerConversion)-[:HAS]->(m_powertrainModel);
// Fixed: CREATE (sol_stability)-[:HAS]->(m_vehicleDynamicsModel)
MATCH (sol_stability:solution {name: 'StabilityAndSafety'})
MATCH (m_vehicleDynamicsModel:model {name: 'VehicleDynamicsModel'})
CREATE (sol_stability)-[:HAS]->(m_vehicleDynamicsModel);

// Create model inputs and outputs
CREATE (mi_batteryTemp:model_input {
    name: 'BatteryTemperature',
    description: 'Battery cell temperature input',
    label: 'Battery Temperature Input',
    value: '15-35°C'
})
CREATE (mi_batteryCurrent:model_input {
    name: 'BatteryCurrent',
    description: 'Battery discharge current',
    label: 'Battery Current Input',
    value: '0-400A'
})
CREATE (mo_batteryLife:model_output {
    name: 'BatteryLifePrediction',
    description: 'Predicted battery lifecycle',
    label: 'Battery Life Output',
    value: '1500+ cycles'
})

// Fixed: CREATE (m_batteryModel)-[:HAS]->(mi_batteryTemp)
MATCH (m_batteryModel:model {name: 'BatteryThermalModel'})
MATCH (mi_batteryTemp:model_input {name: 'BatteryTemperature'})
CREATE (m_batteryModel)-[:HAS]->(mi_batteryTemp);
// Fixed: CREATE (m_batteryModel)-[:HAS]->(mi_batteryCurrent)
MATCH (m_batteryModel:model {name: 'BatteryThermalModel'})
MATCH (mi_batteryCurrent:model_input {name: 'BatteryCurrent'})
CREATE (m_batteryModel)-[:HAS]->(mi_batteryCurrent);
// Fixed: CREATE (m_batteryModel)-[:HAS]->(mo_batteryLife)
MATCH (m_batteryModel:model {name: 'BatteryThermalModel'})
MATCH (mo_batteryLife:model_output {name: 'BatteryLifePrediction'})
CREATE (m_batteryModel)-[:HAS]->(mo_batteryLife);

CREATE (mi_motorTorque:model_input {
    name: 'MotorTorque',
    description: 'Electric motor torque demand',
    label: 'Motor Torque Input',
    value: '0-350Nm'
})
CREATE (mi_motorSpeed:model_input {
    name: 'MotorSpeed',
    description: 'Electric motor rotation speed',
    label: 'Motor Speed Input',
    value: '0-15000rpm'
})
CREATE (mo_efficiency:model_output {
    name: 'PowertrainEfficiency',
    description: 'Calculated powertrain efficiency',
    label: 'Efficiency Output',
    value: '>90%'
})

// Fixed: CREATE (m_powertrainModel)-[:HAS]->(mi_motorTorque)
MATCH (m_powertrainModel:model {name: 'PowertrainEfficiencyModel'})
MATCH (mi_motorTorque:model_input {name: 'MotorTorque'})
CREATE (m_powertrainModel)-[:HAS]->(mi_motorTorque);
// Fixed: CREATE (m_powertrainModel)-[:HAS]->(mi_motorSpeed)
MATCH (m_powertrainModel:model {name: 'PowertrainEfficiencyModel'})
MATCH (mi_motorSpeed:model_input {name: 'MotorSpeed'})
CREATE (m_powertrainModel)-[:HAS]->(mi_motorSpeed);
// Fixed: CREATE (m_powertrainModel)-[:HAS]->(mo_efficiency)
MATCH (m_powertrainModel:model {name: 'PowertrainEfficiencyModel'})
MATCH (mo_efficiency:model_output {name: 'PowertrainEfficiency'})
CREATE (m_powertrainModel)-[:HAS]->(mo_efficiency);

CREATE (mi_vehicleSpeed:model_input {
    name: 'VehicleSpeed',
    description: 'Vehicle speed input',
    label: 'Vehicle Speed Input',
    value: '0-200km/h'
})
CREATE (mi_steeringAngle:model_input {
    name: 'SteeringAngle',
    description: 'Steering wheel angle input',
    label: 'Steering Angle Input',
    value: '±720°'
})
CREATE (mo_stability:model_output {
    name: 'StabilityFactor',
    description: 'Vehicle stability calculation',
    label: 'Stability Output',
    value: 'Stable/Unstable'
})

// Fixed: CREATE (m_vehicleDynamicsModel)-[:HAS]->(mi_vehicleSpeed)
MATCH (m_vehicleDynamicsModel:model {name: 'VehicleDynamicsModel'})
MATCH (mi_vehicleSpeed:model_input {name: 'VehicleSpeed'})
CREATE (m_vehicleDynamicsModel)-[:HAS]->(mi_vehicleSpeed);
// Fixed: CREATE (m_vehicleDynamicsModel)-[:HAS]->(mi_steeringAngle)
MATCH (m_vehicleDynamicsModel:model {name: 'VehicleDynamicsModel'})
MATCH (mi_steeringAngle:model_input {name: 'SteeringAngle'})
CREATE (m_vehicleDynamicsModel)-[:HAS]->(mi_steeringAngle);
// Fixed: CREATE (m_vehicleDynamicsModel)-[:HAS]->(mo_stability);
MATCH (m_vehicleDynamicsModel:model {name: 'VehicleDynamicsModel'})
MATCH (mo_stability:model_output {name: 'StabilityFactor'})
CREATE (m_vehicleDynamicsModel)-[:HAS]->(mo_stability);

// End of Cypher script


// ==========================
// Cypher Script Fix Summary
// ==========================
// Total nodes registered: 362
// Total relationships fixed: 384