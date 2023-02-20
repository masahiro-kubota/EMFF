function [h1, h2, h3, h4] = satellite_movie(i, X, x_d_data, u_data, quat2, a)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
 % 軌跡を描画
h1 = plot3(X(1:i,1),X(1:i,2),X(1:i,3),'LineWidth',1,'Color',[0.7 0.7 0.7]);
hold on;

%コイルを描画
draw_coil([X(i,1:3)], quat2, a)

%目標ポイントを描画
h2 = plot3(x_d_data(i,1),x_d_data(i,2),x_d_data(i,3),'o','MarkerSize',5,'MarkerFaceColor','r');

%目標軌道を描画
h3 = plot3(x_d_data(:,1), x_d_data(:,2), x_d_data(:,3), 'r');

%発生する力の向きを描画
h4 = quiver3(X(i,1),X(i,2),X(i,3),u_data(i,1)*10^4,u_data(i,2)*10^4,u_data(i,3)*10^4);
end