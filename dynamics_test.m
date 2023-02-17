%レコード盤軌道再現
%オイラー法


p1 = 0;
q1 = 0;
l1 = 0;
p2 = 0;
q2 = 0;
l2 = 0;

a = 0.015;


myu = 3.986*10^14;
earth_radius = 6378.140*10^3;

altitude = 500*10^3;%高度
r_star = earth_radius + altitude;

n = sqrt(myu/r_star^3);
%disp(2*pi/(n*60)) 軌道周期

m = 0.05;%衛星質量

T = 1;%1ステップあたりT秒
N = 90*60;

A = [0, 0, 0, 1, 0, 0;
     0, 0, 0, 0, 1, 0;
     0, 0, 0, 0, 0, 1;
     0, 0, 0, 0, 0, 2*n;
     0, -n^2, 0, 0, 0, 0;
     0, 0, 3*n^2, -2*n, 0, 0];

B = [0, 0, 0;
     0, 0, 0;
     0, 0, 0;
     1/m, 0, 0;
     0, 1/m, 0;
     0, 0, 1/m];

u = repmat([0,0,0].', [N,1]);

A_d = eye(6) + T*A;%差分方程式の係数
B_d = T*B;%差分方程式の係数

%{
%レコード盤軌道に乗る初期条件
x0 = 0;
y0 = 0.05*sqrt(3)/2;
z0 = 0.05*1/2;
v_x = 0.05 * 2*n/2;
v_y = 0;
v_z = 0;
%}


x0 = 0;
y0 = 0.05*sqrt(3)/2;
z0 = 0.05/2;
v_x = 2*n*0.05/2;
v_y = 0;
v_z = 0;
%{
%レコード盤軌道
x0 = 0;
y0 = 0.05*sqrt(3)/2;
z0 = 0.05/2;
v_x = 2*n*0.05/2;
v_y = 0;
v_z = 0;
%}

x_0 = [x0, y0, z0, v_x, v_y, v_z];
X = zeros(N, 6);
X(1,:) = x_0;
i = 0;

tic
while i < N
    i = i + 1;
    X(i+1, :) = A_d*X(i, :).' + B_d*u(3*(i-1)+1:3*(i-1)+3, 1);
    disp(X(i+1, :))
end
toc





figure
t = linspace(0,2*pi,100);
axis_norm = 0.2;

%{
quat1 = quaternion([p1, q1, l1],'euler','XYZ','point');

coil1_x = rotatepoint(quat1,[zeros(1,100); a*sin(t); a*cos(t)].').';
coil1_y = rotatepoint(quat1,[a*sin(t); zeros(1,100); a*cos(t)].').';
coil1_z = rotatepoint(quat1,[a*sin(t); a*cos(t); zeros(1,100)].').';
plot3(coil1_x(1,:), coil1_x(2,:), coil1_x(3,:))

plot3(coil1_y(1,:), coil1_y(2,:), coil1_y(3,:))
plot3(coil1_z(1,:), coil1_z(2,:), coil1_z(3,:))
%磁場を作るコイル
%}


quat2 = quaternion([p2, q2, l2],'euler','XYZ','point');

coil2_x = rotatepoint(quat2,[zeros(1,100); a*sin(t); a*cos(t)].').';
coil2_y = rotatepoint(quat2,[a*sin(t); zeros(1,100); a*cos(t)].').';
coil2_z = rotatepoint(quat2,[a*sin(t); a*cos(t); zeros(1,100)].').';
plot3(coil2_x(1,:) + x0, coil2_x(2,:) + y0, coil2_x(3,:) + z0)
hold on
plot3(coil2_y(1,:) + x0, coil2_y(2,:) + y0, coil2_y(3,:) + z0)
plot3(coil2_z(1,:) + x0, coil2_z(2,:) + y0, coil2_z(3,:) + z0)
%電磁力を受けるコイル

%q1 = quiver3(x,y,z,F(1)*10^5,F(2)*10^5,F(3)*10^5);
%q1.Color = "red";
%q2 = quiver3(x,y,z,T(1)*10^5,T(2)*10^5,T(3)*10^5, 10);
%q2.Color = "blue";
%disp(F)
%disp(T)

plot3(0,0,0,'ro');

axis([-axis_norm,axis_norm,-axis_norm,axis_norm,-axis_norm,axis_norm])
axis square 
grid on
xlabel('X')
ylabel('Y')
zlabel('Z')
%quiver3(X,Y,Z,B_x,B_y,B_z, 1/(20 * norm([B_x B_y B_z])))

plot3(X(:,1), X(:,2), X(:,3),'c')
