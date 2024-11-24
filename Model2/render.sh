#!/bin/bash
for j in {PRIC,BASE,SARM,SECA,FOCA}*.scad; do openscad -o "1148FDM-${j/.scad/.stl}" "${j}"; done
