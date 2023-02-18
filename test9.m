%3次元空間内を点が動き回って，その軌跡も表示する動画を保存
%chatGPTで生成

% サンプリング周波数
Fs = 30; 

% 時間軸
t = 0:1/Fs:2*pi; %2*pi秒のシミュレーション．それをサンプリング周波数で割っている．

% 半径
r = 1; 

% 初期位相
phase = pi/2; 

% 上下振動の周波数
freq = 1; 

% 上下振動の振幅
amplitude = 0.5; 

% 上下振動の式
y = amplitude*sin(2*pi*freq*t + phase); 

% 円周上のx座標
x = r*cos(t); 

% 円周上のy座標
y = y + r*sin(t); 

% ファイル名に含める日時のフォーマットを指定
dateformat = 'yyyy-MM-dd-HH-mm-ss';

% 日時をファイル名に追加
filename = sprintf('circle_motion_with_trajectory_%s.avi', datetime('now','Format', dateformat));



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
for i = 1:length(t)
    % 軌跡を描画
    plot3(x(1:i),y(1:i),zeros(i),'LineWidth',1,'Color',[0.7 0.7 0.7]);
    hold on;
    % 円を描画
    plot3(x(i),y(i),0,'o','MarkerSize',10,'MarkerFaceColor','r');
    axis equal;
    axis([-1.5 1.5 -2 2]);
    grid on
    xlabel('Position (cm)');
    ylabel('Position (cm)');
    zlabel('Position (cm)');
    title('Circle Motion with Trajectory');
    legend('Circle');
    drawnow;
    frame = getframe(gcf);
    writeVideo(vidObj,frame);
    hold off;
end

% 動画を閉じる
close(vidObj);