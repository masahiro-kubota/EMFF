function d_F = Ampere(I, phi, B)
% Calculate the ampere force applied to the current I flowing in angle phi
d_I = I * [-cos(phi), sin(phi), 0];
d_F = cross(d_I, B);
end