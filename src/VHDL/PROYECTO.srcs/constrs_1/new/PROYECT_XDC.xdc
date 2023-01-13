#JD
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33} [get_ports { lcd_data[7] }]; #d7 lcd                  
set_property -dict { PACKAGE_PIN T15   IOSTANDARD LVCMOS33} [get_ports { lcd_data[6] }]; 		 
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33} [get_ports { lcd_data[5] }];               
set_property -dict { PACKAGE_PIN R14   IOSTANDARD LVCMOS33} [get_ports { lcd_data[4] }];           
set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33} [get_ports { lcd_data[3] }];            
set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33} [get_ports { lcd_data[2] }];            
set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33} [get_ports { lcd_data[1] }];           
set_property -dict { PACKAGE_PIN V18   IOSTANDARD LVCMOS33} [get_ports { lcd_data[0] }]; #d0 lcd
#JC
set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33} [get_ports { Col_Pins[0] }]; 			 
set_property -dict { PACKAGE_PIN W15   IOSTANDARD LVCMOS33} [get_ports { Col_Pins[1] }]; 
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33} [get_ports { Col_Pins[2] }];             
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33} [get_ports { Col_Pins[3] }];            
set_property -dict { PACKAGE_PIN W14   IOSTANDARD LVCMOS33} [get_ports { Row_Pins[0] }];           
set_property -dict { PACKAGE_PIN Y14   IOSTANDARD LVCMOS33} [get_ports { Row_Pins[1] }];              
set_property -dict { PACKAGE_PIN T12   IOSTANDARD LVCMOS33} [get_ports { Row_Pins[2] }];             
set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33} [get_ports { Row_Pins[3] }];  
#JE
set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { e }]; 		 
set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports { rw }];                      
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { rs }];   
set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { parlante_left }]; #BUZZER
set_property -dict { PACKAGE_PIN V13   IOSTANDARD LVCMOS33 } [get_ports { parlante_right }]; #IO_L3N_T0_DQS_34 Sch=je[7]   
set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { salida }]; #motor               
set_property -dict { PACKAGE_PIN T17   IOSTANDARD LVCMOS33 } [get_ports { rx }]; #IO_L20P_T3_34 Sch=je[9]                     
set_property -dict { PACKAGE_PIN Y17   IOSTANDARD LVCMOS33 } [get_ports { tx }]; #IO_L7N_T1_34 Sch=je[10]  

##INTERRUPTORES
set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { bluetooth_reset }];
##conectar pines de bluetooth: rx,bluetooth_reset,tx_full,rx_empty,tx,pines de motor: salida
##LEDS
set_property -dict { PACKAGE_PIN M17   IOSTANDARD LVCMOS33 } [get_ports { rx_empty }]; #IO_L8P_T1_AD10P_35 Sch=led6_b
set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 } [get_ports { tx_full }]; #IO_L23P_T3_35 Sch=led[0]

#RELOJ 
set_property -dict { PACKAGE_PIN K17   IOSTANDARD LVCMOS33 } [get_ports { clk }]; 

#motor
#set_property -dict { PACKAGE_PIN K18   IOSTANDARD LVCMOS33 } [get_ports { enable }]; #IO_L12N_T1_MRCC_35 Sch=btn[0]    
#set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { salida }]; #motor   


