function [X1, x_tilda1_data, u1_data, x_d1_data] = feedback_system(x_d1, v_d1, T, N, x1_0, A_d, B_d, B, K, q1, q2, a, i_max)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here





%状態配列
X1 = zeros(N, 6);

%初期値代入
X1(1,:) = x1_0;

%変位あり状態方程式の入力変位を設定するための係数
B_sharp = (B.'*B)\B.';

%グラフを作るためのデータ配列
u1_data = zeros(N,3);
x_tilda1_data = zeros(N,1);
x_d1_data = zeros(N,3);


tic
for i = 1:N %時刻i*T
    disp(i)
    xd = x_d1(i*T);

    %フィードバック系を0に収束させるために入力変位を設定
    u_d = B_sharp*(v_d1(i*T) - A_d*xd);

    %目標値と現在地のずれ
    x_tilda = X1(i, :).' - xd;

    %x_tildaを0にするためのフィードバック
    u_tilda = -K*x_tilda;

    %元の状態方程式の入力(N)
    u1 = u_tilda + u_d;

    %所望の力が上限を超えた場合，方向そのままで大きさを小さくする．
    %if norm(u)>10^-5
    %    u = u*10^-5/norm(u);
    %end
    

    [u, ~] = force2current(u1.', a, i_max, X1(i, 1:3), -X1(i, 1:3), q1, q2);

    

    %離散状態方程式
    X1(i+1, :) = A_d*X1(i, :).' + B_d*u;

    %目標値までの距離を格納
    x_tilda1_data(i) = norm(X1(i, :).' - xd);
    disp(norm(X1(i, :).' - xd))

    %電磁力ベクトルを格納
    u1_data(i,:) = u;

    %目標軌道
    x_d1_data(i,:) =  xd(1:3,1).';
end