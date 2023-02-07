function [F, T] = Ampere(I1_x, I1_y, I1_z, I2_x, I2_y, I2_z, a, N, x, y, z, p, q, l)
%原点にあるN巻き，半径a，電流Iのコイルによって，(x, y, z)にあるN巻き，半径a，電流I_x, I_y, I_zのコイルに発生するアンペール力（力，トルク）
%   Detailed explanation goes here

i = 0;
split = 100;
d_phi = 2*pi/split;
phi = 0;
F = [0, 0, 0];
T = [0, 0, 0];

%z coil
while i < split
    
    i = i + 1;
    phi = phi + d_phi;
    B = magnetic_flux_three_coil(a*cos(phi) + x, a*sin(phi) + y, z, I2_x, I2_y, I2_z, a, N, p, q, l);
    %disp(norm(B))
    d_I = I1_z * N * [-sin(phi), cos(phi), 0] * d_phi;
    d_F = cross(d_I, B);
    %d_F = Ampere(I, phi, B);
    d_T = cross([a*cos(phi), a*sin(phi), 0], d_F);
    %disp(d_B)
    %disp(d_F)
    F = F + d_F;
    T = T + d_T;
end

%y_coil
i = 0;
phi = 0;
while i < split
    
    i = i + 1;
    phi = phi + d_phi;
    B = magnetic_flux_three_coil(a*sin(phi) + x, y, a*cos(phi) + z, I2_x, I2_y, I2_z, a, N, p, q, l);
    d_I = I1_y  * N* [cos(phi), 0, -sin(phi)] * d_phi;
    d_F = cross(d_I, B);
    %d_F = Ampere(I, phi, B);
    d_T = cross([a*cos(phi), 0, a*sin(phi)], d_F);
    %disp(d_B)
    F = F + d_F;
    T = T + d_T;
end

%x_coil
i = 0;
phi = 0;
while i < split
    
    i = i + 1;
    phi = phi + d_phi;
    B = magnetic_flux_three_coil(x, a*cos(phi) + y, a*sin(phi) + z, I2_x, I2_y, I2_z, a, N, p, q, l);
    d_I = I1_x * N* [0, -sin(phi), cos(phi)] * d_phi;
    d_F = cross(d_I, B);
    %d_F = Ampere(I, phi, B);
    d_T = cross([0, a*cos(phi), a*sin(phi)], d_F);
    %disp(d_B)
    F = F + d_F;
    T = T + d_T;
end

%disp(T)
%disp(F)

end