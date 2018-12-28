function A=Scale_down_to_unit(A)
% A=A';
% A=A-min(min(A));
A=A./max(max(abs(A)));
% A=A';