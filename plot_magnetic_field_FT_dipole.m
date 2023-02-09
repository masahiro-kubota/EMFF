function[F, T] = plot_magnetic_field_FT_dipole(p1, q1, l1, p2, q2, l2, x)
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
I1_x = 1;
I1_y = 1;
I1_z = 1;
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
I2_x = 1;
I2_y = 1;
I2_z = 1;
%p2 = 0;
%q2 = 0;
%l2 = 0;　変数

r = [x, 0, 0];

A = pi*a^2;

myu1 = N*A*[I1_x, I1_y, I1_z];
myu2 = N*A*[I2_x, I2_y, I2_z];

[F, T] = dipole2em_force_torque(myu1, myu2, r);


B = dipole2m_field(myu1, [X, Y, Z]);    
B_x = B(1);
B_y = B(2);
B_z = B(3);
disp("B_dipole is" + B)



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

q1 = quiver3(x,y,z,F(1)*10^7,F(2)*10^7,F(3)*10^7);
q1.Color = "red";
q2 = quiver3(x,y,z,T(1)*10^7,T(2)*10^7,T(3)*10^7, 10);
q2.Color = "blue";
%disp(F)
%disp(T)

axis([-axis_norm,axis_norm,-axis_norm,axis_norm,-axis_norm,axis_norm])
axis square 
grid on
xlabel('X')
ylabel('Y')
zlabel('Z')
quiver3(0,0,0,myu1(1),myu1(2),myu1(3), 1/(20*norm(myu1)))

end