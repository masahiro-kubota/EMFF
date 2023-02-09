function [F, T] = dipole2em_force_torque(myu1, myu2, r) 
%Calculates the electromagnetic force and torque by a magnetic dipole myu1 and myu2
%   Detailed explanation goes he
    myu_0 = 1.2566*10^(-6);
    %myu = N * I * pi * a^2 * n;
    n_r = norm(r);
    
    %B = (myu_0/(4*pi))*((3*r*dot(myu, r)/norm(r)^5)-(myu/norm(r)^3);

    F = (3*myu_0/(4*pi))*((dot(myu1, myu2)/n_r^5)*r + (dot(myu1, r)/n_r^5)*myu2 + (dot(myu2, r)/n_r^5)*myu1...
        -5*(dot(myu1, r)*dot(myu2, r)/n_r^7)*r);

    T = myu_0/(4*pi)*cross(myu2, (3*dot(myu1, r)/n_r^5)*r - myu1/n_r^3);

end