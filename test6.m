
%片方固定してもう片方を3次元的に回転
%磁場を発生させるコイル
%l1 = 0;

%力を受けるコイル
p2 = 0;
q2 = 0;
l2 = 0;
x = 0.1;

%[F, T] = plot_magnetic_field_FT(l1, l2, x);

i = 0;
ite1 = 50;
ite2 = 50;
ite3 = 50;
data = zeros(ite1*ite2*ite3, 11);
while i < ite1
    i = i + 1;
    p2 = p2 + 2*pi/ite1;
    j = 0;
    q2 = 0;
    %disp(i)
    while j < ite2
        j = j + 1;
        q2 = q2 + 2*pi/ite2;
        k = 0;
        l2 = 0;
        while k < ite3
            k = k + 1;
            l2 = l2 + 2*pi/ite3;
            [F, T] = plot_magnetic_field_FT2(p2, q2, l2, x, 6, 6);
            disp((i - 1)*ite2*ite3 + (j - 1)*ite3 + k)
            data((i - 1)*ite2*ite3 + (j - 1)*ite3 + k,:) = [p2 q2 l2 F(1) F(2) F(3) T(1) T(2) T(3), norm(F), norm(T)]; 
    
            disp([i, j])
            disp([p2, q2])
            disp([F, T])
        end
        

    end
end

figure
plot(data(:,11))