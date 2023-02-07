%磁気モーメント近似と近似なしコイルによる磁場の比較


a = 0.015;
p = 0;
q = 0;
l = 0;
N = 1;
I_z = 1;
split = 10;

x = 0.1;
y = 0;
z = 0;

n = [0, 0, 1];
i = 0;
i_max = 100;
data = zeros(i_max, 1);
B_coil_z = magnetic_flux_z2(x, y, z, I_z, a, N, p, q, l, split);
B_dipole = magnetic_flux_dipole(x, y, z, I_z, a, N, n) ;

disp(B_coil_z)
disp(B_dipole)

ratio = abs(norm(B_coil_z)-norm(B_dipole))/norm(B_coil_z);
disp(ratio)


%{
while i < i_max
    i = i + 1;
    x = x + 0.1;
    B_coil_z = magnetic_flux_z2(x, y, z, I_z, a, N, p, q, l, split);
    B_dipole = magnetic_flux_dipole(x, y, z, I_z, a, N, n) ;
    data(i) = (norm(B_coil_z)-norm(B_dipole))/norm(B_coil_z);
end
%}


plot(data)
legend
