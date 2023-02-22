function [F, T] = dipole_FT(quat1, quat2, X, I1, I2)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

myu0 = 1.2566*10^(-6);
N = 17;
a = 0.015;
S = pi*a^2;

myu1 = N*I1*S;
myu2 = N*I2*S;

F = 3*myu0/(4*pi)*()

end