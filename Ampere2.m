function [F, T] = Ampere2(I2_x, I2_y, I2_z, I1_x, I1_y, I1_z, a, N, x, y, z, p1, q1, l1, p2, q2, l2, splitB, splitA)
%原点にあるN巻き，半径a，電流Iのコイルによって，(x, y, z)にあるN巻き，半径a，電流I_x, I_y, I_zのコイルに発生するアンペール力（力，トルク）
%   Detailed explanation goes here

i = 0;
%split2 = 100;
d_phi = 2*pi/splitA;
phi = 0;
F = [0, 0, 0];
T = [0, 0, 0];
quat = quaternion([p2,q2,l2],'euler','XYZ','point');


%z coil
while i < splitA
    
    i = i + 1;
    phi = phi + d_phi;
    rot_point_z = rotatepoint(quat, [a * cos(phi), a * sin(phi), 0]);
    B = magnetic_flux_three_coil(rot_point_z(1) + x, rot_point_z(2) + y, rot_point_z(3) + z, I1_x, I1_y, I1_z, a, N, p1, q1, l1, splitB);
    %disp(norm(B))
    d_I = I2_z * N * rotatepoint(quat, [-sin(phi), cos(phi), 0]) * d_phi;
    %disp(I2_z)
    %disp(B)
    d_F = cross(d_I, B);
    %d_F = Ampere(I, phi, B);
    d_T = cross(rotatepoint(quat, [a*cos(phi), a*sin(phi), 0]), d_F);
    %disp(d_B)
    F = F + d_F;
    T = T + d_T;
end

%y_coil
i = 0;
phi = 0;
while i < splitA
    
    i = i + 1;
    phi = phi + d_phi;
    rot_point_y = rotatepoint(quat, [a * sin(phi), 0, a * cos(phi)]);
    B = magnetic_flux_three_coil(rot_point_y(1) + x, rot_point_y(2) + y, rot_point_y(3) + z, I1_x, I1_y, I1_z, a, N, p1, q1, l1, splitB);
    d_I = I2_y  * N* rotatepoint(quat, [cos(phi), 0, -sin(phi)] )* d_phi;
    
    d_F = cross(d_I, B);
    %d_F = Ampere(I, phi, B);
    d_T = cross(rotatepoint(quat, [a*sin(phi), 0, a*cos(phi)]), d_F);
    %disp(d_B)
    F = F + d_F;
    T = T + d_T;
end



%x_coil
i = 0;
phi = 0;
while i < splitA
    
    i = i + 1;
    phi = phi + d_phi;
    rot_point_x = rotatepoint(quat, [0, a * cos(phi), a * sin(phi)]);
    B = magnetic_flux_three_coil(rot_point_x(1) + x, rot_point_x(2) + y, rot_point_x(3) + z, I1_x, I1_y, I1_z, a, N, p1, q1, l1, splitB); 
    d_I = I2_x * N* rotatepoint(quat, [0, -sin(phi), cos(phi)]) * d_phi;
    %d_I = I2_x * N* [0, -sin(phi), cos(phi)]  * d_phi;
    d_F = cross(d_I, B);
    %d_F = Ampere(I, phi, B);
    %disp(d_F)
    d_T = cross(rotatepoint(quat, [0, a*cos(phi), a*sin(phi)]), d_F);
    %disp(d_B)
    F = F + d_F;
    %disp("d_F is")
    %disp(d_F)
    %disp("F is")
    %disp(F)
    T = T + d_T;
end

%disp(T)
%disp(F)

end