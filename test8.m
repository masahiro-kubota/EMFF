%地球の磁場を計測する
alfa = deg2rad(288.38);
delta = deg2rad(79.30);
d = [cos(alfa)*cos(delta), sin(alfa)*cos(delta), sin(delta)];%磁極の向き
M = 7.789*10^15;
R = 6371*10^3;
delta_T = deg2rad(36);
r = [R*cos(delta_T), 0, R*sin(delta_T)];
n_r = norm(r);

B = M/n_r^3*(3*dot(d, r/norm(r))*r/norm(r)-d);