function trellis = build_trellis(idx_enc)
    % Encoder parameters setup
    switch idx_enc
        case 0
        case 1 % E1: Rate 1/2, Memory 2
            k = 1; memory = 2; n = 2;
            % In octal: [5 7] = [101 111]
            % Actual polynomials: [1 0 1], [1 1 1]
            d1 = [1 0 1];
            d2 = [1 1 1];
            generators = {d1, d2};
        case 2 % E2: Rate 1/2, Memory 4
            k = 1; memory = 4; n = 2;
            % Actual polynomials: [1 0 1 1 1], [1 0 1 1 0]
            d1 = [1 0 1 1 1];
            d2 = [1 0 1 1 0];
            generators = {d1, d2};
        case 3 % E3: Rate 1/2, Memory 4
            k = 1; memory = 4; n = 2;
            % Actual polynomials: [1 0 0 1 1], [1 1 0 1 1]
            d1 = [1 0 0 1 1];
            d2 = [1 1 0 1 1];
            generators = {d1, d2};
    end

    % Calculate number of states and inputs
    num_states = 2^memory;
    num_inputs = 2^k;
    
    % Initialize tables
    next_state = zeros(num_states, num_inputs);
    outputs = zeros(num_states, num_inputs, n);
    
    % Build trellis
    for state = 0:num_states-1
        % Get current state bits (MSB to LSB)
        shift_register = bitget(state, memory:-1:1);
        
        for input = 0:num_inputs-1
            % Calculate next state
            new_register = [input, shift_register(1:end-1)];
            next_state(state+1, input+1) = bi2de(new_register, 'left-msb');
            
            % Calculate outputs using convolution polynomials
            reg_with_input = [input, shift_register];
            for i = 1:n
                gen = generators{i};
                outputs(state+1, input+1, i) = ...
                    mod(sum(reg_with_input .* gen(1:memory+1)), 2);
            end
        end
    end
    
    % Create trellis structure
    trellis.next_state = next_state;
    trellis.outputs = outputs;
    trellis.num_states = num_states;
    trellis.num_inputs = num_inputs;
    trellis.memory = memory;
    trellis.k = k;
    trellis.n = n;
end