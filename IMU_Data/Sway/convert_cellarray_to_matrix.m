function a = convert_cellarray_to_matrix(A)
rows = numel(A);
columns = length(str2num(A{1}));
a = NaN(rows,columns);

for j = 1:rows
    for i = 1:columns
        a1 = str2num(A{j});
        a(j,i) = a1(i);
    end
end