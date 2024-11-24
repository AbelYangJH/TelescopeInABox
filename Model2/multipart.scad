/* Pick a color below for STL export, or "ALL" to show all colors. */
current_part = "ALL";
//current_color = "black";
//current_color = "white";
//current_color = "red";

/* Similar to the color function, but can be used for generating multi-color models for printing.
 * The global current_color variable indicates the color to print.
 */
module multipart(pname, colour=undef, alpha=1.0) {
    if (current_part != "ALL" && current_part != pname) { 
        // ignore our children.
    } else {
        color(colour, alpha)
        children();
    }        
}
//
//This can then be used to allow different additive solids to be rendered in different colors. As a very basic use-case:
//
//multicolor("red") cube(20, center=true);
//multicolor("green") translate([0,0,10]) sphere(10);
//
//Which when rendered with current_color = "ALL"; results in a multi-color object: