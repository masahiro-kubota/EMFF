%トルクがほぼ0になる値をプロット
i = 0;
data_T0 = [];
while i < ite1*ite2*ite3
    i = i + 1;
    if data(i, 11) < 10^(-9)
        disp(i)
        disp(data(i, 11))
        disp(data(i, 1:3))
        data_T0 = [data_T0; [data(i, 4:9)]];

    end
end

scatter3(data_T0(:, 1), data_T0(:, 2), data_T0(:, 3), 'filled')