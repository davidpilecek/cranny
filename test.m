tmp = load(base + "step2_sledge_cm.mat");
ys = tmp.ans;          % original object

A = ys.Data;           % extract data

% --- your modifications ---
c = 0.39369;
A(29,:) = A(28,:) + c;
A(30,:) = A(29,:) + c;
A(31,:) = A(30,:) + c;
A(32,:) = A(31,:) + c;
A(33,:) = A(32,:) + c;
A(34,:) = A(33,:) + c;

c = 0.4478;
A(61,:) = A(60,:) + c;
A(62,:) = A(61,:) + c;
A(63,:) = A(62,:) + c;
A(64,:) = A(63,:) + c;
A(65,:) = A(64,:) + c;
% --------------------------

ys.Data = A;           % put modified data back

ans = ys;

save(base + "step2_sledge_cm_modified.mat", "ans");