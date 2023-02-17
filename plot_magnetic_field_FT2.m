function[F, T] = plot_magnetic_field_FT2(p1, q1, l1, p2, q2, l2, x, I1, I2, splitB, splitA)
%磁場と電磁力を3D表示
%2つのコイルの電流3次元，姿勢3次元から，磁場と電磁力を計算．
%   Detailed explanation goes here


%3Dに磁場の向きを表示
%ite = 3;
%表示の細かさを調節



%[X,Y,Z] = meshgrid(linspace(-0.1,0.1,ite),linspace(-0.1,0.1,ite),linspace(-0.1,0.1,ite));
X = 0.1;
Y = 0;
Z = 0;

%磁場を発生させるコイル
I1_x = I1(1);
I1_y = I1(2);
I1_z = I1(3);
a = 0.015;
N = 1;
%p1 = 0;
%q1 = 0;
%l1 = 0;%変数
%disp(size(X));


%力を受けるコイルの位置と電流
%x = 0.1;　変数
y = 0;
z = 0;
I2_x = I2(1);
I2_y = I2(2);
I2_z = I2(3);
%p2 = 0;
%q2 = 0;
%l2 = 0;　変数


[F, T] = Ampere2(I2_x, I2_y, I2_z, I1_x, I1_y, I1_z, a, N, x, y, z, p1, q1, l1, p2, q2, l2, splitB, splitA);


%{
B = magnetic_flux_three_coil(X, Y, Z, I1_x, I1_y, I1_z, a, N, p1, q1, l1, splitB);       
B_x = B(1);
B_y = B(2);
B_z = B(3);

disp("B_coil is " + B)

figure
t = linspace(0,2*pi,100);
axis_norm = 0.2;

quat1 = quaternion([p1, q1, l1],'euler','XYZ','point');

coil1_x = rotatepoint(quat1,[zeros(1,100); a*sin(t); a*cos(t)].').';
coil1_y = rotatepoint(quat1,[a*sin(t); zeros(1,100); a*cos(t)].').';
coil1_z = rotatepoint(quat1,[a*sin(t); a*cos(t); zeros(1,100)].').';
plot3(coil1_x(1,:), coil1_x(2,:), coil1_x(3,:))
hold on
plot3(coil1_y(1,:), coil1_y(2,:), coil1_y(3,:))
plot3(coil1_z(1,:), coil1_z(2,:), coil1_z(3,:))
%磁場を作るコイル

quat2 = quaternion([p2, q2, l2],'euler','XYZ','point');

coil2_x = rotatepoint(quat2,[zeros(1,100); a*sin(t); a*cos(t)].').';
coil2_y = rotatepoint(quat2,[a*sin(t); zeros(1,100); a*cos(t)].').';
coil2_z = rotatepoint(quat2,[a*sin(t); a*cos(t); zeros(1,100)].').';
plot3(coil2_x(1,:) + x, coil2_x(2,:) + y, coil2_x(3,:) + z)
plot3(coil2_y(1,:) + x, coil2_y(2,:) + y, coil2_y(3,:) + z)
plot3(coil2_z(1,:) + x, coil2_z(2,:) + y, coil2_z(3,:) + z)
%電磁力を受けるコイル

q1 = quiver3(x,y,z,F(1)*10^5,F(2)*10^5,F(3)*10^5);
q1.Color = "red";
q2 = quiver3(x,y,z,T(1)*10^5,T(2)*10^5,T(3)*10^5, 10);
q2.Color = "blue";
%disp(F)
%disp(T)

axis([-axis_norm,axis_norm,-axis_norm,axis_norm,-axis_norm,axis_norm])
axis square 
grid on
xlabel('X')
ylabel('Y')
zlabel('Z')
quiver3(X,Y,Z,B_x,B_y,B_z, 1/(20 * norm([B_x B_y B_z])))

end
%}

