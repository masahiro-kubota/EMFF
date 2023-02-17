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
%nt = n*t;

%x_d = 0.05/2*[2*sin(nt), sqrt(3)*cos(nt), cos(nt), 2*n*cos(nt), -sqrt(3)*n*sin(nt), -n*cos(nt)].';
%v_d = 0.05/2*[2*n*cos(nt), -sqrt(3)*sin(nt), -n*cos(nt), -2*n^2*sin(nt), -sqrt(3)*n^2*cos(nt), -n^2*sin(nt)].';


T = 1;%1ステップあたりT秒
N = 6;

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


%B_sharp = (B.'*B)\B.';



%u = repmat([1,0,0].', [N,1]);

A_d = eye(6) + T*A;%差分方程式の係数
B_d = T*B;%差分方程式の係数
c = cos(n*T);
tau = n*T;
s = sin(n*T);

A_d = [1, 0, 6*(tau-s), (4*s-3*tau)/n, 0, 2*(1-c)/n;
       0, c, 0, 0, s/n, 0;
       0, 0, 4-3*c, 2*(c-1)/n, 0, s/n;
       0, 0, 6*n*(1-c), 4*c-3, 0, 2*s;
       0, -n*s, 0, 0, c, 0;
       0, 0, 3*n*s, -2*s, 0, c];

B_d = [(4*s-3*tau)/n, 0, 2*(1-c)/n;
       0, s/n, 0;
       2*(c-1)/n, 0, s/n;
       4*c-3, 0, 2*s;
       0, c, 0;
       -2*s, 0, c];%差分方程式の係数

Q = diag([1, 1, 100, 1, 1, 1]);
R = diag([10^7, 10^3, 10^7]);

[X,K,ll] = icare(A_d,B_d,Q,R,[],[],[]);


%{
%レコード盤軌道に乗る初期条件
x0 = 0;
y0 = 0.05*sqrt(3)/2;
z0 = 0.05*1/2;
v_x = 0.05 * 2*n/2;
v_y = 0;
v_z = 0;
%}

x0 = 0.05;
y0 = 0;
z0 = 0;
v_x = 0;
v_y = 0;
v_z = 0;

x_0 = [x0, y0, z0, v_x, v_y, v_z];

X = zeros(N, 6);
X(1,:) = x_0;
i = 0;

%{
K = [0,0,0,0,0,0;
     0,0,0,0,0,0;
     0,0,0,0,0,0];
%}

x_d = @(t) 0.05*[-1,0,0,0,0,0].';
v_d = @(t) 0.05*[0,0,0,0,0,0].';
u_d = @(t) B_sharp*(v_d(t) - A_d*x_d(t));
x_tilda = @(i) X(i, :).' - x_d(i*T);
u_tilda = @(i) -K*x_tilda(i);
u = @(i) u_tilda(i) + u_d(i*T);


u_data = zeros(N,1);

norm_data = zeros(N,1);
x_tilda_data = zeros(N,1);
tic
while i < N %時刻i*T
    i = i + 1;
    %t = i*T;
    %nt = n*t;
    %x_d = 0.05/2*[2*sin(nt), sqrt(3)*cos(nt), cos(nt), 2*n*cos(nt), -sqrt(3)*n*sin(nt), -n*sin(nt)].';
    %v_d = 0.05/2*[2*n*cos(nt), -sqrt(3)*n*sin(nt), -n*sin(nt), -2*n^2*sin(nt), -sqrt(3)*n^2*cos(nt), -n^2*cos(nt)].';
    %x_tilda =X(i, :).' - x_d(t);
    %u_d = B_sharp*(v_d - A*x_d);
    %u_d = -K*x_tilda(i);
    X(i+1, :) = A_d*x_tilda(i) + B_d*u_tilda(i) + x_d((i+1)*T);
    disp(x_tilda(i))
    %disp(u_d)
    norm_data(i, 1) = norm(X(i, :)-x_d(i*T).');

    
    u_data(i,1) = norm(u(i));
    x_tilda_data(i) = norm(x_tilda(i)) ;
    %disp(norm(X(i, :)-x_d((i)*T).'))
end
toc

%figure
%plot(1:N, u_data)

figure
plot(1:N, x_tilda_data)



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