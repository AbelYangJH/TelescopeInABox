use <threads.scad>
use <symmetry.scad>

function getShaftODia(PoleDia, Wall) = PoleDia+$collet_tol*2+Wall*4;
function getThreadDia(PoleDia, Wall, Pitch) = getShaftODia(PoleDia, Wall)+thread_depth(Pitch);
function getInnerBottomDia(PoleDia, Wall) = PoleDia+Wall;
function getInnerTopDia(PoleDia, Wall) = getShaftODia(PoleDia, Wall)-Wall;
function getOuterTopDia(PoleDia, Wall) = PoleDia+$collet_tol*2+Wall;

module ColletBase(PoleDia, Wall, Pitch, Length, LowerLength, BaseOuterDia, CrushRibs=true, extra_tol=0) {
  ShaftODia = getShaftODia(PoleDia,Wall);
  ThreadDia = getThreadDia(PoleDia, Wall, Pitch);
  InnerBottomDia = getInnerBottomDia(PoleDia,Wall);
  InnerTopDia = getInnerTopDia(PoleDia,Wall);
  OuterTopDia = getOuterTopDia(PoleDia,Wall);
  
  TaperLength = (ShaftODia-BaseOuterDia);
  
  difference() {
    union() {
      translate([0,0,LowerLength+Wall-Pitch]) metric_thread(diameter=ThreadDia-extra_tol,pitch=Pitch,length=Length-Wall+Pitch,leadin=2);
      translate([0,0,TaperLength]) cylinder(d=ShaftODia,h=LowerLength-TaperLength+Wall);
      cylinder(d1=BaseOuterDia,d2=ShaftODia,h=TaperLength);
    }
    
    rotate_extrude() {
      polygon([[0,-1],[PoleDia/2+$collet_tol,-1],[PoleDia/2+$collet_tol,LowerLength],[InnerBottomDia/2,LowerLength+Wall/2],[InnerTopDia/2,LowerLength+Length],[0,LowerLength+Length+0.01]]);
    }
    translate([0,0,-Wall-1]) cylinder(d=PoleDia+$collet_tol*2,h=Wall+2);
  }
  if (CrushRibs==true) {
    rsym(12) translate([PoleDia/2+$collet_tol,0,LowerLength/2]) hull() translate_zs([0,0,LowerLength/2-Wall])sphere(d=1,$fn=16);
  }
}

module ColletClamp(PoleDia, Wall, Pitch, Length, LowerLength, nc=8, brim=0, expand=$collet_tol*2) {
  ShaftODia = getShaftODia(PoleDia,Wall);
  ThreadDia = getThreadDia(PoleDia, Wall, Pitch);
  InnerBottomDia = getInnerBottomDia(PoleDia,Wall);
  InnerTopDia = getInnerTopDia(PoleDia,Wall);
  OuterTopDia = getOuterTopDia(PoleDia,Wall);
  Ratio = (Length-Wall/2)/((InnerTopDia-InnerBottomDia)/2);

  $fn=144;
  Length=Length+Wall;
  translate([0,0,Wall]) union() {
    difference() {
      union() {
        rotate_extrude() {
          polygon([[PoleDia/2+$collet_tol,Wall],[InnerBottomDia/2+Wall/Ratio+expand,Wall],[InnerTopDia/2+expand,Length],[InnerTopDia/2-Wall+expand,Length+Wall*1.25],[PoleDia/2+$collet_tol,Length+Wall*1.25] ]);
        }
      }
      rsym(nc) {
        cube([InnerTopDia+Wall*2+10,$collet_tol*3,Length*2],center=true);
        rotate((360/nc/2)) translate([0,0,Length+Wall*2.5]) cube([InnerTopDia+Wall*2,$collet_tol*3,Length*2],center=true);
      }
    }
    translate([0,0,Wall*1.5]) difference() {
      cylinder(d=PoleDia+10,h=brim);
      translate([0,0,-1]) cylinder(r=InnerBottomDia/2+Wall/Ratio,h=Wall+brim+2);
    }
  }
}

module ColletLock(PoleDia, Wall, Pitch, Length, LowerLength) {
  ShaftODia = getShaftODia(PoleDia,Wall);
  ThreadDia = getThreadDia(PoleDia, Wall, Pitch);
  InnerBottomDia = getInnerBottomDia(PoleDia,Wall);
  InnerTopDia = getInnerTopDia(PoleDia,Wall);
  OuterTopDia = getOuterTopDia(PoleDia,Wall);
  CapHeight=Length+Wall*2.25;
  CapODia = ThreadDia+Wall*2+$collet_tol*2;
  difference() {
    union() {
      cylinder(d=CapODia,h=CapHeight);
      translate([0,0,CapHeight]) cylinder(d1=ThreadDia+Wall*2,d2=ThreadDia+Wall*1.5,h=Wall/3);
      rsym(round(PI*(ThreadDia+Wall*2)/5)) translate([CapODia/2,0,CapHeight/2]) hull() translate_zs([0,0,CapHeight/2-Wall-1]) sphere(d=1.25,$fn=16);
    }
    
    translate([0,0,-1]) cylinder(d1=ThreadDia+2,d2=ThreadDia-2,h=2);
    metric_thread(diameter=ThreadDia+$collet_tol*3,pitch=Pitch,length=Length+Wall,internal=true);
    translate([0,0,Length+Wall-0.01]) cylinder(d1=InnerTopDia,d2=InnerTopDia-Wall*2,h=Wall*1.25+0.02);
    translate([0,0,Length+Wall*2]) cylinder(d=InnerTopDia-Wall*2,h=Wall);
  }
}

module ColletJoint(PoleDia, Wall, Pitch, Length, LowerLength, BaseOuterDia, CapLength, CrushRibs=true, extra_tol=0) {
  
  union() {
    ColletBase(PoleDia, Wall, Pitch, Length, LowerLength, BaseOuterDia, CrushRibs, extra_tol);
    difference() {
      translate([0,0,-CapLength-Wall]) cylinder(d=BaseOuterDia, h=CapLength+Wall);
      translate([0,0,-CapLength-Wall-1]) cylinder(d=PoleDia+$collet_tol*2, h=CapLength+1);
    }
    if (CrushRibs == true) rsym(12) translate([PoleDia/2+$collet_tol,0,-Wall-CapLength/2]) hull() translate_zs([0,0,CapLength/2-Wall]) sphere(d=1+$collet_tol,$fn=16);
  }
}

module TestCollet() {
$fa=2.5;
$fs=1;
$collet_tol=0.25;
PoleDia=20;
Wall=1.8;
Pitch=2;
Length=20;
LowerLength=15;
CapLength=30;
CapOuterDia=26;

intersection() {
  union() {
    color("yellow") {
      ColletJoint(PoleDia, Wall, Pitch, Length, LowerLength, CapOuterDia, CapLength);
    }
    color("red") translate([0,0,LowerLength]) ColletClamp(PoleDia, Wall, Pitch, Length, LowerLength);
    color("blue") translate([0,0,LowerLength+0.1]) ColletLock(PoleDia, Wall, Pitch, Length, LowerLength);
  }
  CR=100;
  translate([0,-CR,-CR]) cube([CR,CR*2,CR*2]);
}
color("grey",0.5) translate([0,0,-10]) cylinder(d=PoleDia,h=100);
}

TestCollet();
