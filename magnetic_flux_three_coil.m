function B = magnetic_flux_three_coil(x, y, z, I_x, I_y, I_z, a, N, p, q, l, split)
%半径a，巻き数Nの3つのコイルにI_x，I_y，I_zの電流が流れたときに（x, y, z）に発生する磁場
%   Detailed explanation goes here

%split = 32;

B = magnetic_flux_x2(x, y, z, I_x, a, N, p, q, l, split) + magnetic_flux_y2(x, y, z, I_y, a, N, p, q, l, split) + magnetic_flux_z2(x, y, z, I_z, a, N, p, q, l, split);
%B = magnetic_flux_x2(x, y, z, I_x, a, N, p, q, l) ;
end