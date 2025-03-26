function bits_dec = soft_new(y,x_soft,idx_enc,idx_mod)

% Initialization of vectors
y = y.';
expected_symbs = mapper(x_soft,idx_mod);

% Get bits per symbol
switch idx_mod
    case 0  % BPSK
        bits_per_symbol = 1;
    case 1  % QPSK
        bits_per_symbol = 2;
    case 2  % AMPM
        bits_per_symbol = 3;
end

% R: information bit/coding bit
if idx_enc == 1 || idx_enc == 2 || idx_enc == 3
    R = 0.5;
elseif idx_enc == 4
    R = 2/3;
end
    
% Calculate number of encoded bits and steps
factor = bits_per_symbol * R;
num_steps = length(y) * factor;


% Initialization
% 1. path_metrics:  Minimum metric value for storage paths
%                   column - time steps
%                   row - states (2 ^ register_num)
% 2. path_idx:      In each iteration, the minimum path index of each state is found by the min() function and stored in path.
% 3. compare_path:  Save the cumulative metric values ​​of all possible paths from each state to the next time step for path selection.
%                   row - states;
%                   column - possible path from current state to next state,
%                            which is equal to 2

if idx_enc == 1
    % state_num = 2^(num of register) = 4
    path_metrics = Inf(4,num_steps);
    path_idx = Inf(4, num_steps);
    % initial state = 00
    path_idx(1,1) = 0;
    % possible next state : 00 or 10, which is (1,1) and (3,1)
    compare_path = Inf(4, 2);
    compare_path(1, 1) = 0;
    compare_path(3, 1) = 0;
elseif idx_enc == 2 || idx_enc == 3
    % state_num = 2^(num of register) = 16
    path_metrics = Inf(16,num_steps);
    path_idx = Inf(16, num_steps);
    % initial state = 00
    path_idx(1,1) = 0;
    compare_path = Inf(16, 2);
    compare_path(1, 1) = 0;
    compare_path(9, 1) = 0;
elseif idx_enc == 4
    % state_num = 2^(num of register) = 8
    path_metrics = Inf(8,num_steps);
    path_idx = Inf(8, num_steps);
    % initial state = 00
    path_idx(1,1) = 0;
    % 4 possible next states
    compare_path = Inf(8, 4);
    compare_path(1, 1) = 0;
    compare_path(2, 1) = 0;
    compare_path(3, 1) = 0;
    compare_path(4, 1) = 0;
end



% Calculate the euclidean distance.
% [path_metrics]    Collect the minimum metric
% [path_idx]        Record the index
% [compare_path]    Record Euclidean distance to all possible path and
%                   reshape to fit trellis for next step

if (idx_enc == 1 || idx_enc == 2 || idx_enc == 3) && idx_mod == 1 
    for t=1:num_steps
        euclidean_dist = abs(repmat(y(t,:),length(expected_symbs(1,:)),1) - expected_symbs.').^2;
        euclidean_dist_mat = reshape(euclidean_dist,2,[])';     % divide by 2 columns
        compare_path = compare_path + euclidean_dist_mat;
        [path_idx,path_metrics(:,t)] = min(compare_path,[],2);
        compare_path = reshape([path_idx' path_idx'],2,[])';
    end
elseif idx_enc == 3 && idx_mod == 0
    y = reshape(y,2,[]).';
    expected_symbs = reshape(expected_symbs,2,[]);
    for t=1:num_steps
        euclidean_dist = sum(abs(repmat(y(t,:),length(expected_symbs(1,:)),1) - expected_symbs.'),2).^2;
        euclidean_dist_mat = reshape(euclidean_dist,2,[])';
        compare_path = compare_path + euclidean_dist_mat;
        [path_idx,path_metrics(:,t)] = min(compare_path,[],2);
        compare_path = reshape([path_idx' path_idx'],2,[])';
    end 
elseif idx_enc == 4
    num_steps = num_steps/2;
     for t=1:num_steps
        euclidean_dist = abs( repmat(y(t,:),length(expected_symbs(1,:)),1) - expected_symbs.').^2;
        euclidean_dist_mat = reshape(euclidean_dist,8,[]);
        compare_path = compare_path + euclidean_dist_mat;
        [path_idx,path_metrics(:,t)] = min(compare_path,[],2);
        path_idx =  repmat(path_idx,1,4);
        compare_path = reshape([path_idx(1,:) path_idx(2,:) path_idx(3,:) path_idx(4,:) path_idx(5,:) path_idx(6,:) path_idx(7,:) path_idx(8,:)],8,[]);
     end
end

% Functions to find the minimum path depending on encoder 1,2,3 and 4.
if idx_enc == 1
    bits_dec = traceback1(path_metrics,compare_path,num_steps);
elseif idx_enc == 2 || idx_enc == 3 
    bits_dec = traceback2(path_metrics,compare_path,num_steps);
elseif idx_enc == 4
    bits_dec = traceback3(path_metrics,compare_path,num_steps);
end

end