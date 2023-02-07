%電流要素分割数に対する計算精度の検証のためのグラフ

figure
title('電流要素分割数に対する力の精度')
plot(data(:,1), data(:,3))
hold on
grid on
xlabel('電流要素分割数')
ylabel('力')
plot(data(:,1), data(:,4))
plot(data(:,1), data(:,5))
hold off


figure 
title('電流要素分割数に対するトルクの精度')
plot(data(:,1), data(:,6))
hold on
grid on
xlabel('電流要素分割数')
ylabel('トルク')
plot(data(:,1), data(:,7))
plot(data(:,1), data(:,8))