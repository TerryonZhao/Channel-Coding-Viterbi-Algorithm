function y_bar = demapper(y, idx_mod)
BPSK = [-1 1];
QPSK = [(1 + 1i) (1 - 1i) (-1 +1i) (-1 - 1i)]/sqrt(2);
AMPM = [(1 + -1i) (-3 + 3i) (1 +  3i) (-3 - 1i) (3 - 3i) (-1 + 1i) (+3 + 1i) (-1 - 3i)]/sqrt(10);

switch idx_mod
    case 0
        y_mat = repmat(y, 2, 1);
        const_mat = repmat(transpose(BPSK), 1, length(y));
        distance = abs(const_mat - y_mat);
        [~, symb_idx] = min(distance);
        y_bar = de2bi((symb_idx-1)', 'left-msb');
        y_bar = reshape(y_bar',1,length(y));

    case 1
        y_mat = repmat(y, 4, 1);
        const_mat = repmat(transpose(QPSK), 1, length(y));
        distance = abs(const_mat - y_mat);
        [~, symb_idx] = min(distance);
        y_bar = de2bi((symb_idx-1)', 'left-msb');
        y_bar = reshape(y_bar',1,2*length(y));

    case 2
        y_mat = repmat(y, 8, 1);
        const_mat = repmat(transpose(AMPM), 1, length(y));
        distance = abs(const_mat - y_mat);
        [~, symb_idx] = min(distance);
        y_bar = de2bi((symb_idx-1)', 'left-msb');
        y_bar = reshape(y_bar',1,3*length(y));


end
end