%電流要素分割数を変更して力とトルクの精度を確かめる．

i_max = 16;
i = 1;
data = zeros(i_max, 8);
while i < i_max
    i = i + 1;
    disp(i)
    splitB = i;
    splitA = i;
    [F, T] = plot_magnetic_field_FT2(pi/3, pi/4, 0.1, splitB, splitA);
    data(i,:) = [splitB, splitA, F, T];
end

%data = [data; [100, 100, ％F, T]];