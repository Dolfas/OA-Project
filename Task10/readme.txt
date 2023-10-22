Sample trajectories and (noiseless) measurements for sections 2 (racetrack.mat) and 3 (mh370.mat) of OA project 2023/24

Use these to test and validate your code. *Do not* use for the final results to be included in your report; you should generate your own trajectories for that.

Racetrack:

xgt: Ground-truth source positions. First dimension is time, second are horizontal/vertical coordinates
vgt: Ground-truth source velocities. First dimension is time, second are horizontal/vertical coordinates
tref: Reference time instants for the trajectory
a: Anchor positions. First dimension is anchor index, second are horizontal/vertical coordinates
r: Range measurements. First dimension is time, second is anchor index
u: Measured angular direction vectors. First dimension are horizontal/vertical coordinates, second is anchor index, third is time
v: Measured velocities. Same as ground-truth velocities


MH370:

xgt: Ground-truth source positions. First dimension is time, second are horizontal/vertical coordinates. x0 is the first ground-truth position, corresponding to a reference time t = 0
vgt: Ground-truth source velocities. First dimension is time, second are horizontal/vertical coordinates. In this scenario velocities remain constant over time
tref: Reference time instants for the trajectory
a: Anchor positions. First dimension is anchor index, second are horizontal/vertical coordinates
r: Range measurements. First dimension is time, second is anchor index
u: Measured angular direction vectors. First dimension are horizontal/vertical coordinates, second is anchor index, third is time
v: Measured velocities. Same as ground-truth velocities
rr: Range rate measurements. First dimension is time, second is anchor index
