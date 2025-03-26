function y = awgn(symb, EbN0, idx_enc, idx_mod)
    % Adds AWGN noise to a signal based on the Eb/N0 value
    % symb: Input signal vector of transmitted symbols
    % EbN0: Energy per bit to noise power spectral density ratio in dB
    % idx_enc: 0 - uncoded; 1,2,3 - 1/2 covnolutional code; 4 - 2/3 convolutional code
    % idx_mod: 0 - BPSK; 1 - QPSK; 2 - AMPM

    % Convert Eb/N0 from dB to linear scale
    EbN0_lin = 10^(EbN0/10);

    % i: coding bits/symb
    if idx_mod == 0 % BPSK
        i = 1;
    elseif idx_mod == 1 % QPSK
        i = 2;
    elseif idx_mod == 2 % APAM
        i = 3;
    else
        warning('Wrong idx_mod')
    end

    % R: information bit/coding bit
    if idx_enc == 0 % uncode
        R = 1;
    elseif idx_enc == 1 || idx_enc == 2 || idx_enc == 3
        R = 0.5;
    elseif idx_enc == 4
        R = 2/3;
    else
        warning('Wrong idx_enc')
    end

    % k: information bits/symb
    % Es = k*Eb
    k = i * R;

    % Assuming unit energy symbols, calculate the noise variance
    % For BPSK with unit energy symbols, E_s = E_b since 1 bit per symbol
    % For other modulations adjust E_s = k * E_b where k is bits per symbol
    Es = mean(abs(symb).^2);
    EsN0 = k * EbN0_lin;
    N0 = Es/EsN0;

    % Noise variance calculation
    noise_variance = 0.5 * N0;

    % Generate complex Gaussian noise
    noise = sqrt(noise_variance) * (randn(1,length(symb)) + 1i*randn(1,length(symb)));

    % Add noise to the symbols
    y = symb + noise;
end
