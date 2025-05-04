package 'BatteryElectricVehicle' {
    import ScalarValues::*;

    // Requirements
    package Requirements {
        // Overall Vehicle Requirements
        requirement def 'OverallVehicleRequirements' {
            doc /* Overall requirements for the battery electric vehicle */

            requirement 'FunctionalRequirements' {
                requirement 'UserAuthentication' {
                    doc /* Must support user authentication and keyless entry. */
                }
                requirement 'RealTimeDiagnostics' {
                    doc /* Shall provide real-time vehicle diagnostics to the driver. */
                }
                requirement 'RemoteSoftwareUpdates' {
                    doc /* Must enable remote software updates. */
                }
                requirement 'MobileAppIntegration' {
                    doc /* Shall integrate with mobile applications for remote monitoring. */
                }
                requirement 'RegulatoryCompliance' {
                    doc /* Must comply with all regional safety and emissions regulations. */
                }
                requirement 'RegenerativeBraking' {
                    doc /* Shall provide regenerative braking functionality. */
                }
                requirement 'ChargingStandards' {
                    doc /* Must support multiple charging standards (e.g., CCS, CHAdeMO). */
                }
                requirement 'OTAUpdates' {
                    doc /* Shall provide over-the-air (OTA) firmware updates. */
                }
                requirement 'UserFriendlyHMI' {
                    doc /* Must have a user-friendly human-machine interface (HMI). */
                }
                requirement 'WirelessConnectivity' {
                    doc /* Must support wireless connectivity (Bluetooth, Wi-Fi, cellular). */
                }
            }

            requirement 'PerformanceRequirements' {
                requirement 'DrivingRange' {
                    doc /* Must achieve a minimum driving range of 400 km per charge (target for 2030: >600 km). */
                }
                requirement 'Acceleration' {
                    doc /* Shall accelerate from 0–100 km/h in less than 8 seconds. */
                }
                requirement 'TopSpeed' {
                    doc /* Must support a top speed of at least 160 km/h. */
                }
                requirement 'BrakingDistance' {
                    doc /* Shall provide a minimum braking distance of 40 m from 100 km/h. */
                }
                requirement 'TemperaturePerformance' {
                    doc /* Must maintain full performance in ambient temperatures from -30°C to +50°C. */
                }
                requirement 'FastCharging' {
                    doc /* Shall support fast charging to 80% within 30 minutes. */
                }
            }

            requirement 'ResourceRequirements' {
                requirement 'EnergyConsumption' {
                    doc /* Energy consumption must not exceed 16 kWh/100 km. */
                }
                requirement 'MaterialCompliance' {
                    doc /* Shall use materials compliant with environmental regulations (e.g., RoHS, REACH). */
                }
                requirement 'Recyclability' {
                    doc /* Must achieve at least 95% recyclability of vehicle components. */
                }
                requirement 'RareEarthMinimization' {
                    doc /* Shall minimize rare earth element usage in motors and batteries. */
                }
            }

            requirement 'DesignRequirements' {
                requirement 'CurbWeight' {
                    doc /* Vehicle curb weight must not exceed 2,000 kg. */
                }
                requirement 'PassengerCapacity' {
                    doc /* Must accommodate at least five passengers. */
                }
                requirement 'LuggageVolume' {
                    doc /* Shall provide a minimum luggage volume of 400 liters. */
                }
                requirement 'SafetyStandards' {
                    doc /* Must meet Euro NCAP 5-star safety standards. */
                }
                requirement 'ExteriorLength' {
                    doc /* Shall have a maximum exterior length of 4.8 meters. */
                }
            }
        }

        // Vehicle Propulsion Requirements
        requirement def 'VehiclePropulsionRequirements' {
            requirement 'FunctionalRequirements' {
                requirement 'SeamlessTorqueDelivery' {
                    doc /* Must provide seamless torque delivery from standstill. */
                }
                requirement 'DriveModesSupport' {
                    doc /* Shall support both forward and reverse drive modes. */
                }
                requirement 'RegenBrakingIntegration' {
                    doc /* Must integrate with regenerative braking system. */
                }
                requirement 'HillAssist' {
                    doc /* Shall enable hill-hold and hill-start assist features. */
                }
            }

            requirement 'PerformanceRequirements' {
                requirement 'PeakPower' {
                    doc /* Must deliver a peak power output of at least 150 kW. */
                }
                requirement 'MaxTorque' {
                    doc /* Shall provide a maximum torque of 350 Nm. */
                }
                requirement 'ContinuousOperation' {
                    doc /* Must support continuous operation at 80% rated power for at least 30 minutes. */
                }
                requirement 'Gradeability' {
                    doc /* Shall support a minimum gradeability of 20% at full load. */
                }
            }

            requirement 'ResourceRequirements' {
                requirement 'PowertrainEfficiency' {
                    doc /* Powertrain efficiency must exceed 90% under typical driving cycles. */
                }
                requirement 'EMIEmissions' {
                    doc /* Shall minimize electromagnetic interference (EMI) emissions. */
                }
            }

            requirement 'DesignRequirements' {
                requirement 'MotorMass' {
                    doc /* Electric motor mass must not exceed 80 kg. */
                }
                requirement 'SystemVolume' {
                    doc /* Propulsion system must fit within a 0.2 m³ volume. */
                }
            }
        }

        // Battery Management System Requirements
        requirement def 'BMSRequirements' {
            requirement 'FunctionalRequirements' {
                requirement 'CellMonitoring' {
                    doc /* Must monitor cell voltage, current, and temperature in real time. */
                }
                requirement 'StateEstimation' {
                    doc /* Shall estimate State of Charge (SOC) and State of Health (SOH) accurately. */
                }
                requirement 'CellBalancing' {
                    doc /* Must perform active cell balancing. */
                }
                requirement 'FaultDetection' {
                    doc /* Shall detect and report faults (overvoltage, undervoltage, overtemperature, short circuit). */
                }
                requirement 'ThermalControl' {
                    doc /* Must provide thermal management control signals. */
                }
                requirement 'SafetyCompliance' {
                    doc /* Shall comply with ISO 26262 functional safety standards. */
                }
                requirement 'DataLogging' {
                    doc /* Must log operational data for diagnostics. */
                }
            }

            requirement 'PerformanceRequirements' {
                requirement 'ChargeDischargeRate' {
                    doc /* Shall support charge/discharge rates up to 4C for peak power events. */
                }
                requirement 'VoltageTolerance' {
                    doc /* Must maintain cell voltage within ±0.02 V tolerance. */
                }
                requirement 'ThermalRunawayDetection' {
                    doc /* Shall detect thermal runaway within 1 second. */
                }
                requirement 'CycleLife' {
                    doc /* Must support a battery cycle life of at least 1,500 full cycles. */
                }
            }

            requirement 'ResourceRequirements' {
                requirement 'PowerConsumption' {
                    doc /* BMS power consumption must not exceed 5 W. */
                }
                requirement 'OperatingTemperature' {
                    doc /* Shall operate reliably from -40°C to +85°C. */
                }
            }

            requirement 'DesignRequirements' {
                requirement 'PCBArea' {
                    doc /* BMS PCB area must not exceed 250 cm². */
                }
                requirement 'ModularSupport' {
                    doc /* Must support modular battery pack configurations. */
                }
            }
        }

        // Thermal Management System Requirements
        requirement def 'ThermalManagementRequirements' {
            requirement 'FunctionalRequirements' {
                requirement 'ActiveThermalControl' {
                    doc /* Must actively cool or heat battery pack based on temperature thresholds. */
                }
                requirement 'HVACIntegration' {
                    doc /* Shall integrate with cabin HVAC for waste heat recovery. */
                }
                requirement 'CoolantMonitoring' {
                    doc /* Must monitor coolant flow and temperature. */
                }
                requirement 'PowerElectronicsCooling' {
                    doc /* Shall provide thermal protection for power electronics. */
                }
            }

            requirement 'PerformanceRequirements' {
                requirement 'BatteryTemperature' {
                    doc /* Must maintain battery temperature between 15°C and 35°C during operation. */
                }
                requirement 'PreConditioning' {
                    doc /* Shall support rapid pre-conditioning before fast charging. */
                }
                requirement 'PeakLoadCooling' {
                    doc /* Must achieve full battery pack cooling within 10 minutes after peak load. */
                }
            }

            requirement 'ResourceRequirements' {
                requirement 'EnergyUsage' {
                    doc /* System must use less than 1 kWh per 100 km for thermal management. */
                }
                requirement 'RefrigerantGWP' {
                    doc /* Shall utilize refrigerants with low global warming potential. */
                }
            }

            requirement 'DesignRequirements' {
                requirement 'SystemMass' {
                    doc /* Thermal system mass must not exceed 50 kg. */
                }
                requirement 'SystemVolume' {
                    doc /* Must fit within a 0.1 m³ volume envelope. */
                }
            }
        }

        // Electronic Stability Program Requirements
        requirement def 'ESPRequirements' {
            requirement 'FunctionalRequirements' {
                requirement 'SensorMonitoring' {
                    doc /* Must monitor steering angle, wheel speeds, yaw rate, and lateral acceleration. */
                }
                requirement 'StabilityIntervention' {
                    doc /* Shall intervene by reducing motor torque and/or applying individual wheel brakes. */
                }
                requirement 'TrailerStability' {
                    doc /* Must support trailer stability control. */
                }
                requirement 'DriverFeedback' {
                    doc /* Shall provide driver feedback on ESP activation. */
                }
            }

            requirement 'PerformanceRequirements' {
                requirement 'ResponseTime' {
                    doc /* Must react to loss of stability within 50 ms. */
                }
                requirement 'RolloverPrevention' {
                    doc /* Shall prevent vehicle rollover in emergency maneuvers. */
                }
                requirement 'SpeedRange' {
                    doc /* Must operate effectively at speeds from 0 to 200 km/h. */
                }
            }

            requirement 'ResourceRequirements' {
                requirement 'PowerDraw' {
                    doc /* ESP system power draw must not exceed 10 W. */
                }
                requirement 'OperatingTemperature' {
                    doc /* Shall operate in ambient temperatures from -40°C to +85°C. */
                }
            }

            requirement 'DesignRequirements' {
                requirement 'ControllerFit' {
                    doc /* ESP controller must fit within standard ECU housing. */
                }
                requirement 'SensorWiring' {
                    doc /* Sensor wiring must not exceed 5 meters in length. */
                }
            }
        }

        // Vehicle Control Solution Requirements
        requirement def 'VehicleControlRequirements' {
            requirement 'FunctionalRequirements' {
                requirement 'SystemCoordination' {
                    doc /* Must coordinate propulsion, braking, and steering systems. */
                }
                requirement 'DriveModesSupport' {
                    doc /* Shall support multiple drive modes (e.g., eco, sport, snow). */
                }
                requirement 'SystemIntegration' {
                    doc /* Must interface with ADAS and infotainment systems. */
                }
                requirement 'FailSafeOperation' {
                    doc /* Shall provide fail-safe operation in case of subsystem failure. */
                }
            }

            requirement 'PerformanceRequirements' {
                requirement 'ControlLoopRate' {
                    doc /* Control loop update rate must be at least 100 Hz. */
                }
                requirement 'DiagnosticsSupport' {
                    doc /* Shall support real-time diagnostics and fault logging. */
                }
                requirement 'BootTime' {
                    doc /* Must achieve system boot time < 2 seconds. */
                }
            }

            requirement 'ResourceRequirements' {
                requirement 'PowerConsumption' {
                    doc /* Controller power consumption must not exceed 15 W. */
                }
                requirement 'ProcessorGrade' {
                    doc /* Must use automotive-grade microcontrollers. */
                }
            }

            requirement 'DesignRequirements' {
                requirement 'PCBArea' {
                    doc /* Controller PCB area must not exceed 200 cm². */
                }
                requirement 'SoftwareModularity' {
                    doc /* Must support modular software updates. */
                }
            }
        }

        // ADAS Requirements
        requirement def 'ADASRequirements' {
            requirement 'FunctionalRequirements' {
                requirement 'CoreFeatures' {
                    doc /* Must support adaptive cruise control, lane keeping, and emergency braking. */
                }
                requirement 'SafetyFeatures' {
                    doc /* Shall provide blind spot detection and rear cross-traffic alert. */
                }
                requirement 'NavigationIntegration' {
                    doc /* Must integrate with navigation and mapping systems. */
                }
                requirement 'OTACapability' {
                    doc /* Shall enable over-the-air updates for ADAS algorithms. */
                }
            }

            requirement 'PerformanceRequirements' {
                requirement 'DetectionRange' {
                    doc /* Object detection range must exceed 150 meters. */
                }
                requirement 'LaneKeepingAccuracy' {
                    doc /* Lane keeping accuracy must be within 10 cm. */
                }
                requirement 'BrakingActivation' {
                    doc /* Emergency braking activation time must be < 100 ms. */
                }
            }

            requirement 'ResourceRequirements' {
                requirement 'PowerDraw' {
                    doc /* ADAS system power draw must not exceed 20 W. */
                }
                requirement 'SensorGrade' {
                    doc /* Shall use automotive-grade sensors (radar, lidar, cameras). */
                }
            }

            requirement 'DesignRequirements' {
                requirement 'SensorIntegration' {
                    doc /* Sensor modules must fit within standard bumper and windshield mounts. */
                }
                requirement 'ECUVolume' {
                    doc /* ADAS ECU must not exceed 1 liter in volume. */
                }
            }
        }

        // Brake System Requirements
        requirement def 'BrakeSystemRequirements' {
            requirement 'FunctionalRequirements' {
                requirement 'DualBraking' {
                    doc /* Must provide both hydraulic and regenerative braking. */
                }
                requirement 'ABSandEBD' {
                    doc /* Shall support anti-lock braking (ABS) and electronic brake-force distribution (EBD). */
                }
                requirement 'SystemIntegration' {
                    doc /* Must integrate with ESP and ADAS for coordinated interventions. */
                }
                requirement 'WearFeedback' {
                    doc /* Shall provide driver feedback on brake wear. */
                }
            }

            requirement 'PerformanceRequirements' {
                requirement 'StoppingDistance' {
                    doc /* Maximum stopping distance from 100 km/h must not exceed 40 meters. */
                }
                requirement 'EnergyRecovery' {
                    doc /* Regenerative braking must recover at least 70% of available kinetic energy. */
                }
                requirement 'ResponseTime' {
                    doc /* Brake response time must be < 50 ms. */
                }
            }

            requirement 'ResourceRequirements' {
                requirement 'PowerDraw' {
                    doc /* System power draw for electronic components must not exceed 5 W. */
                }
                requirement 'BrakeMaterials' {
                    doc /* Must use low-wear, environmentally friendly brake materials. */
                }
            }

            requirement 'DesignRequirements' {
                requirement 'CaliperMass' {
                    doc /* Brake caliper mass must not exceed 4 kg per wheel. */
                }
                requirement 'SystemFit' {
                    doc /* Brake system must fit within standard wheel dimensions. */
                }
            }
        }
    }

    // Functions
    package Functions {
        // Overall Vehicle System Functions
        package 'OverallVehicleSystemFunctions' {
            action def 'UserAuthentication' {
                doc /* Validates user identity for vehicle access */
                in keyFobSignal : ScalarValues::String;
                out accessStatus : ScalarValues::String;
            }

            action def 'RealTimeDiagnostics' {
                doc /* Monitors and reports vehicle health */
                in sensorData : ScalarValues::String;
                out diagnosticReports : ScalarValues::String;
            }

            action def 'RemoteSoftwareUpdates' {
                doc /* Updates vehicle software systems */
                in updatePackage : ScalarValues::String;
                out systemConfiguration : ScalarValues::String;
            }

            action def 'MobileAppIntegration' {
                doc /* Interfaces with user mobile applications */
                in userCommands : ScalarValues::String;
                out vehicleStatus : ScalarValues::String;
            }

            action def 'RegenerativeBrakingControl' {
                doc /* Controls energy recovery during braking */
                in brakePedalInput : ScalarValues::String;
                out energyRecoverySignal : ScalarValues::String;
            }

            action def 'ChargingStandardCompatibility' {
                doc /* Manages charging from various standards */
                in acDcPower : ScalarValues::String;
                out chargingStatus : ScalarValues::String;
            }

            action def 'HMIInteraction' {
                doc /* Handles user interface interactions */
                in touchVoiceCommands : ScalarValues::String;
                out displayFeedback : ScalarValues::String;
            }
        }

        // Vehicle Propulsion Functions
        package 'VehiclePropulsionFunctions' {
            action def 'TorqueDelivery' {
                doc /* Converts accelerator input to mechanical energy */
                in acceleratorPedalInput : ScalarValues::String;
                out mechanicalEnergy : ScalarValues::String;
            }

            action def 'ForwardReverseDriveModes' {
                doc /* Controls motor rotation direction */
                in gearSelector : ScalarValues::String;
                out motorRotationDirection : ScalarValues::String;
            }

            action def 'RegenerativeBrakingIntegration' {
                doc /* Integrates regenerative braking with propulsion */
                in brakePedalInput : ScalarValues::String;
                out energyRecoverySignal : ScalarValues::String;
            }

            action def 'HillHoldAssist' {
                doc /* Maintains brake pressure on inclines */
                in inclineSensorData : ScalarValues::String;
                out brakePressure : ScalarValues::String;
            }
        }

        // Battery Management System Functions
        package 'BMSFunctions' {
            action def 'CellVoltageMonitoring' {
                doc /* Monitors individual cell voltages */
                in cellVoltage : ScalarValues::String;
                out voltageStatus : ScalarValues::String;
            }

            action def 'SOCSOHEstimation' {
                doc /* Estimates battery state of charge and health */
                in voltageCurrentTemp : ScalarValues::String;
                out socSohReport : ScalarValues::String;
            }

            action def 'ActiveCellBalancing' {
                doc /* Balances cell voltages */
                in cellVoltage : ScalarValues::String;
                out balancingCommands : ScalarValues::String;
            }

            action def 'FaultDetection' {
                doc /* Detects and reports battery faults */
                in sensorData : ScalarValues::String;
                out faultAlerts : ScalarValues::String;
            }

            action def 'ThermalManagementControl' {
                doc /* Controls battery thermal management */
                in temperatureData : ScalarValues::String;
                out coolingHeatingCommands : ScalarValues::String;
            }

            action def 'SafetyCompliance' {
                doc /* Ensures safety compliance */
                in systemStatus : ScalarValues::String;
                out safetyShutdownSignal : ScalarValues::String;
            }

            action def 'DataLogging' {
                doc /* Logs operational data */
                in operationalData : ScalarValues::String;
                out loggedData : ScalarValues::String;
            }
        }

        // Thermal Management System Functions
        package 'ThermalManagementFunctions' {
            action def 'BatteryCoolingHeating' {
                doc /* Controls battery temperature */
                in coolantFlow : ScalarValues::String;
                out adjustedCoolantFlow : ScalarValues::String;
            }

            action def 'WasteHeatRecovery' {
                doc /* Recovers waste heat from systems */
                in cabinHVACData : ScalarValues::String;
                out heatRedistribution : ScalarValues::String;
            }

            action def 'CoolantFlowMonitoring' {
                doc /* Monitors coolant system */
                in flowSensorData : ScalarValues::String;
                out flowRateAlerts : ScalarValues::String;
            }

            action def 'PowerElectronicsCooling' {
                doc /* Cools power electronics */
                in temperatureData : ScalarValues::String;
                out fanPumpControl : ScalarValues::String;
            }
        }

        // Electronic Stability Program Functions
        package 'ESPFunctions' {
            action def 'YawRateMonitoring' {
                doc /* Monitors vehicle rotation */
                in gyroscopeData : ScalarValues::String;
                out stabilityStatus : ScalarValues::String;
            }

            action def 'TorqueReduction' {
                doc /* Reduces motor torque for stability */
                in stabilityLossSignal : ScalarValues::String;
                out motorTorqueLimit : ScalarValues::String;
            }

            action def 'IndividualWheelBraking' {
                doc /* Controls individual wheel brakes */
                in wheelSpeed : ScalarValues::String;
                out brakePressureAdjustment : ScalarValues::String;
            }

            action def 'TrailerStabilityControl' {
                doc /* Stabilizes trailer motion */
                in trailerMotionData : ScalarValues::String;
                out brakeTorqueAdjustments : ScalarValues::String;
            }
        }

        // Vehicle Control Solution Functions
        package 'VehicleControlFunctions' {
            action def 'DriveModeCoordination' {
                doc /* Coordinates drive modes */
                in modeSelector : ScalarValues::String;
                out powertrainConfiguration : ScalarValues::String;
            }

            action def 'SubsystemIntegration' {
                doc /* Integrates vehicle subsystems */
                in vcuCommands : ScalarValues::String;
                out brakePropulsionSignals : ScalarValues::String;
            }

            action def 'FailSafeActivation' {
                doc /* Activates fail-safe modes */
                in faultAlerts : ScalarValues::String;
                out emergencyShutdown : ScalarValues::String;
            }

            action def 'RealTimeDiagnostics' {
                doc /* Provides real-time system diagnostics */
                in sensorData : ScalarValues::String;
                out systemHealthReport : ScalarValues::String;
            }
        }

        // ADAS Functions
        package 'ADASFunctions' {
            action def 'AdaptiveCruiseControl' {
                doc /* Maintains safe following distance */
                in radarCameraData : ScalarValues::String;
                out speedAdjustment : ScalarValues::String;
            }

            action def 'LaneKeepingAssist' {
                doc /* Keeps vehicle in lane */
                in cameraData : ScalarValues::String;
                out steeringCorrection : ScalarValues::String;
            }

            action def 'EmergencyBraking' {
                doc /* Applies brakes to avoid collision */
                in objectDetection : ScalarValues::String;
                out brakeActuation : ScalarValues::String;
            }

            action def 'BlindSpotDetection' {
                doc /* Detects vehicles in blind spots */
                in ultrasonicSensorData : ScalarValues::String;
                out visualAudibleAlert : ScalarValues::String;
            }
        }

        // Brake System Functions
        package 'BrakeSystemFunctions' {
            action def 'HydraulicBraking' {
                doc /* Applies hydraulic brake force */
                in brakePedalForce : ScalarValues::String;
                out frictionForce : ScalarValues::String;
            }

            action def 'RegenerativeBraking' {
                doc /* Recovers kinetic energy */
                in kineticEnergy : ScalarValues::String;
                out electricalEnergy : ScalarValues::String;
            }

            action def 'ABSEBDControl' {
                doc /* Controls ABS and EBD systems */
                in wheelSpeed : ScalarValues::String;
                out modulatedBrakePressure : ScalarValues::String;
            }

            action def 'BrakeWearMonitoring' {
                doc /* Monitors brake pad wear */
                in padThicknessSensor : ScalarValues::String;
                out maintenanceAlert : ScalarValues::String;
            }
        }
    }

    // Logical Architecture
    package LogicalArchitecture {
        part def 'OverallVehicleSystem' {
            doc /* Coordinates all vehicle systems, provides user interface, and ensures compliance and integration. */
        }

        part def 'EnergyStorageAndManagement' {
            doc /* Manages energy storage, battery health, and safety. */
        }

        part def 'PowerConversionAndPropulsion' {
            doc /* Converts electrical energy to mechanical torque for vehicle movement. */
        }

        part def 'EnergyRecoveryAndBraking' {
            doc /* Recovers kinetic energy during braking and provides safe deceleration. */
        }

        part def 'VehicleControlAndCoordination' {
            doc /* Central logic for coordinating propulsion, braking, steering, and diagnostics. */
        }

        part def 'ThermalManagementSystem' {
            doc /* Maintains optimal temperature for battery, power electronics, and cabin. */
        }

        part def 'StabilityAndSafety' {
            doc /* Ensures vehicle stability, safety, and crash protection. */
        }

        part def 'AdvancedDriverAssistanceSystems' {
            doc /* Supports semi-automated driving and advanced safety features. */
        }

        part def 'AuxiliaryAndSupportSystems' {
            doc /* Provides charging, power conversion, and user information. */
        }
    }

    // Physical Architecture
    package PhysicalArchitecture {
        part def 'BatteryPack' {
            doc /* High-voltage lithium-ion battery storing energy for propulsion and auxiliary systems. */
            attribute type : ScalarValues::String = "NMC Lithium-ion";
            attribute capacity : ScalarValues::String = "100 kWh";
            attribute nominalVoltage : ScalarValues::String = "400 V";
            attribute weight : ScalarValues::String = "550 kg";
            attribute cooling : ScalarValues::String = "Liquid";
            attribute enclosure : ScalarValues::String = "Aluminum crash-protected";
        }

        part def 'BatteryManagementSystemECU' {
            doc /* Embedded controller for battery monitoring, balancing, and protection. */
            attribute processor : ScalarValues::String = "ARM Cortex-M7";
            attribute ASIL : ScalarValues::String = "D";
            attribute voltageRange : ScalarValues::String = "9-32 V";
            attribute communication : ScalarValues::String = "CAN FD, LIN";
            attribute powerConsumption : ScalarValues::String = "4 W";
        }

        part def 'CellVoltageTempSensors' {
            doc /* Distributed sensors measuring cell voltages and temperatures. */
            attribute accuracy : ScalarValues::String = "±1 mV (voltage), ±1°C (temperature)";
            attribute interface : ScalarValues::String = "SPI";
            attribute quantity : ScalarValues::String = "96 (voltage), 24 (temperature)";
        }

        part def 'MainInverter' {
            doc /* Converts DC battery power to AC for the propulsion motor. */
            attribute type : ScalarValues::String = "SiC MOSFET";
            attribute peakPower : ScalarValues::String = "180 kW";
            attribute efficiency : ScalarValues::String = "98%";
            attribute cooling : ScalarValues::String = "Liquid";
        }

        part def 'ElectricDriveMotor' {
            doc /* Permanent magnet synchronous machine providing vehicle propulsion. */
            attribute peakPower : ScalarValues::String = "150 kW";
            attribute maxTorque : ScalarValues::String = "350 Nm";
            attribute weight : ScalarValues::String = "80 kg";
            attribute cooling : ScalarValues::String = "Oil";
        }

        part def 'TransmissionGearbox' {
            doc /* Single-speed reduction gearbox transferring torque to the wheels. */
            attribute gearRatio : ScalarValues::String = "9.5:1";
            attribute efficiency : ScalarValues::String = "97%";
            attribute weight : ScalarValues::String = "25 kg";
        }

        part def 'OnBoardCharger' {
            doc /* AC/DC converter for charging the high-voltage battery from external sources. */
            attribute inputVoltage : ScalarValues::String = "110-240V AC";
            attribute outputPower : ScalarValues::String = "11 kW";
            attribute efficiency : ScalarValues::String = "94%";
            attribute weight : ScalarValues::String = "8 kg";
        }

        part def 'DCDCConverter' {
            doc /* Steps down high-voltage battery output to 12V for auxiliary systems. */
            attribute inputVoltage : ScalarValues::String = "250-430 V";
            attribute outputVoltage : ScalarValues::String = "12 V";
            attribute maxPower : ScalarValues::String = "3 kW";
            attribute efficiency : ScalarValues::String = "95%";
        }

        part def 'VehicleControlUnit' {
            doc /* Central logic controller for all vehicle systems and safety-critical coordination. */
            attribute processor : ScalarValues::String = "Infineon AURIX";
            attribute ASIL : ScalarValues::String = "D";
            attribute communication : ScalarValues::String = "CAN FD, Ethernet";
            attribute power : ScalarValues::String = "10 W";
        }

        part def 'ThermalManagementController' {
            doc /* Manages operation of pumps, valves, and HVAC for thermal regulation. */
            attribute processor : ScalarValues::String = "ARM Cortex-M4";
            attribute communication : ScalarValues::String = "CAN, LIN";
            attribute power : ScalarValues::String = "3 W";
        }

        part def 'CoolantPump' {
            doc /* Circulates coolant through battery, motor, inverter, and cabin heat exchangers. */
            attribute type : ScalarValues::String = "Brushless DC";
            attribute maxFlow : ScalarValues::String = "10 L/min";
            attribute power : ScalarValues::String = "120 W";
        }

        part def 'BatteryHeater' {
            doc /* PTC element for heating battery during cold conditions. */
            attribute power : ScalarValues::String = "2 kW";
            attribute voltage : ScalarValues::String = "400 V";
            attribute control : ScalarValues::String = "PWM";
        }

        part def 'HVACUnit' {
            doc /* Provides cabin heating and cooling, and supports battery thermal management. */
            attribute type : ScalarValues::String = "Heat pump";
            attribute capacity : ScalarValues::String = "5 kW cooling / 6 kW heating";
            attribute refrigerant : ScalarValues::String = "R1234yf";
        }

        part def 'WheelSpeedSensors' {
            doc /* Detects rotational speed of each wheel for ABS, ESP, and ADAS. */
            attribute type : ScalarValues::String = "Hall effect";
            attribute accuracy : ScalarValues::String = "±0.1 km/h";
            attribute quantity : ScalarValues::String = "4";
        }

        part def 'SteeringAngleSensor' {
            doc /* Measures steering wheel position for stability and ADAS functions. */
            attribute range : ScalarValues::String = "±720°";
            attribute resolution : ScalarValues::String = "0.1°";
        }

        part def 'YawRateSensor' {
            doc /* Measures vehicle rotational rate for ESP and ADAS. */
            attribute range : ScalarValues::String = "±250°/s";
            attribute accuracy : ScalarValues::String = "±0.5°/s";
        }

        part def 'HydraulicBrakeActuator' {
            doc /* Applies hydraulic pressure to wheel brakes based on driver and system input. */
            attribute maxPressure : ScalarValues::String = "200 bar";
            attribute responseTime : ScalarValues::String = "10 ms";
        }

        part def 'BrakePedalSensor' {
            doc /* Measures brake pedal position and force for brake blending and control. */
            attribute range : ScalarValues::String = "0-100%";
            attribute accuracy : ScalarValues::String = "±1%";
        }

        part def 'RegenerativeBrakingController' {
            doc /* Coordinates between hydraulic and regenerative braking for optimal energy recovery. */
            attribute processor : ScalarValues::String = "ARM Cortex-M0";
            attribute communication : ScalarValues::String = "CAN";
        }

        part def 'ABSESPECU' {
            doc /* Controls anti-lock braking and electronic stability interventions. */
            attribute ASIL : ScalarValues::String = "C";
            attribute processor : ScalarValues::String = "Freescale S12";
            attribute communication : ScalarValues::String = "CAN";
        }

        part def 'ADASECU' {
            doc /* Processes sensor data and executes ADAS algorithms. */
            attribute processor : ScalarValues::String = "NVIDIA Xavier";
            attribute ASIL : ScalarValues::String = "B";
            attribute communication : ScalarValues::String = "Ethernet, CAN";
        }

        part def 'FrontCamera' {
            doc /* Forward-facing camera for lane keeping, object detection, and traffic sign recognition. */
            attribute resolution : ScalarValues::String = "1920x1080";
            attribute frameRate : ScalarValues::String = "60 fps";
            attribute fieldOfView : ScalarValues::String = "120°";
        }

        part def 'RadarSensor' {
            doc /* Long-range radar for adaptive cruise control and collision warning. */
            attribute range : ScalarValues::String = "200 m";
            attribute frequency : ScalarValues::String = "77 GHz";
            attribute fieldOfView : ScalarValues::String = "20°";
        }

        part def 'UltrasonicSensors' {
            doc /* Short-range sensors for parking assistance and blind spot detection. */
            attribute range : ScalarValues::String = "0.2–5 m";
            attribute quantity : ScalarValues::String = "12";
        }

        part def 'LidarSensor' {
            doc /* High-resolution 3D mapping for ADAS and emergency braking. */
            attribute range : ScalarValues::String = "150 m";
            attribute channels : ScalarValues::String = "32";
            attribute rotationRate : ScalarValues::String = "10 Hz";
        }

        part def 'InfotainmentHeadUnit' {
            doc /* Central display and user interface for vehicle information and controls. */
            attribute display : ScalarValues::String = "12\" touchscreen";
            attribute OS : ScalarValues::String = "Linux";
            attribute wireless : ScalarValues::String = "Bluetooth, Wi-Fi";
        }

        part def 'TelematicsControlUnit' {
            doc /* Manages wireless connectivity, remote diagnostics, and OTA updates. */
            attribute modem : ScalarValues::String = "4G/5G";
            attribute GNSS : ScalarValues::String = "GPS/GLONASS";
            attribute memory : ScalarValues::String = "8 GB";
        }

        part def 'CANBusNetwork' {
            doc /* Primary communication backbone for E/E systems. */
            attribute speed : ScalarValues::String = "500 kbps/2 Mbps";
            attribute nodes : ScalarValues::String = "up to 32";
        }

        part def 'HighVoltagePowerDistributionUnit' {
            doc /* Manages and protects high voltage connections between battery, inverter, and charger. */
            attribute maxCurrent : ScalarValues::String = "400 A";
            attribute fuses : ScalarValues::String = "integrated";
            attribute relays : ScalarValues::String = "contactor-based";
        }
    }

    // System Composition and Relationships
    part vehicle : 'BatteryElectricVehicle' {
        // Logical Architecture Parts
        part overallSystem : LogicalArchitecture::'OverallVehicleSystem';
        part energyStorage : LogicalArchitecture::'EnergyStorageAndManagement';
        part powerConversion : LogicalArchitecture::'PowerConversionAndPropulsion';
        part energyRecovery : LogicalArchitecture::'EnergyRecoveryAndBraking';
        part vehicleControl : LogicalArchitecture::'VehicleControlAndCoordination';
        part thermalManagement : LogicalArchitecture::'ThermalManagementSystem';
        part stability : LogicalArchitecture::'StabilityAndSafety';
        part adas : LogicalArchitecture::'AdvancedDriverAssistanceSystems';
        part auxiliary : LogicalArchitecture::'AuxiliaryAndSupportSystems';

        // Physical Components
        part batteryPack : PhysicalArchitecture::'BatteryPack';
        part bmsECU : PhysicalArchitecture::'BatteryManagementSystemECU';
        part cellSensors : PhysicalArchitecture::'CellVoltageTempSensors';
        part inverter : PhysicalArchitecture::'MainInverter';
        part motor : PhysicalArchitecture::'ElectricDriveMotor';
        part transmission : PhysicalArchitecture::'TransmissionGearbox';
        part charger : PhysicalArchitecture::'OnBoardCharger';
        part dcConverter : PhysicalArchitecture::'DCDCConverter';
        part vcu : PhysicalArchitecture::'VehicleControlUnit';
        part thermalController : PhysicalArchitecture::'ThermalManagementController';
        part coolantPump : PhysicalArchitecture::'CoolantPump';
        part batteryHeater : PhysicalArchitecture::'BatteryHeater';
        part hvac : PhysicalArchitecture::'HVACUnit';
        part wheelSensors : PhysicalArchitecture::'WheelSpeedSensors';
        part steeringSensor : PhysicalArchitecture::'SteeringAngleSensor';
        part yawSensor : PhysicalArchitecture::'YawRateSensor';
        part brakeActuator : PhysicalArchitecture::'HydraulicBrakeActuator';
        part brakeSensor : PhysicalArchitecture::'BrakePedalSensor';
        part regenController : PhysicalArchitecture::'RegenerativeBrakingController';
        part espECU : PhysicalArchitecture::'ABSESPECU';
        part adasECU : PhysicalArchitecture::'ADASECU';
        part camera : PhysicalArchitecture::'FrontCamera';
        part radar : PhysicalArchitecture::'RadarSensor';
        part ultrasonics : PhysicalArchitecture::'UltrasonicSensors';
        part lidar : PhysicalArchitecture::'LidarSensor';
        part headUnit : PhysicalArchitecture::'InfotainmentHeadUnit';
        part telematics : PhysicalArchitecture::'TelematicsControlUnit';
        part canBus : PhysicalArchitecture::'CANBusNetwork';
        part powerDist : PhysicalArchitecture::'HighVoltagePowerDistributionUnit';

        // Physical to Logical Usage Relationships (based on JSON used_by_logicals)
        connect batteryPack to energyStorage;
        connect batteryPack to thermalManagement;
        connect batteryPack to energyRecovery;
        connect batteryPack to auxiliary;

        connect bmsECU to energyStorage;
        connect bmsECU to thermalManagement;
        connect bmsECU to vehicleControl;

        connect cellSensors to energyStorage;
        connect cellSensors to thermalManagement;

        connect inverter to powerConversion;
        connect inverter to energyRecovery;
        connect inverter to vehicleControl;

        connect motor to powerConversion;
        connect motor to energyRecovery;
        connect motor to stability;

        connect transmission to powerConversion;

        connect charger to auxiliary;
        connect charger to energyStorage;

        connect dcConverter to auxiliary;
        connect dcConverter to overallSystem;

        connect vcu to vehicleControl;
        connect vcu to energyStorage;
        connect vcu to powerConversion;
        connect vcu to stability;
        connect vcu to thermalManagement;
        connect vcu to adas;
        connect vcu to auxiliary;

        connect thermalController to thermalManagement;
        connect thermalController to energyStorage;

        connect coolantPump to thermalManagement;
        connect coolantPump to energyStorage;
        connect coolantPump to powerConversion;

        connect batteryHeater to thermalManagement;
        connect batteryHeater to energyStorage;

        connect hvac to thermalManagement;
        connect hvac to auxiliary;

        connect wheelSensors to stability;
        connect wheelSensors to energyRecovery;
        connect wheelSensors to adas;

        connect steeringSensor to stability;
        connect steeringSensor to adas;

        connect yawSensor to stability;
        connect yawSensor to adas;

        connect brakeActuator to energyRecovery;
        connect brakeActuator to stability;

        connect brakeSensor to energyRecovery;

        connect regenController to energyRecovery;
        connect regenController to vehicleControl;

        connect espECU to stability;
        connect espECU to vehicleControl;

        connect adasECU to adas;
        connect adasECU to vehicleControl;

        connect camera to adas;
        connect radar to adas;
        connect ultrasonics to adas;
        connect lidar to adas;

        connect headUnit to overallSystem;
        connect headUnit to auxiliary;

        connect telematics to overallSystem;
        connect telematics to auxiliary;

        connect canBus to overallSystem; // CAN is used by all logicals

        connect powerDist to energyStorage;
        connect powerDist to powerConversion;
        connect powerDist to auxiliary;

        // Functions performed by logical components
        // Overall Vehicle System functions
        perform overallSystem userAuth : Functions::'OverallVehicleSystemFunctions'::'UserAuthentication';
        perform overallSystem realTimeDiag : Functions::'OverallVehicleSystemFunctions'::'RealTimeDiagnostics';
        perform overallSystem remoteSW : Functions::'OverallVehicleSystemFunctions'::'RemoteSoftwareUpdates';
        perform overallSystem mobileApp : Functions::'OverallVehicleSystemFunctions'::'MobileAppIntegration';
        perform overallSystem hmiInteract : Functions::'OverallVehicleSystemFunctions'::'HMIInteraction';

        // Energy Recovery performs regenerative braking control
        perform energyRecovery regenBrakeCtrl : Functions::'OverallVehicleSystemFunctions'::'RegenerativeBrakingControl';

        // Auxiliary systems perform charging compatibility
        perform auxiliary chargingCompat : Functions::'OverallVehicleSystemFunctions'::'ChargingStandardCompatibility';

        // Power Conversion & Propulsion functions
        perform powerConversion torqueDelivery : Functions::'VehiclePropulsionFunctions'::'TorqueDelivery';
        perform powerConversion driveModes : Functions::'VehiclePropulsionFunctions'::'ForwardReverseDriveModes';
        perform powerConversion hillHold : Functions::'VehiclePropulsionFunctions'::'HillHoldAssist';

        // Energy Recovery also performs regenerative braking integration for propulsion
        perform energyRecovery regenBraking : Functions::'VehiclePropulsionFunctions'::'RegenerativeBrakingIntegration';

        // Battery Management System functions
        perform energyStorage cellMonitoring : Functions::'BMSFunctions'::'CellVoltageMonitoring';
        perform energyStorage socSohEst : Functions::'BMSFunctions'::'SOCSOHEstimation';
        perform energyStorage cellBalancing : Functions::'BMSFunctions'::'ActiveCellBalancing';
        perform energyStorage faultDetect : Functions::'BMSFunctions'::'FaultDetection';
        perform energyStorage safetyComply : Functions::'BMSFunctions'::'SafetyCompliance';
        perform energyStorage dataLog : Functions::'BMSFunctions'::'DataLogging';

        // Thermal management controls battery thermal management
        perform energyStorage thermalCtrl : Functions::'BMSFunctions'::'ThermalManagementControl';

        // Thermal Management System functions
        perform thermalManagement batteryCooling : Functions::'ThermalManagementFunctions'::'BatteryCoolingHeating';
        perform thermalManagement wasteHeat : Functions::'ThermalManagementFunctions'::'WasteHeatRecovery';
        perform thermalManagement coolantMonitor : Functions::'ThermalManagementFunctions'::'CoolantFlowMonitoring';
        perform thermalManagement powerElecCool : Functions::'ThermalManagementFunctions'::'PowerElectronicsCooling';

        // Electronic Stability Program functions
        perform stability yawMonitor : Functions::'ESPFunctions'::'YawRateMonitoring';
        perform stability torqueReduce : Functions::'ESPFunctions'::'TorqueReduction';
        perform stability wheelBrake : Functions::'ESPFunctions'::'IndividualWheelBraking';
        perform stability trailerStab : Functions::'ESPFunctions'::'TrailerStabilityControl';

        // Vehicle Control Solution functions
        perform vehicleControl driveMode : Functions::'VehicleControlFunctions'::'DriveModeCoordination';
        perform vehicleControl subsysInteg : Functions::'VehicleControlFunctions'::'SubsystemIntegration';
        perform vehicleControl failSafe : Functions::'VehicleControlFunctions'::'FailSafeActivation';
        perform vehicleControl realTimeDiag2 : Functions::'VehicleControlFunctions'::'RealTimeDiagnostics';

        // ADAS functions
        perform adas adaptiveCruise : Functions::'ADASFunctions'::'AdaptiveCruiseControl';
        perform adas laneKeeping : Functions::'ADASFunctions'::'LaneKeepingAssist';
        perform adas emergencyBrake : Functions::'ADASFunctions'::'EmergencyBraking';
        perform adas blindSpot : Functions::'ADASFunctions'::'BlindSpotDetection';

        // Brake System functions
        perform energyRecovery hydraulicBrake : Functions::'BrakeSystemFunctions'::'HydraulicBraking';
        perform energyRecovery regenBrake : Functions::'BrakeSystemFunctions'::'RegenerativeBraking';
        perform energyRecovery absEbd : Functions::'BrakeSystemFunctions'::'ABSEBDControl';
        perform energyRecovery brakeWear : Functions::'BrakeSystemFunctions'::'BrakeWearMonitoring';

        // Function to Functional Requirement Satisfaction
        satisfy userAuth to Requirements::'OverallVehicleRequirements'::'FunctionalRequirements'::'UserAuthentication';
        satisfy realTimeDiag to Requirements::'OverallVehicleRequirements'::'FunctionalRequirements'::'RealTimeDiagnostics';
        satisfy remoteSW to Requirements::'OverallVehicleRequirements'::'FunctionalRequirements'::'RemoteSoftwareUpdates';
        satisfy mobileApp to Requirements::'OverallVehicleRequirements'::'FunctionalRequirements'::'MobileAppIntegration';
        satisfy regenBrakeCtrl to Requirements::'OverallVehicleRequirements'::'FunctionalRequirements'::'RegenerativeBraking';
        satisfy chargingCompat to Requirements::'OverallVehicleRequirements'::'FunctionalRequirements'::'ChargingStandards';
        satisfy hmiInteract to Requirements::'OverallVehicleRequirements'::'FunctionalRequirements'::'UserFriendlyHMI';

        satisfy torqueDelivery to Requirements::'VehiclePropulsionRequirements'::'FunctionalRequirements'::'SeamlessTorqueDelivery';
        satisfy driveModes to Requirements::'VehiclePropulsionRequirements'::'FunctionalRequirements'::'DriveModesSupport';
        satisfy regenBraking to Requirements::'VehiclePropulsionRequirements'::'FunctionalRequirements'::'RegenBrakingIntegration';
        satisfy hillHold to Requirements::'VehiclePropulsionRequirements'::'FunctionalRequirements'::'HillAssist';

        satisfy cellMonitoring to Requirements::'BMSRequirements'::'FunctionalRequirements'::'CellMonitoring';
        satisfy socSohEst to Requirements::'BMSRequirements'::'FunctionalRequirements'::'StateEstimation';
        satisfy cellBalancing to Requirements::'BMSRequirements'::'FunctionalRequirements'::'CellBalancing';
        satisfy faultDetect to Requirements::'BMSRequirements'::'FunctionalRequirements'::'FaultDetection';
        satisfy thermalCtrl to Requirements::'BMSRequirements'::'FunctionalRequirements'::'ThermalControl';
        satisfy safetyComply to Requirements::'BMSRequirements'::'FunctionalRequirements'::'SafetyCompliance';
        satisfy dataLog to Requirements::'BMSRequirements'::'FunctionalRequirements'::'DataLogging';

        satisfy batteryCooling to Requirements::'ThermalManagementRequirements'::'FunctionalRequirements'::'ActiveThermalControl';
        satisfy wasteHeat to Requirements::'ThermalManagementRequirements'::'FunctionalRequirements'::'HVACIntegration';
        satisfy coolantMonitor to Requirements::'ThermalManagementRequirements'::'FunctionalRequirements'::'CoolantMonitoring';
        satisfy powerElecCool to Requirements::'ThermalManagementRequirements'::'FunctionalRequirements'::'PowerElectronicsCooling';

        satisfy yawMonitor to Requirements::'ESPRequirements'::'FunctionalRequirements'::'SensorMonitoring';
        satisfy torqueReduce to Requirements::'ESPRequirements'::'FunctionalRequirements'::'StabilityIntervention';
        satisfy wheelBrake to Requirements::'ESPRequirements'::'FunctionalRequirements'::'StabilityIntervention';
        satisfy trailerStab to Requirements::'ESPRequirements'::'FunctionalRequirements'::'TrailerStability';

        satisfy driveMode to Requirements::'VehicleControlRequirements'::'FunctionalRequirements'::'DriveModesSupport';
        satisfy subsysInteg to Requirements::'VehicleControlRequirements'::'FunctionalRequirements'::'SystemIntegration';
        satisfy failSafe to Requirements::'VehicleControlRequirements'::'FunctionalRequirements'::'FailSafeOperation';
        satisfy realTimeDiag2 to Requirements::'VehicleControlRequirements'::'FunctionalRequirements'::'SystemCoordination';

        satisfy adaptiveCruise to Requirements::'ADASRequirements'::'FunctionalRequirements'::'CoreFeatures';
        satisfy laneKeeping to Requirements::'ADASRequirements'::'FunctionalRequirements'::'CoreFeatures';
        satisfy emergencyBrake to Requirements::'ADASRequirements'::'FunctionalRequirements'::'CoreFeatures';
        satisfy blindSpot to Requirements::'ADASRequirements'::'FunctionalRequirements'::'SafetyFeatures';

        satisfy hydraulicBrake to Requirements::'BrakeSystemRequirements'::'FunctionalRequirements'::'DualBraking';
        satisfy regenBrake to Requirements::'BrakeSystemRequirements'::'FunctionalRequirements'::'DualBraking';
        satisfy absEbd to Requirements::'BrakeSystemRequirements'::'FunctionalRequirements'::'ABSandEBD';
        satisfy brakeWear to Requirements::'BrakeSystemRequirements'::'FunctionalRequirements'::'WearFeedback';

        // Logical to Performance/Resource Requirements Satisfaction
        satisfy energyStorage to Requirements::'BMSRequirements'::'PerformanceRequirements'::'ChargeDischargeRate';
        satisfy energyStorage to Requirements::'BMSRequirements'::'PerformanceRequirements'::'VoltageTolerance';
        satisfy energyStorage to Requirements::'BMSRequirements'::'PerformanceRequirements'::'ThermalRunawayDetection';
        satisfy energyStorage to Requirements::'BMSRequirements'::'PerformanceRequirements'::'CycleLife';
        satisfy energyStorage to Requirements::'BMSRequirements'::'ResourceRequirements'::'PowerConsumption';
        satisfy energyStorage to Requirements::'BMSRequirements'::'ResourceRequirements'::'OperatingTemperature';

        satisfy powerConversion to Requirements::'VehiclePropulsionRequirements'::'PerformanceRequirements'::'PeakPower';
        satisfy powerConversion to Requirements::'VehiclePropulsionRequirements'::'PerformanceRequirements'::'MaxTorque';
        satisfy powerConversion to Requirements::'VehiclePropulsionRequirements'::'PerformanceRequirements'::'ContinuousOperation';
        satisfy powerConversion to Requirements::'VehiclePropulsionRequirements'::'PerformanceRequirements'::'Gradeability';
        satisfy powerConversion to Requirements::'VehiclePropulsionRequirements'::'ResourceRequirements'::'PowertrainEfficiency';
        satisfy powerConversion to Requirements::'VehiclePropulsionRequirements'::'ResourceRequirements'::'EMIEmissions';

        satisfy thermalManagement to Requirements::'ThermalManagementRequirements'::'PerformanceRequirements'::'BatteryTemperature';
        satisfy thermalManagement to Requirements::'ThermalManagementRequirements'::'PerformanceRequirements'::'PreConditioning';
        satisfy thermalManagement to Requirements::'ThermalManagementRequirements'::'PerformanceRequirements'::'PeakLoadCooling';
        satisfy thermalManagement to Requirements::'ThermalManagementRequirements'::'ResourceRequirements'::'EnergyUsage';
        satisfy thermalManagement to Requirements::'ThermalManagementRequirements'::'ResourceRequirements'::'RefrigerantGWP';

        satisfy stability to Requirements::'ESPRequirements'::'PerformanceRequirements'::'ResponseTime';
        satisfy stability to Requirements::'ESPRequirements'::'PerformanceRequirements'::'RolloverPrevention';
        satisfy stability to Requirements::'ESPRequirements'::'PerformanceRequirements'::'SpeedRange';
        satisfy stability to Requirements::'ESPRequirements'::'ResourceRequirements'::'PowerDraw';
        satisfy stability to Requirements::'ESPRequirements'::'ResourceRequirements'::'OperatingTemperature';

        satisfy vehicleControl to Requirements::'VehicleControlRequirements'::'PerformanceRequirements'::'ControlLoopRate';
        satisfy vehicleControl to Requirements::'VehicleControlRequirements'::'PerformanceRequirements'::'DiagnosticsSupport';
        satisfy vehicleControl to Requirements::'VehicleControlRequirements'::'PerformanceRequirements'::'BootTime';
        satisfy vehicleControl to Requirements::'VehicleControlRequirements'::'ResourceRequirements'::'PowerConsumption';
        satisfy vehicleControl to Requirements::'VehicleControlRequirements'::'ResourceRequirements'::'ProcessorGrade';

        satisfy adas to Requirements::'ADASRequirements'::'PerformanceRequirements'::'DetectionRange';
        satisfy adas to Requirements::'ADASRequirements'::'PerformanceRequirements'::'LaneKeepingAccuracy';
        satisfy adas to Requirements::'ADASRequirements'::'PerformanceRequirements'::'BrakingActivation';
        satisfy adas to Requirements::'ADASRequirements'::'ResourceRequirements'::'PowerDraw';
        satisfy adas to Requirements::'ADASRequirements'::'ResourceRequirements'::'SensorGrade';

        satisfy energyRecovery to Requirements::'BrakeSystemRequirements'::'PerformanceRequirements'::'StoppingDistance';
        satisfy energyRecovery to Requirements::'BrakeSystemRequirements'::'PerformanceRequirements'::'EnergyRecovery';
        satisfy energyRecovery to Requirements::'BrakeSystemRequirements'::'PerformanceRequirements'::'ResponseTime';
        satisfy energyRecovery to Requirements::'BrakeSystemRequirements'::'ResourceRequirements'::'PowerDraw';
        satisfy energyRecovery to Requirements::'BrakeSystemRequirements'::'ResourceRequirements'::'BrakeMaterials';

        // Physical to Design Requirements Satisfaction
        satisfy bmsECU to Requirements::'BMSRequirements'::'DesignRequirements'::'PCBArea';
        satisfy bmsECU to Requirements::'BMSRequirements'::'DesignRequirements'::'ModularSupport';

        satisfy motor to Requirements::'VehiclePropulsionRequirements'::'DesignRequirements'::'MotorMass';
        satisfy motor to Requirements::'VehiclePropulsionRequirements'::'DesignRequirements'::'SystemVolume';

        satisfy thermalController to Requirements::'ThermalManagementRequirements'::'DesignRequirements'::'SystemMass';
        satisfy thermalController to Requirements::'ThermalManagementRequirements'::'DesignRequirements'::'SystemVolume';

        satisfy espECU to Requirements::'ESPRequirements'::'DesignRequirements'::'ControllerFit';
        satisfy wheelSensors to Requirements::'ESPRequirements'::'DesignRequirements'::'SensorWiring';

        satisfy vcu to Requirements::'VehicleControlRequirements'::'DesignRequirements'::'PCBArea';
        satisfy vcu to Requirements::'VehicleControlRequirements'::'DesignRequirements'::'SoftwareModularity';

        satisfy adasECU to Requirements::'ADASRequirements'::'DesignRequirements'::'ECUVolume';
        satisfy camera to Requirements::'ADASRequirements'::'DesignRequirements'::'SensorIntegration';
        satisfy radar to Requirements::'ADASRequirements'::'DesignRequirements'::'SensorIntegration';
        satisfy lidar to Requirements::'ADASRequirements'::'DesignRequirements'::'SensorIntegration';
        satisfy ultrasonics to Requirements::'ADASRequirements'::'DesignRequirements'::'SensorIntegration';

        satisfy brakeActuator to Requirements::'BrakeSystemRequirements'::'DesignRequirements'::'CaliperMass';
        satisfy brakeActuator to Requirements::'BrakeSystemRequirements'::'DesignRequirements'::'SystemFit';
    }
}