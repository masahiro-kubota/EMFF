function r_jk = calculater_jk(x_j, x_k, q_j, q_k, theta, phi, a)
%コイルjの電流要素から見た，コイルkの電流要素の位置ベクトル
%   Detailed explanation goes here
%a = 0.015;
%x_j = [0.1, 0.1, 0.1];
%E_j = [pi/3,0,pi/4];
%q_j = quaternion(E_j,'euler','XYZ','point');
%theta = deg2rad(120);
%dl_j = rotatepoint(q_j, [-a*sin(theta), a*cos(theta), 0]);
x_jR = x_j + rotatepoint(q_j, [a*cos(theta), a*sin(theta), 0]);
%x_jR0 = x_j + rotatepoint(q_j, [a, 0, 0]);

%x_k = [-0.1, -0.1, -0.1];
%E_k = [-pi/3,0,-pi/4];
%q_k = quaternion(E_k,'euler','XYZ','point');
%phi = deg2rad(-120);
%dl_k = rotatepoint(q_k, [-a*sin(phi), a*cos(phi), 0]);
x_kR = x_k + rotatepoint(q_k, [a*cos(phi), a*sin(phi), 0]);
%x_kR0 = x_k + rotatepoint(q_k, [a, 0, 0]);

r_jk = x_kR - x_jR;
end