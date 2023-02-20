function draw_coil(x, q, a)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
%quat2 = quaternion([p2, q2, l2],'euler','XYZ','point');
t = linspace(0,2*pi,100);
x0 = x(1);
y0 = x(2);
z0 = x(3);
coil2_x = rotatepoint(q,[zeros(1,100); a*sin(t); a*cos(t)].').';
coil2_y = rotatepoint(q,[a*sin(t); zeros(1,100); a*cos(t)].').';
coil2_z = rotatepoint(q,[a*sin(t); a*cos(t); zeros(1,100)].').';
plot3(coil2_x(1,:) + x0, coil2_x(2,:) + y0, coil2_x(3,:) + z0)
hold on
plot3(coil2_y(1,:) + x0, coil2_y(2,:) + y0, coil2_y(3,:) + z0)
plot3(coil2_z(1,:) + x0, coil2_z(2,:) + y0, coil2_z(3,:) + z0)
hold on
end