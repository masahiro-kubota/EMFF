function B = magnetic_flux_z2(x, y, z, I, a, N, p, q, l, split) 
% Calculate the magnetic field vector created at (x, y, z) by the coil with radius a, number of turns N, and current I at the origin
%   Detailed explanation goes here
myu = 1.2566*10^(-6); %
pi = 3.1415926536; 


%a = 0.015;
%I = 1;
%split = 100;
d_phi = 2*pi/split;

%{
x = 0;
y = 0;
z = 0;
%}

quat = quaternion([p,q,l],'euler','XYZ','point');
phi = 0;


B = [0, 0, 0];
i = 0;
r = [x, y, z];
%disp(d_B)
%disp(x)

while i < split
    i = i + 1;
    phi = phi + d_phi;
    s = rotatepoint(quat, [a*cos(phi), a*sin(phi), 0]);
    d_s = rotatepoint(quat, [-a * sin(phi), a * cos(phi), 0]*d_phi);
    d_B = ((myu*N*I)/(4*pi))*norm(r-s)^(-3)*cross(d_s,r-s);
    %disp(d_B)
    B = B + d_B;
end


end