function bits_dec = hard_decoder(hard_bits, trellis)
    % Get trellis parameters
    num_states = trellis.num_states;
    num_inputs = trellis.num_inputs;
    n = trellis.n;
    num_steps = length(hard_bits) / n;

    if mod(length(hard_bits), n) ~= 0
        error('The length of hard_bits must be an integer multiple of n.');
    end
    
    % Initialize path metrics matrix and state recording matrices
    path_metrics = inf(num_states, num_steps + 1);
    path_metrics(1, 1) = 0;
    
    % Record the optimal predecessor state and input bit for each state at each time step
    predecessor_states = zeros(num_states, num_steps, 'uint16');
    input_bits = zeros(num_states, num_steps, 'uint8');
    
    % === Forward Phase ===
    for t = 1:num_steps
        received_bits = hard_bits((t-1)*n+1 : t*n);
        
        % Find the optimal predecessor state and input for each current state
        for s_next = 0:num_states-1
            min_metric = inf;
            best_prev_state = 0;
            best_input = 0;
            
            % Check all possible predecessor states and inputs
            for s_prev = 0:num_states-1
                for u = 0:num_inputs-1
                    if trellis.next_state(s_prev+1, u+1) == s_next
                        output_bits = squeeze(trellis.outputs(s_prev+1, u+1, :))';
                        branch_metric = sum(output_bits ~= received_bits);
                        total_metric = path_metrics(s_prev+1, t) + branch_metric;
                        
                        if total_metric < min_metric
                            min_metric = total_metric;
                            best_prev_state = s_prev;
                            best_input = u;
                        end
                    end
                end
            end
            
            % Update optimal path information
            path_metrics(s_next+1, t+1) = min_metric;
            predecessor_states(s_next+1, t) = best_prev_state;
            input_bits(s_next+1, t) = best_input;
        end
    end
    
    % === Traceback Phase ===
    [~, current_state] = min(path_metrics(:, end));
    current_state = current_state - 1;
    
    bits_dec = zeros(1, num_steps);
    for t = num_steps:-1:1
        bits_dec(t) = input_bits(current_state+1, t);
        current_state = predecessor_states(current_state+1, t);
    end
end