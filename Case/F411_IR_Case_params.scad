//STM32F411 Board parameters
board_length = 52.8;
board_width = 20.7;
pcb_thickness = 1.5;
pcb_max_clearance_top = 4.0; //max height of components on top of PCB
pcb_max_clearance_bottom = 1.1; //height of components on bottom of PCB
pcb_wall_margin = 0.15; //margin from edge of PCB to any walls

pin_row_length = 50.7;
pin_row_width = 2.4;
pin_length = 0.5;
pin_width = 0.6;
pin_plastic_height = 2.8;
pin_row_width_separation = 12.6;
pin_row_dist_from_bottom = 2;

wall_thickness = 2;
base_thickness = 2;

swd_header_protrusion = 3.0;
swd_joint_dist_from_bottom = 1.5;
swd_width = 12.0;

usb_width = 11;

//Calculated parameters
f4_inner_height = pcb_thickness + pcb_max_clearance_top + pcb_max_clearance_bottom;
f4_inner_length = board_length + pcb_wall_margin*2;
f4_inner_width = board_width + pcb_wall_margin*2;

f4_full_length = f4_inner_length + wall_thickness*2;
f4_full_width =  f4_inner_width + wall_thickness*2;
f4_full_height = base_thickness + f4_inner_height;


//IR board params
ir_board_width = 15.4;
ir_board_length = 19.2;
ir_board_thickness = 1.4;
ir_board_top_clearance = 9.0; //technically ~8.6mm
ir_board_bottom_clearance = 1.4;
//ignoring the M2 holes for now