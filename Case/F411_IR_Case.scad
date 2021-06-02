include <F411_IR_Case_params.scad>

ir_case_width = 34;
ir_case_length = 84;
ir_case_height = 34;

ir_mount_dist_from_top = 10;
ir_sensor_cutout_height = ir_board_bottom_clearance+ir_board_top_clearance + 2;

ir_case_full_width = ir_case_width + wall_thickness*2;
ir_case_full_length = ir_case_length + wall_thickness*2;
ir_case_full_height = ir_case_height + base_thickness;

ir_lid_removal_cutout_width = 10;
ir_lid_removal_cutout_height = 3;

leg_mount_height = 4 + 0.2;
leg_mount_width = 5;
leg_mount_length = 4 + 0.4;

triangle_mount_base = 2;
triangle_mount_length = 12;
triangle_mount_dist_from_top = 2.4;



f411_ir_case_body();
//translate([0, -60, 0]) f411_ir_case_lid();

module f411_ir_case_body()
{
    
    translate([0,0,ir_case_full_height/2]) union()
    {
        difference()
        {
            //main box
            cube([ir_case_full_length, ir_case_full_width, ir_case_full_height], center=true);
            
            //main cutout
            translate([0,0,base_thickness]) cube([ir_case_length, ir_case_width, ir_case_height], center=true);
            
            //mount points to F4 protocase
            translate([ir_case_full_length/2,0,ir_case_full_height/2-ir_mount_dist_from_top]) leg_mount_points(leg_mount_length, leg_mount_width, leg_mount_height);
           
            //USB cutout
            translate([ir_case_full_length/2,0,ir_case_full_height/2-7]) cube([wall_thickness*2, usb_width, 8], center=true);
            
            //IR sensor cutout
            translate([-ir_case_full_length/2,0,-ir_case_height/2 + base_thickness + ir_sensor_cutout_height/2]) cube([wall_thickness*2, ir_board_width+1, ir_sensor_cutout_height], center=true);
            
            //lid removal cutouts
            //left
            translate([0,ir_case_full_width/2,ir_case_full_height/2 - ir_lid_removal_cutout_height/2]) cube([ir_lid_removal_cutout_width, wall_thickness*2, ir_lid_removal_cutout_height], center=true);
            //right
            translate([0,-ir_case_full_width/2,ir_case_full_height/2 - ir_lid_removal_cutout_height/2]) cube([ir_lid_removal_cutout_width, wall_thickness*2, ir_lid_removal_cutout_height], center=true);
            //bottom
            translate([-ir_case_full_length/2,0,ir_case_full_height/2 - ir_lid_removal_cutout_height/2]) cube([wall_thickness*2, ir_lid_removal_cutout_width, ir_lid_removal_cutout_height], center=true);
            
            
            //top right triangle cutout
            translate([ir_case_length/4,-ir_case_full_width/2+triangle_mount_base,ir_case_full_height/2 - triangle_mount_base - triangle_mount_dist_from_top]) triangle_mount(triangle_mount_base, wall_thickness/2, triangle_mount_length);
            
            //bottom right triangle cutout
            translate([-ir_case_length/4,-ir_case_full_width/2+triangle_mount_base,ir_case_full_height/2 - triangle_mount_base - triangle_mount_dist_from_top]) triangle_mount(triangle_mount_base, wall_thickness/2, triangle_mount_length);
            
            //top left triangle cutout
            translate([ir_case_length/4,ir_case_full_width/2-triangle_mount_base,ir_case_full_height/2 - triangle_mount_base - triangle_mount_dist_from_top]) mirror([0,1,0]) triangle_mount(triangle_mount_base, wall_thickness/2, triangle_mount_length);
            
            //bottom left triangle cutout
            translate([-ir_case_length/4,ir_case_full_width/2-triangle_mount_base,ir_case_full_height/2 - triangle_mount_base - triangle_mount_dist_from_top]) mirror([0,1,0]) triangle_mount(triangle_mount_base, wall_thickness/2, triangle_mount_length);
        
        }
        
        //holding point for IR board
        translate([-ir_case_full_length/2+(ir_board_length)/2+1+0.1, 0, -ir_case_full_height/2+ir_board_bottom_clearance]) ir_board_holder();
        
        //support for F4 board holder, left
        translate([0,ir_case_full_width/2-wall_thickness,-ir_case_height/2]) mirror([0,1,0]) cube([wall_thickness*2, wall_thickness*3, ir_case_height-ir_mount_dist_from_top-leg_mount_height/2-0.45]);
        
        //Support for F4 board holder, right
        translate([0,-ir_case_full_width/2+wall_thickness*4,-ir_case_height/2]) mirror([0,1,0]) cube([wall_thickness*2, wall_thickness*3, ir_case_height-ir_mount_dist_from_top-leg_mount_height/2-0.45]);
        
    }
   
}

module f411_ir_case_lid()
{
    lid_thickness = 1.6;
    translate([0,0,lid_thickness/2]) union()
    {
        //base
        cube([ir_case_full_length, ir_case_full_width, lid_thickness], center=true);
        
        //TODO: should probably put some circular or triangular support on the inner corner of the support, since stress is concentrated there
        //top right triangle mount (with support to get to right height)
        translate([ir_case_length/4,-ir_case_full_width/2+triangle_mount_base*2, triangle_mount_dist_from_top/2+lid_thickness/2+triangle_mount_base/2]) cube([triangle_mount_length, triangle_mount_base*2, triangle_mount_dist_from_top+triangle_mount_base], center=true);
        translate([ir_case_length/4,-ir_case_full_width/2+triangle_mount_base, triangle_mount_dist_from_top+lid_thickness/2]) triangle_mount(triangle_mount_base, wall_thickness/2, triangle_mount_length);
            
        //bottom right triangle mount
        translate([-ir_case_length/4,-ir_case_full_width/2+triangle_mount_base*2, triangle_mount_dist_from_top/2+lid_thickness/2+triangle_mount_base/2]) cube([triangle_mount_length, triangle_mount_base*2, triangle_mount_dist_from_top+triangle_mount_base], center=true);
        translate([-ir_case_length/4,-ir_case_full_width/2+triangle_mount_base,triangle_mount_dist_from_top+lid_thickness/2]) triangle_mount(triangle_mount_base, wall_thickness/2, triangle_mount_length);
            
        //top left triangle mount
        translate([ir_case_length/4,ir_case_full_width/2-triangle_mount_base*2, triangle_mount_dist_from_top/2+lid_thickness/2+triangle_mount_base/2]) cube([triangle_mount_length, triangle_mount_base*2, triangle_mount_dist_from_top+triangle_mount_base], center=true);
        translate([ir_case_length/4,ir_case_full_width/2-triangle_mount_base,triangle_mount_dist_from_top+lid_thickness/2]) mirror([0,1,0]) triangle_mount(triangle_mount_base, wall_thickness/2, triangle_mount_length);
            
        //bottom left triangle mount
        translate([-ir_case_length/4,ir_case_full_width/2-triangle_mount_base*2, triangle_mount_dist_from_top/2+lid_thickness/2+triangle_mount_base/2]) cube([triangle_mount_length, triangle_mount_base*2, triangle_mount_dist_from_top+triangle_mount_base], center=true);
        translate([-ir_case_length/4,ir_case_full_width/2-triangle_mount_base,triangle_mount_dist_from_top+lid_thickness/2]) mirror([0,1,0]) triangle_mount(triangle_mount_base, wall_thickness/2, triangle_mount_length);
    }
 
}


module leg_mount_points(mount_width, mount_length, mount_height)
{
    
    translate([0, 0, 0]) union()
    {
        //left
        translate([0,f4_full_width/2-mount_width/2,-mount_height/2+base_thickness/2-0.35]) cube([mount_length, mount_width, mount_height],center=true);
        
        //right
         translate([0,-f4_full_width/2+mount_width/2,-mount_height/2+base_thickness/2-0.35]) cube([mount_length, mount_width, mount_height],center=true);
    }
}


//from https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids#polyhedron
//makes 3D triangles
module prism_isos(l, w, h){
   polyhedron(
           points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w/2,h], [l,w/2,h]],
           faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
           );
  
}

module triangle_mount(base, height, length)
{
    translate([-length/2,0,base/2]) rotate([90,0,0]) union(){
        //triangle portion
        //rotate([90,0,-90]) 
        translate([0,-base/2,0]) prism_isos(length,base,height);
        
        //rectangular support
        //rotate([0,90,0])
        //translate([-length/2,0,base]) 
        translate([length/2,0,-base/2]) cube([length,base,base], center=true);
    }
}

module ir_board_holder()
{
    holder_wall_thickness = 1;
    holder_base_thickness = 1;
    l = ir_board_length + 0.2; //extra margin for filament expansion / printer error
    w = ir_board_width + 0.3; 
    l_full = holder_wall_thickness*2 + l;
    w_full = holder_wall_thickness*2 + w;
    h_full = holder_base_thickness+ir_board_bottom_clearance+pcb_thickness+ir_board_top_clearance;
    
    translate([0,0,h_full/2]) union()
    {
        difference()
        {
            //main structure
            cube([l_full, w_full, h_full], center=true);
            
            //main cutout
            translate([0,0,holder_base_thickness]) cube([l, w, pcb_thickness+ir_board_bottom_clearance+ir_board_top_clearance], center=true);
            
            //cut off the top
            translate([0,0,holder_base_thickness+ir_board_bottom_clearance+pcb_thickness+1]) cube([l_full, w_full, pcb_thickness+ir_board_top_clearance], center=true);
            
        }
        
        //put some supports to raise the board up level to the protrusion of the soldered through hole components
        //left
        translate([0,w/2-w_full/12,holder_base_thickness+ir_board_bottom_clearance-h_full/2]) cube([l_full, w_full/6,ir_board_bottom_clearance], center=true);
        
        //right
        translate([0,-w/2+w_full/12,holder_base_thickness+ir_board_bottom_clearance-h_full/2]) cube([l_full,w_full/6,ir_board_bottom_clearance], center=true);
        
    }
}