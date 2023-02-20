%所望の力から電流に変える．

a = 0.015;
x_j = [0, 0, 0];
x_k = [0.1, 0, 0];

E_j = [0, 0, 0];
E_k = [0, 0, 0];

q_j = quaternion(E_j,'euler','XYZ','point');
q_k = quaternion(E_k,'euler','XYZ','point');
split = 10;


i_max = 1;
i_j = x_k*i_max/max(x_k);
disp("I_j is ")
disp(i_j)
F = [1, 2, 4]*10^-6;

i_k = force2current(F, a, i_max, i_j, x_j, x_k, q_j, q_k);

disp('I_lk is ')
disp(i_k.')


[F, T] = plot_magnetic_field_FT2(q_j, q_k, x_k, i_j, i_k, 10, 10);
disp("F(plot_magnetic_field_FT2) is ")
disp(F)


I_j1 = zeros(1,3);
I_j2 = zeros(1,3);
I_j3 = zeros(1,3);

for j = 1:3
    I_j1 =  I_j1 + i_j(j)*calculateI(x_j, x_k, q_j, q_k, split, a, j, 1);
    I_j2 =  I_j2 + i_j(j)*calculateI(x_j, x_k, q_j, q_k, split, a, j, 2);
    %disp(I_j2)
    I_j3 =  I_j3 + i_j(j)*calculateI(x_j, x_k, q_j, q_k, split, a, j, 3);
    %disp(I_j3)
end

S = N*[I_j1.', I_j2.', I_j3.'];

F = myu0/(4*pi)*N*(S*i_k);
disp("F is ")
disp(F)
