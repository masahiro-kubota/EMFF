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


T = 1;%1ステップあたりT秒
N = 60*90;

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


B_sharp = (B.'*B)\B.';
c = cos(n*T);
tau = n*T;
s = sin(n*T);
%{
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
%}

A_d = eye(6) + T*A;%差分方程式の係数
B_d = T*B;%差分方程式の係数

Q = diag([1, 1, 100, 0, 0, 0]);
R = diag([10^7, 10^5, 10^7]);

[X,K,ll] = icare(A,B,Q,R,[],[],[]);


X = zeros(N, 6);
%X(1,:) = 0.05/2*[0, sqrt(3), 1, 2*n, 0, 0];%初期値代入 最初からレコード盤

X(1,:) = 0.05/2*[10, 10, 0, 0, 0, 0];%初期値代入

%x_d = @(t) 0.05*[-1,0,0,0,0,0].';%目標値
%x_d = @(t) 0.05/2*[2*sin(n*t-n+pi/2), sqrt(3)*cos(n*t-n+pi/2), cos(n*t-n+pi/2), 2*n*cos(n*t-n+pi/2), -sqrt(3)*n*sin(n*t-n+pi/2), -n*sin(n*t-n+pi/2)].';
x_d = @(t) 0.05/2*[2*sin(n*(t-1)), sqrt(3)*cos(n*(t-1)), cos(n*(t-1)), 2*n*cos(n*(t-1)), -sqrt(3)*n*sin(n*(t-1)), -n*sin(n*(t-1))].';
v_d = @(t) 0.05/2*[2*n*cos(n*(t-1)), -sqrt(3)*n*sin(n*(t-1)), -n*sin(n*(t-1)), -2*n^2*sin(n*(t-1)), -sqrt(3)*n^2*cos(n*(t-1)), -n^2*cos(n*(t-1))].';


u_d = @(t) B_sharp*(v_d(t) - A_d*x_d(t));
x_tilda = @(i) X(i, :).' - x_d(i*T); %x_tildaを0に収束させる
u_tilda2 = @(i) (X(i, :).'); 
%u_tilda = @(i) -K*(X(i, :).' - x_d(i)); 

%if abs(u(1))>10^-5 
%    u_tilda(i) = u_tilda(i)*10^-5/abs(u(1));
%end


u_data = zeros(N,1);
norm_data = zeros(N,1);
x_tilda_data = zeros(N,1);

fun = @(i) B_d*(-K*(X(i, :).' - x_d(i*T))) + x_d((i+1)*T);

tic
i = 0;
j =0;
while i < N %時刻i*T
    i = i + 1;
    %X(i+1, :) = A_d*x_tilda(i) + B_d*u_tilda(i) + x_d((i+1)*T);
    %u = (X(i, :).' - x_d(i*T)) + x_d((i+1)*T);
    %if abs(uuu(1))>10^-5
    %end
    u_d = B_sharp*(v_d(i*T) - A_d*x_d(i*T));
    u_tilda = -K*(X(i, :).' - x_d(i*T));
    u = u_tilda + u_d;
    if norm(u)>10^-5
        disp(i)
        u = u*10^-5/norm(u);
        u_tilda = u - u_d;
        disp(norm(u))

    end
    %disp(u)

    %if u(1)>10^-5
    x_tilda_data(i) = norm(X(i, :).' - x_d(i*T));

    X(i+1, :) = A_d*(X(i, :).' - x_d(i*T)) + B_d*u_tilda + x_d((i+1)*T);%やっとうまくいった．関数ハンドルいみわからん

end
toc

figure
plot((1:N)/60, x_tilda_data)


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

x0 = X(1,1);
y0 = X(1,2);
z0 = X(1,3);
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
set(gca,'YDir','reverse')
set(gca,'ZDir','reverse')
zlabel('Z')
%quiver3(X,Y,Z,B_x,B_y,B_z, 1/(20 * norm([B_x B_y B_z])))

plot3(X(:,1), X(:,2), X(:,3),'c')