%磁気モーメント近似と近似なしコイルによる磁場の比較


a = 0.015;
quat1 = quaternion([0, 0, 0],'euler','XYZ','point');
quat2 = quaternion([0, 0, 0],'euler','XYZ','point');
N = 17;

split = 10;

x = 0.09;
y = 0;
z = 0;

n = [0, 0, 1];
i = 0;
i_max = 100;

delta = 0.001;
t = x:delta:x+delta*99;
data = zeros(i_max, 1);
data_coil = zeros(i_max, 1);
data_dipole = zeros(i_max, 1);

%{
B_coil_z = magnetic_flux_z2(x, y, z, I_z, a, N, quat1, split);
B_dipole = magnetic_flux_dipole(x, y, z, I_z, a, N, n) ;

disp(B_coil_z)
disp(B_dipole)

ratio = abs(norm(B_coil_z)-norm(B_dipole))/norm(B_coil_z);
disp(ratio)
%}

r = [x y z];
S = pi * a^2;
I1 = [0 0 1];
I2 = [0 0 1];
myu1 = N * I1 * S;
myu2 = N * I2 * S;

while i < i_max
    i = i + 1;
    x = x + delta;
    r = [x y z];
    B_coil_z = magnetic_flux_z2(x, y, z, I_z, a, N, quat1, split);
    B_dipole = magnetic_flux_dipole(x, y, z, I_z, a, N, n) ;
    [F_coil, ~] = plot_magnetic_field_FT2(quat1, quat2, r, I1, I2, 10, 10);
    [F_dipole, ~] = dipole2em_force_torque(myu1, myu2, r);
    disp(F_coil)
    disp(F_dipole)
    data(i) = (norm(F_coil)-norm(F_dipole))/norm(F_coil);
    data_coil(i) = norm(F_coil);
    data_dipole(i) = norm(F_dipole);
end


h1 = plot(t,data_coil);
hold on
h2 = plot(t,data_dipole);
xlabel('X(m)（距離）');
ylabel('F(N)（電磁力）');
title('コイルを磁気双極子に近似した場合としない場合')
legend([h1,h2], '磁気双極子近似なし', '磁気双極子近似あり');
legend
