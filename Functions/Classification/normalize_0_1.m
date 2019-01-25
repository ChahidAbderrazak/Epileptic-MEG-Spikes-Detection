function A=normalize_0_1(A)
A=A';
A=A-min(A);
A=A./max(A);
A=A';
