include <./BOSL2/std.scad>
include <./BOSL2/nema_steppers.scad>
include <./BOSL2/gears.scad>

// Super flat planet gearbox for nema motors
// By: Paul van Dinther
//
// For my project I needed a gearbox as flat as I could possibly make it.
// This gearbox measures 11 mm thick and it can be thinner depending on
// the motor plinth and point where the D-shaft starts.
//
// Not all annulus and sun teeth count settings make the teeth mesh
// Easiest way to use:
//
// In the customizer section "View" turn off the following:
//     layout_for_print = false
//     show_cover       = false
//     show_carrier     = false
// Leave the rest set to True
// Next you set the view in OpenSCAD to isometric and select the top view
// That way you can best see if the gears fit nicely.
// If gear teeth overlap it beans that that combo of annulus teeth and sun teeth is not possible
// It is possible to fudge things a bit by changing the gear_backlash value if too tight or too loose.


// settings that work well, ordered by gear ratio:
// ratio Annulus  sun  planet
// 2.6      60    36   12
// 3.0      44    22   11
// 3.15789  41    19   11
// 3.3      42    18   12
// 3.375    38    16   11
// 3.5      30    12    9
// 3.6      26    10    8
// 3.69231  35    13   11
// 3.75     44    16   14
// 3.8      42    15   13
// 4        27     9    9
// 4        36    12   12
// 4        45    15   15
// 4.2      32    10   11
// 4.25     39    12   13
// 4.5      42    12   15
// 4.667    33     9   12
// 4.8      38    10   14
// 5.4      44    10   17
// 6.0      60    12   24
//
//No combinations for Annulus: 28, 29, 31, 34, 37, 40, 43,
//Note: in some case the nut_distance_from_center needs to be adjusted or
//mounting_nuts needs to be turned off in which case there will be a


// Function: nema_motor_shaft_diam()
// Description: Returns the diameter of a NEMA motor shaft of given standard size.
// Arguments:
//   size = The standard NEMA motor size.
function nema_motor_shaft_diam(size) = lookup(size, [
        [11.0, 5.0],
        [14.0, 5.0],
        [17.0, 5.0],
        [23.0, 6.35],
        [34.0, 5], //12.7],
    ]);
    
    
/*[ You Measure ]*/
nema_shaft_length_above_plinth = 21.7;
motor_plinth_to_D_shaft = 3.6;

/*[ General ]*/
sunken_bolt_head_radius = 2.61;
sunken_bolt_head_depth = 2.01;
// Loose fit
planet_gear_shaft_radius_clearance = 0.15;
// Tight fit
sun_gear_shaft_radius_clearance = 0.09;
plinth_sun_gear_clearance = 0.1;

/*[ Plinth base (magenta)]*/
//Set to negative to match motor plinth height
plinth_base_height = -1.01;
plinth_radius_clearance = 0.15;

/*[ Annulus (silver)]*/
nema_size=17; //[11:Nema11, 14:Nema14, 17:Nema17, 23: Nema23,34: Nema34 ]
carrier_cap_recess_height = 2.2;
annulus_teeth_count = 36;
inclusions = 3; //[1: None, 2:Plinth base, 3: Cover]
hole_tolerance = 0.11;

/*[ Cover (red)]*/
//Set to negative to match motor plinth height
cover_height = -1.01;

/*[ Gear parameters sun: yellow planet: blue]*/
sun_teeth_count = 12;
gear_height = 5.5;
gear_backlash = 0.25;
gear_pressure_angle = 28;
gear_shaft_radius = 2.5;
gear_spacer_height = 0.3;

/*[ Carrier (green) ]*/
carrier_cap_height = 2.01;
carrier_radius_tolerance = 0.21;
carrier_height_clearance = 0.1;
carrier_gear_height_clearance = 0.11;
gear_cutout_radius_clearance = 0.5;
hex_nut_pockets = true;
hex_nut_hole_width = 5.99;
nut_distance_from_center = 11.5;
nut_orientation = 30;
mounting_hole_radius = 1.5;

/*[Output shaft (gray)]*/
// Set to negative to match motor plinth height
mounting_plate_height = -1.01;
mounting_plate_bolt_clearance = 0.5;
mounting_plate_radius_clearance = 0.25;
output_shaft_type = 2; //[1: Flat without motor shaft hole, 2: Flat with motor shaft hole, 3: sleeve only, 4: Output shaft on sleeve, 5: output D shaft on sleeve, 6: gear on sleeve ]
//Set to negative to match motor shaft length
output_sleeve_height = -1.01;
output_sleeve_cap_height = 2.01;
output_sleeve_outer_radius = 7.01;
output_sleeve_outer_side_count = 90;
//set to negative to match low friction fit to motor shaft
output_sleeve_inner_radius = -1.01;
output_sleeve_inner_side_count = 90;
//Set to negative to match the other gear heights
output_shaft_height = 10.1;
// Set to negative to match motor shaft
output_shaft_radius = -1.01;
output_shaft_side_count = 90;
output_shaft_bolt_hole_radius = 1.5;
output_gear_teeth_count = 12;
//This clearance allows for a bolt head or a nut to attach things
motor_shaft_to_sleeve_cap_clearance = 2.71;
/*[ Wheel Mounting Plate ]*/
wheel_sleeve_radius = 7.1;
internal_sleeve_radius = 5.2;
hex_size = 5.9;
hex_shaft_height = 8.2;

/*[ View ]*/
layout_for_print = true;
show_plinth_base = true;
show_frame = true;
show_cover = true;
show_carrier = true;
show_sun_gear = true;
show_planet_gears = true;
show_output_shaft = true;
show_wheel_output_shaft = false;
explode = 0; //[0:0.01:1]

$fn = 90;

//useful variables hidden from customizer from here
plinth_height = nema_motor_plinth_height(nema_size);
annulus_pitch_factor = 1 + (gear_backlash / 5 * 0.08); //1.004

//construction values
plinth_radius = nema_motor_plinth_diam(nema_size) / 2;
calc_motor_shaft_radius = nema_motor_shaft_diam(nema_size) / 2;
calc_hole_radius = (nema_motor_screw_size(nema_size) / 2);
calc_cover_height = cover_height < 0? plinth_height : cover_height;
calc_mounting_plate_radius = nut_distance_from_center + calc_hole_radius + hole_tolerance + mounting_plate_bolt_clearance;
calc_mounting_plate_height = mounting_plate_height < 0? plinth_height : mounting_plate_height;
calc_output_shaft_radius = output_shaft_radius < 0? calc_motor_shaft_radius : output_shaft_radius;
total_frame_height = (inclusions == 2? plinth_height : 0) + gear_height + carrier_cap_recess_height + (inclusions == 3? calc_cover_height : 0);
calc_sunken_bolt_head_depth = inclusions != 3? max(min(calc_cover_height - 1, sunken_bolt_head_depth), 0) : max(min(total_frame_height - 1, sunken_bolt_head_depth), 0);

//gear calculations
annulus_outer_radius = min(nema_motor_width(nema_size) / 2 - 1, nema_motor_screw_spacing(nema_size) / 2 * sqrt(2) - calc_hole_radius - hole_tolerance - 1);
gp = (annulus_outer_radius * 2 * PI) / annulus_teeth_count;
annulus_pitch_radius = annulus_outer_radius - gp / 2;
gear_pitch = (annulus_pitch_radius * 2 * PI) / annulus_teeth_count;
ACP = (annulus_pitch_radius*2/annulus_teeth_count) * 180;
planet_teeth_count = round((annulus_pitch_radius * 2 - sun_teeth_count * (ACP / 180)) / 2/(ACP / 180)); //Number of teeth on Planet Gear
ring_outer_radius = outer_radius(teeth = annulus_teeth_count, pitch = gear_pitch * annulus_pitch_factor, interior=true);
ring_root_radius = root_radius(teeth = annulus_teeth_count, pitch = gear_pitch * annulus_pitch_factor);
planet_outer_radius = outer_radius(teeth = planet_teeth_count, pitch = gear_pitch);
planet_pitch_radius = pitch_radius(gear_pitch, planet_teeth_count);
planet_root_radius = root_radius(teeth = planet_teeth_count, pitch = gear_pitch);
planet_spacer_width = min(1.5, (planet_root_radius - calc_motor_shaft_radius) * 0.8);
sun_outer_radius = outer_radius(teeth = sun_teeth_count, pitch = gear_pitch);
sun_pitch_radius = pitch_radius(gear_pitch, sun_teeth_count);
sun_root_radius = root_radius(teeth = sun_teeth_count, pitch = gear_pitch);
sun_spacer_width = min(1.5, (sun_root_radius - calc_motor_shaft_radius) * 0.8);
planet_distance = (annulus_pitch_radius - sun_pitch_radius)/2 + sun_pitch_radius;

echo("__________________________________________________");
echo("\tGear ratio\t\t: ", 1 + annulus_teeth_count / sun_teeth_count);
echo("\tGear pitch\t\t: ", gear_pitch);
echo("\tAnnulus teeth\t\t: ", annulus_teeth_count);
echo("\tAnnulus pitch radius\t: ", annulus_pitch_radius);
echo("\tSun\t\t: ", sun_teeth_count);
echo("\tSun pitch radius\t: ", sun_pitch_radius);
echo("\tSun root radius\t: ", sun_root_radius);
echo("\tSun outer radius\t: ", sun_outer_radius);
echo("\tPlanet\t\t: ", planet_teeth_count);
echo("\tPlanet pitch radius\t: ", planet_pitch_radius);
echo("\tPlanet root radius\t: ", planet_root_radius);
echo("\tTotal height\t\t: ", show_cover? total_frame_height + calc_cover_height : total_frame_height );
echo("__________________________________________________");

module baseHoles(include_shaft_hole = true){
    for(i = [0:2]){
        rotate([0,0,(i*120)-60])
        translate([nut_distance_from_center,0,-50])
        cylinder(h = 100, r = calc_hole_radius + hole_tolerance);
    }
    if (include_shaft_hole){
        translate([0,0,-1])
        cylinder(h = 102, r = calc_motor_shaft_radius + planet_gear_shaft_radius_clearance);
    }
}

module mounting_plate(include_shaft_hole = true){
    difference(){
        cylinder(h = calc_mounting_plate_height, r = calc_mounting_plate_radius, $fn=$fn*2);
        baseHoles(include_shaft_hole);
    }
}

module output_shaft(){
    calc_sleeve_height = plinth_height + nema_shaft_length_above_plinth - total_frame_height + carrier_cap_recess_height - carrier_cap_height;
    sh = output_sleeve_height < 0? calc_sleeve_height : calc_mounting_plate_height + output_sleeve_height + motor_shaft_to_sleeve_cap_clearance;
    ch = output_sleeve_height == 0? 0: output_sleeve_cap_height;
    si = output_sleeve_inner_radius <0? calc_motor_shaft_radius + planet_gear_shaft_radius_clearance : output_sleeve_inner_radius;
    gh = output_shaft_height <0? gear_height - gear_spacer_height : output_shaft_height;
    gt = output_gear_teeth_count <0? sun_teeth_count : output_gear_teeth_count;
    color("gray")
    union(){
        mounting_plate(include_shaft_hole = (output_shaft_type > 1));
        // sleeve
        difference(){
            union(){    
                cylinder(h = sh + ch, r = output_sleeve_outer_radius, $fn = output_sleeve_outer_side_count);
                if (output_shaft_type == 4 || output_shaft_type == 5){
                    translate([0,0,sh + ch - 0.01]){
                        difference(){
                            cylinder(h = output_shaft_height, r = calc_output_shaft_radius, $fn = output_shaft_side_count);
                            if (output_shaft_type == 5){
                                translate([-calc_output_shaft_radius, calc_output_shaft_radius * 0.8, -1])
                                cube([calc_output_shaft_radius * 2 ,calc_output_shaft_radius * 2, output_shaft_height + 2]);
                            }
                        }
                    }
                } 
                if (output_shaft_type == 6){
                    translate([0,0,sh + ch - 0.01])
                    spur_gear(teeth = gt, pitch = gear_pitch, anchor=BOTTOM, thickness = gh, pressure_angle = gear_pressure_angle, backlash = gear_backlash, spin=-90);
                }                
            }
            translate([0,0,-1])
            cylinder(h = sh + 1.01, r = si, $fn = output_sleeve_inner_side_count);
            //bolt hole
            if (output_shaft_bolt_hole_radius > 0){
                translate([0,0,sh -1]) cylinder(h = output_shaft_height + ch + 1, r = output_shaft_bolt_hole_radius + hole_tolerance);
            }
        }
    }
}

module wheel_output_shaft(){
    nut_radius = 6.01 / sqrt(3);
    nut_height = 2.6;
    cap_height = 1.5;
    slope_height = (internal_sleeve_radius - calc_motor_shaft_radius - planet_gear_shaft_radius_clearance) * 0.667;
    nut_slope = (nut_radius - calc_hole_radius - hole_tolerance) * 0.67;
    sleeve_height = plinth_height + nema_shaft_length_above_plinth + nut_height + nut_slope/2 + cap_height - total_frame_height + carrier_cap_recess_height - carrier_cap_height + 0.5;
    color("white")
    difference(){
        union(){
            if (calc_mounting_plate_height > 0){
                mounting_plate();
            }
            //sleeve
            cylinder(h = sleeve_height, r = wheel_sleeve_radius, $fn = $fn * 2);
            //hex shaft slotting into wheel
            cylinder(h = sleeve_height + hex_shaft_height, r = hex_size / sqrt(3), $fn=6);
        }
        translate([0,0,-1]){
            //shaft
            cylinder(h = sleeve_height - nut_height - cap_height + 1, r = calc_motor_shaft_radius + planet_gear_shaft_radius_clearance);
            
            //hollowing shaft with space for bearings
            cylinder(h = sleeve_height - nut_height - cap_height - slope_height + 1, r = internal_sleeve_radius);
            
            //cone to graduate to motor shaft radius
            translate([0,0, sleeve_height + 1  - cap_height - nut_height - slope_height])
            cylinder(h = slope_height, r1 = internal_sleeve_radius, r2 = calc_motor_shaft_radius + planet_gear_shaft_radius_clearance);
            
            //shaft bolt hole
            cylinder(h = sleeve_height + hex_shaft_height + 2, r = calc_hole_radius + hole_tolerance);
            
            //m3 nut pocket
            cylinder(h =sleeve_height - cap_height - nut_slope/2 + 1, r = nut_radius, $fn=6);
            
            //m3 nut cone  graduate to bolt hole radius
            translate([0,0,sleeve_height - cap_height - nut_slope/2 + 1])
            cylinder(h =nut_slope, r1 = nut_radius, r2= calc_hole_radius + hole_tolerance, $fn=6);
        }
    }
}

module nemaDShaft(nema_size = 17, radius = 2.5, height = 6){
    //flat is 80% of the radius
    shaft_radius = radius? radius : calc_motor_shaft_radius;
    difference() {
        cylinder(h = height, r =shaft_radius);
        translate([-shaft_radius,shaft_radius * 0.80, -1])
        cube([shaft_radius*2, shaft_radius*2, height + 2]);
    }    
}

module motor_mounting_holes(height = 6, sunken = true){
    hole_spacing = nema_motor_screw_spacing(nema_size) / 2;
    dist = nema_motor_screw_spacing(nema_size) * sqrt(2) * 0.5;
    union(){
        for(i = [0:3]){
            rotate([0,0,45 + i*90]){
                translate([dist, 0, 0])
                union(){
                    translate([0, 0, -1]) cylinder(h = height + 2, r = calc_hole_radius + hole_tolerance);
                    if (sunken && calc_sunken_bolt_head_depth > 0){
                        translate([0, 0, height - calc_sunken_bolt_head_depth]) cylinder(h = calc_sunken_bolt_head_depth + 1 , r = sunken_bolt_head_radius + hole_tolerance);
                    }
                }
            }
        }
    }
}

//motor_mounting_holes();

module framePlate(height = 6, sunken = true){
    motor_width = nema_motor_width(nema_size);
    mw = motor_width/2;
    mc = mw *0.8;
    difference(){
        linear_extrude(height){
            polygon([[-mw,mc],[-mc, mw],[mc,mw],[mw,mc],[mw,-mc],[mc, -mw],[-mc,-mw],[-mw,-mc]]);
        }
        motor_mounting_holes(height = height, sunken = sunken);
    }
}

module plinth_base(height = -1){
    ph = height <0? plinth_height : height;
    color("#843d90")
    difference(){
        framePlate(height = ph, sunken = false);
        translate([0,0,-1])
        cylinder(h = plinth_height+1.1, r = plinth_radius, $fn=$fn*2);
        translate([0,0,-1])
        cylinder(h = plinth_base_height + 2, r = calc_motor_shaft_radius + planet_gear_shaft_radius_clearance * 2, $fn=$fn*2);        
    }
}

module annulus(){
    ah = gear_height + carrier_height_clearance + carrier_cap_recess_height;
    difference(){
        //  body
        color("silver")
        framePlate(height = ah, sunken = (inclusions==343));
        //  internal gear
        color("gray")
        translate([0,0,-1])
        spur_gear(teeth=annulus_teeth_count, pitch = gear_pitch * annulus_pitch_factor, anchor=BOTTOM, pressure_angle = gear_pressure_angle, backlash = -gear_backlash, interior=true, thickness=ah + 2, spin=-90);
        
        //  carrier recess
        if (inclusions!=3){
            translate([0, 0, ah - carrier_cap_recess_height])
            cylinder(h = carrier_cap_recess_height + 1, r = ring_outer_radius, $fn=$fn*2);
        }
    }
}

module frame(){
    ph = inclusions == 2? plinth_height : 0;
    ah = gear_height + carrier_cap_recess_height + carrier_height_clearance;
    color("silver")
    union(){
        if (inclusions == 2) plinth_base(height = plinth_height);
        translate([0,0,ph]) annulus();
        if (inclusions == 3) translate([0, 0, ph + ah]) cover(sunken = true);
    }
}

module cover(sunken = true){
    color("#852020")
    difference(){
        framePlate(height = calc_cover_height, sunken = sunken);
        // plinth hole
        translate([0, 0, -1])
        cylinder(h = calc_cover_height + 2, r = calc_mounting_plate_radius + mounting_plate_radius_clearance, $fn = $fn*2);        
        translate([0, 0, -1])
        cylinder(h = calc_cover_height + 2, r = plinth_radius, $fn = $fn*2);
    }
}

module sunGear(teeth_count = 12){
    height = gear_height;
    ph = plinth_base_height < 0? plinth_height : plinth_base_height;
    color("#d8cb57")
    difference(){
        spur_gear(teeth=teeth_count, pitch = gear_pitch, anchor=BOTTOM, thickness = gear_height - gear_spacer_height, pressure_angle = gear_pressure_angle, backlash = gear_backlash, spin=-90);
        translate([0, 0, -1])
        nemaDShaft(radius = calc_motor_shaft_radius + sun_gear_shaft_radius_clearance, height = gear_height + 2);
        //Fully round shaft cutout
        translate([0, 0, gear_height - (motor_plinth_to_D_shaft - ph + plinth_height)+ plinth_sun_gear_clearance])
        cylinder(h = motor_plinth_to_D_shaft, r = calc_motor_shaft_radius + sun_gear_shaft_radius_clearance);
    }
}


module planetGear(){
    color("#2f6794")
    difference(){
        union(){
            translate([0 ,0, gear_spacer_height])
            spur_gear(teeth=planet_teeth_count, pitch = gear_pitch, anchor=BOTTOM, thickness = gear_height - gear_spacer_height, pressure_angle = gear_pressure_angle, backlash = gear_backlash, spin=-90);
            //spacer
            cylinder(h = gear_spacer_height + 1, r = calc_motor_shaft_radius + planet_spacer_width, $fn=$fn*2);            
        }
        translate([0, 0, -1])
        cylinder(gear_height + 2, r = gear_shaft_radius + planet_gear_shaft_radius_clearance);
    }
}

module carrier(){
    cut_planet_outer_radius = planet_outer_radius + gear_cutout_radius_clearance;
    cut_sun_outer_radius = sun_outer_radius + gear_cutout_radius_clearance;
    dist = (annulus_pitch_radius - sun_pitch_radius)/2 + sun_pitch_radius;
    inner_height = gear_height - carrier_height_clearance;
    carrier_cap_radius = inclusions==3? ring_root_radius : ring_outer_radius;
    
    color("#2a7b2a")
    union(){
        difference(){
            union(){
                difference(){
                    union(){
                        //  recessed part
                        translate([0, 0, gear_height + gear_spacer_height])
                        cylinder(h = carrier_cap_height, r = carrier_cap_radius - carrier_radius_tolerance, $fn=$fn*2);
                        //  part that fits inside the internal gear teeth
                        translate([0, 0, 0])
                        cylinder(h = gear_height + gear_spacer_height + carrier_gear_height_clearance + 1, r = ring_root_radius - carrier_radius_tolerance, $fn=$fn*2);
                    }
                    //  recesses for sun and planet gears
                    for(i = [0:2]){
                        rotate([0, 0, i * 120]) translate([dist, 0, -1]) cylinder(gear_height + gear_spacer_height + 1, r = cut_planet_outer_radius, $fn=$fn*2);
                    }
                }

                //  planet gear shafts
                translate([0, 0, 0]){
                    for(i = [0:2]){
                        rotate([0, 0, i*120]){
                            //  spacer
                            translate([dist, 0, gear_height])
                            cylinder(h = gear_spacer_height + 1, r = calc_motor_shaft_radius + planet_spacer_width, $fn = $fn*2);
                            //  shaft
                            translate([dist, 0, 0])
                            cylinder(h = gear_height, r = gear_shaft_radius, $fn = $fn*2);
                        }
                    }
                }
            }

            //  recess for sun gear
            translate([0, 0, -1])
            cylinder(gear_height + gear_spacer_height + 1, r = cut_sun_outer_radius, $fn=$fn*2);
            
            //  nut holes       
            nut_hole_radius = hex_nut_hole_width / sqrt(3); //  calculate inner radius of hexagon
            for(i = [0:2]){
                if (hex_nut_pockets){
                    rotate([0,0,60 + i * 120])
                    translate([nut_distance_from_center,0,-1])
                    rotate([0,0,nut_orientation])
                    cylinder(h = gear_height * 0.67 + 1, r = nut_hole_radius, $fn=6);
                }                        
                rotate([0,0,60 + i * 120])
                translate([nut_distance_from_center,0,-1])
                cylinder(h = gear_height + gear_spacer_height + carrier_cap_recess_height + 2, r = mounting_hole_radius + hole_tolerance);
            }
     
            //  shaft hole
            cylinder(h = gear_height + gear_spacer_height + carrier_cap_recess_height + 2, r = calc_motor_shaft_radius + planet_gear_shaft_radius_clearance);
        }
        //  sun spacer
        
        difference(){
            translate([0, 0, gear_height])
            cylinder(h = gear_spacer_height + 1, r = calc_motor_shaft_radius + sun_spacer_width, $fn=$fn*2);
            translate([0,0,-1])
            cylinder(h = carrier_cap_height + gear_height + 2, r = calc_motor_shaft_radius + planet_gear_shaft_radius_clearance);
        }
    }
}

//Rendering the parts

if (layout_for_print){
    spacing = 75;
    mw = nema_motor_width(nema_size);
    ph = plinth_base_height < 0? plinth_height : plinth_base_height;
    sp = inclusions==1? spacing: 0;
    
    if (show_plinth_base && inclusions!=2){
        ph = plinth_base_height < 0? plinth_height : plinth_base_height;
        rotate([180,0,0])
        translate([0,-spacing,-ph]) plinth_base(height = ph);
    }
    
    if (show_frame){
        if (inclusions==3){
            translate([0,0,total_frame_height])
            rotate([180,0,0])
            frame();
        } else {
            frame();
        }
    }

    if (show_cover && inclusions!=3){
        translate([sp, spacing, 0]) cover();
    }
    
    if (show_sun_gear){
        translate([-spacing, spacing, 0])
        sunGear(teeth_count = sun_teeth_count);
    }
    if (show_planet_gears){
        dist = pitch_radius(teeth = sun_teeth_count, pitch = gear_pitch) + pitch_radius(teeth = planet_teeth_count, pitch = gear_pitch);
        translate([-spacing, -spacing,gear_height]) rotate([180,0,0]) planetGear();
        translate([0, -spacing, gear_height]) rotate([180,0,0]) planetGear();
        translate([-spacing, 0, gear_height]) rotate([180,0,0]) planetGear();
    }
    if (show_carrier){
        translate([spacing, -spacing, gear_height + gear_spacer_height + carrier_cap_height])
        rotate([180,0,0])
        carrier();
    }
    
    if (show_output_shaft){
        translate([spacing,0,0]) output_shaft();
    }  
    
   
    if (show_wheel_output_shaft){
        translate([spacing,spacing,0])
        wheel_output_shaft();
    }  
} else {
    ph = inclusions==2? plinth_height : (plinth_base_height < 0? plinth_height : plinth_base_height);
    ch = inclusions==1? total_frame_height + ph : total_frame_height;
    if (show_plinth_base && inclusions!=2){
        translate([0, 0, explode*-15]) plinth_base(height=ph + 0.01);
    }
    if (show_frame){
        if (inclusions==2) translate([0,0,0]) frame();
        else translate([0,0,ph]) frame();
    }
    if (show_cover && inclusions!=3){
        translate([0,0,explode*80 + ch])
        cover();
    }
    if (show_sun_gear){
        ac = (1-planet_teeth_count%2) + (1-sun_teeth_count%2) == 0? 180/sun_teeth_count : 0;
        translate([0,0,explode*20 + ph + gear_height])
        rotate([180,0,(180/sun_teeth_count)*(1-planet_teeth_count%2)+ac])
        sunGear(teeth_count = sun_teeth_count);
    }
    if (show_planet_gears){
        dist = (annulus_pitch_radius - sun_pitch_radius)/2 + sun_pitch_radius;
        for(i = [0:2]){
            angle = i * 120 * (annulus_teeth_count * annulus_teeth_count / planet_teeth_count);
            rotate([0,0,i*120])
            translate([dist,0, explode*35 + ph + carrier_height_clearance])
            rotate([0,0,angle])
            planetGear();
        }
    }
    if (show_carrier){    
        translate([0,0,explode*50 + ph])
        carrier();
    }
    if (show_output_shaft){
        translate([0,0, explode*65 + ph + gear_height + gear_spacer_height + carrier_cap_height])//plinth_height + carrier_height_clearance + gear_height + carrier_gear_height_clearance + carrier_cap_height])
        output_shaft();
    }
    if (show_wheel_output_shaft){
        translate([0,0, explode*65 + ph + gear_height + gear_spacer_height + carrier_cap_height])//plinth_height + carrier_height_clearance + gear_height + carrier_gear_height_clearance + carrier_cap_height])
        wheel_output_shaft();
    }
}
