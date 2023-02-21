%レコード盤軌道再現
%オイラー近似で離散化．後々，CW解によって求まるものを使えるようにしておきたい．


%衛星姿勢
p1 = 0;
q1 = 0;
l1 = 0;
p2 = 0;
q2 = 0;
l2 = 0;
quat2 = quaternion([p2, q2, l2],'euler','XYZ','point');

%コイル半径(m)
a = 0.015;

%衛星質量(kg)
m = 1;

%重力定数
myu = 3.986*10^14;

%地球半径
earth_radius = 6378.140*10^3;

%高度
altitude = 500*10^3;

%地心からの距離
r_star = earth_radius + altitude;

%地球を周回する衛星の角速度
n = sqrt(myu/r_star^3);

%軌道周期
%disp(2*pi/(n*60)) 

%サンプリングタイム
T = 1;

%シミュレーション時間
N = 60*90;

%Hill方程式によって作られるオイラー近似離散状態方程式の係数
A = [0, 0, 0, 1, 0, 0;
     0, 0, 0, 0, 1, 0;
     0, 0, 0, 0, 0, 1;
     0, 0, 0, 0, 0, 2*n;
     0, -n^2, 0, 0, 0, 0;
     0, 0, 3*n^2, -2*n, 0, 0];

%Hill方程式によって作られるオイラー近似離散状態方程式の係数
B = [0, 0, 0;
     0, 0, 0;
     0, 0, 0;
     1/m, 0, 0;
     0, 1/m, 0;
     0, 0, 1/m];

%係数を計算するための基本的な計算
c = cos(n*T);
tau = n*T;
s = sin(n*T);

%{
%微分方程式の解を利用した差分方程式の係数
A_d = [1, 0, 6*(tau-s), (4*s-3*tau)/n, 0, 2*(1-c)/n;
       0, c, 0, 0, s/n, 0;
       0, 0, 4-3*c, 2*(c-1)/n, 0, s/n;
       0, 0, 6*n*(1-c), 4*c-3, 0, 2*s;
       0, -n*s, 0, 0, c, 0;
       0, 0, 3*n*s, -2*s, 0, c];

%B_dの近似が怪しいため要検証
B_d = [(4*s-3*tau)/n, 0, 2*(1-c)/n;
       0, s/n, 0;
       2*(c-1)/n, 0, s/n;
       4*c-3, 0, 2*s;
       0, c, 0;
       -2*s, 0, c];%差分方程式の係数
%}

%オイラー近似を利用した差分方程式の係数
A_d = eye(6) + T*A;

%オイラー近似を利用した差分方程式の係数
B_d = T*B;

%重み行列
%Q = diag([1, 1, 1, 0, 0, 0]);
%R = diag([10^3, 10^3, 10^3]);  とても収束性が良い．その代わり振動する．

%Q = diag([1, 1, 100, 0, 0, 0]);
%R = diag([10^7, 10^3, 10^7]);  エネルギーが少なくて済む=振動が少ない
%この値はランデブの軌道制御における予見ファジィ制御と最適制御の比較から持ってきてる．

Q = diag([1, 1, 1, 0, 0, 0]);
R = diag([10^3, 10^3, 10^3]);

%リッカチ方程式を解いて最適ゲインを求める
[~,K,~] = icare(A,B,Q,R,[],[],[]);

%状態配列
X = zeros(N, 6);

%初期状態量代入
X(1,:) = 0.05/2*[1, 0, 0, 0, 0, 0];

%最初からレコード盤に乗っている初期状態量
%X(1,:) = 0.05/2*[0, sqrt(3), 1, 2*n, 0, 0];

%ランデブーを想定した目標値
%x_d = @(t) 0.05*[-1,0,0,0,0,0].';

%各時間での状態量目標値
x_d = @(t) 0.05/2*[2*sin(n*(t-1)), sqrt(3)*cos(n*(t-1)), cos(n*(t-1)), 2*n*cos(n*(t-1)), -sqrt(3)*n*sin(n*(t-1)), -n*sin(n*(t-1))].';
v_d = @(t) 0.05/2*[2*n*cos(n*(t-1)), -sqrt(3)*n*sin(n*(t-1)), -n*sin(n*(t-1)), -2*n^2*sin(n*(t-1)), -sqrt(3)*n^2*cos(n*(t-1)), -n^2*cos(n*(t-1))].';

%変位あり状態方程式の入力変位を設定するための係数
B_sharp = (B.'*B)\B.';

%グラフを作るためのデータ配列
u_data = zeros(N,3);
norm_data = zeros(N,1);
x_tilda_data = zeros(N,1);
x_d_data = zeros(N,3);


tic
i = 0;
j =0;
while i < N %時刻i*T
    i = i + 1;
    xd = x_d(i*T);

    %フィードバック系を0に収束させるために入力変位を設定
    u_d = B_sharp*(v_d(i*T) - A_d*xd);

    %目標値と現在地のずれ
    x_tilda = X(i, :).' - xd;

    %x_tildaを0にするためのフィードバック
    u_tilda = -K*x_tilda;

    %元の状態方程式の入力
    u = u_tilda + u_d;

    %所望の力が上限を超えた場合，方向そのままで大きさを小さくする．
    if norm(u)>10^-5
        u = u*10^-5/norm(u);
        u_tilda = u - u_d;
    end
    

    %離散状態方程式
    X(i+1, :) = A_d*X(i, :).' + B_d*u;

    %目標値までの距離を格納
    x_tilda_data(i) = norm(X(i, :).' - xd);

    %電磁力ベクトルを格納
    u_data(i,:) = u;

    %目標軌道
    x_d_data(i,:) =  xd(1:3,1).';

end
toc


%フレームレート
Fs = 30; 

%表示間引き数　（表示間引き数×フレームレート×サンプリングタイム）＝n倍速となる
Th = 10;

%各時刻での電磁力の大きさをグラフ化
figure
str = append('(', string(T*Fs*Th), ' times speed)');
plot((1:N)/60, u_data)
xlabel('時間（min）');
ylabel('力（N）');
title(append('電磁力',str));
legend('u');

%各時刻での位置変位をグラフ化
figure
plot((1:N)/60, x_tilda_data)
xlabel('時間（min）');
ylabel('位置変位（m）');
title(append('位置変位',str));
legend('x-tilda');


figure
t = linspace(0,2*pi,100);
axis_norm = 0.2;


%コイルを表示
draw_coil(X(1,1:3), quat2, a)

%原点を表示
plot3(0,0,0,'ro');

axis([-axis_norm,axis_norm,-axis_norm,axis_norm,-axis_norm,axis_norm])
axis square 
grid on
xlabel('X(m)')
ylabel('Y(m)')
set(gca,'YDir','reverse')
set(gca,'ZDir','reverse')
zlabel('Z(m)')
%quiver3(X,Y,Z,B_x,B_y,B_z, 1/(20 * norm([B_x B_y B_z])))

%軌跡を描画
plot3(X(:,1), X(:,2), X(:,3),'c')

%目標軌道を描画
%plot3(x_d_data(:,1), x_d_data(:,2), x_d_data(:,3), 'r')





% ファイル名に含める日時のフォーマットを指定
dateformat = 'yyyy-MM-dd-HH-mm-ss';

% 日時をファイル名に追加
filename = sprintf('movie/dynamics2record_%s.avi', datetime('now','Format', dateformat));





% 動画の準備
vidObj = VideoWriter(filename); % 動画ファイル名
vidObj.Quality = 100; % 画質
vidObj.FrameRate = Fs; % フレームレート
open(vidObj);

% グラフの見た目を設定
lw1 = 2; % 線幅1
lw2 = 1; % 線幅2
fs1 = 14; % フォントサイズ1
fs2 = 12; % フォントサイズ2
figcolor = [1 1 1]; % グラフの背景色


% 描画
figure('color',figcolor);
for i = 1:Th:N
    disp(i)
    
    %衛星の軌道，目標点，目標軌道，電磁力を図示
    [h1, h2, h3, h4] = satellite_movie(i, X, x_d_data, u_data, quat2, a);
    
    
    dim = [0.65 0.5 0.3 0.3];
    str = append('質量 ', string(m), 'kg ','衛星半径', string(a), 'm');
    annotation('textbox',dim,'String',str,'FitBoxToText','on')

    axis_norm = 0.2;
    axis([-axis_norm,axis_norm,-axis_norm,axis_norm,-axis_norm,axis_norm])
    axis square 
    grid on
    xlabel('X(m)（進行方向）');
    ylabel('Y(m)（面外方向）');
    zlabel('Z(m)（地心方向）');
    set(gca,'YDir','reverse')
    set(gca,'ZDir','reverse')
    str = append('(', string(T*Fs*Th), ' times speed)');
    title(append('Satellite Relative Motion with Trajectory ',str))
    legend([h1,h2,h3,h4], 'satellite trajectory in LVLH','target position', 'target orbit', 'electromagnetic force');
    dim = [.2 .7 .3 .3];
    drawnow;
    frame = getframe(gcf);
    writeVideo(vidObj,frame);
    hold off;
end

% 動画を閉じる
close(vidObj);


hold off