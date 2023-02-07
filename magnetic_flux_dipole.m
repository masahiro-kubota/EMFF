function B = magnetic_flux_dipole(x, y, z, I, a, N, n) 
%Calculates the magnetic field generated at position (x, y, z) by a magnetic dipole produced by a coil of radius a, current I, and number of turns N.
%   Detailed explanation goes he
    myu_0 = 1.2566*10^(-6);
    myu = N * I * pi * a^2 * n;
    r = [x, y, z];
    
    B = (myu_0/(4*pi))*((3*r*dot(myu, r)/norm(r)^5)-(myu/norm(r)^3));

end