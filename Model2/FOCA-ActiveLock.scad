include <FullAssembly.scad>
/* [Hidden] */
isStandalone=false;

// Backplate/Inner Thread
Focuser_ActiveLock($foc_plate*1.5, foc_inner, helicoid_thread, helicoid_tstarts, baselock_thread, flange,thread_tol=0.95);
