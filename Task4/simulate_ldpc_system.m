function BER = simulate_ldpc_system(N, EbN0)
    % Parameters
    maxNumErrs = 100;
    maxNum = 1e6;
    BER = zeros(1, length(EbN0));
    
    % Create LDPC encoder and decoder
    rate = 1/2;
    H = dvbs2ldpc(rate, 'sparse');
    [numParityBits, n] = size(H);
    k = n - numParityBits;
    fprintf('Code parameters: n=%d, k=%d, rate=%.3f\n', n, k, k/n);
    
    % Create encoder and decoder
    hEnc = comm.LDPCEncoder(H);
    hDec = comm.LDPCDecoder(H, 'MaximumIterationCount', 25);
    
    % Create modulator and demodulator
    qpskMod = comm.QPSKModulator('BitInput', true);
    qpskDemod = comm.QPSKDemodulator('BitOutput', true, ...
        'DecisionMethod', 'Log-likelihood ratio');
    
    % Use smaller block size
    numBlocks = ceil(maxNum/k);
    blockSize = k;
    
    for i = 1:length(EbN0)
        
        current_ebn0 = EbN0(i);
        
        totErr = 0;
        num = 0;
        
        while((totErr < maxNumErrs) && (num < maxNum))
            % Generate one block of data
            data = randi([0 1], blockSize, 1);
            
            % LDPC encoding
            encoded = hEnc(data);
            
            % QPSK modulation
            modulated = qpskMod(encoded);
            
            % Add noise
            EsN0 = current_ebn0 + 10*log10(2*rate);
            snr = EsN0 - 0.5;
            received = awgn(modulated, snr, 'measured');
            
            % Demodulation
            demodulated = qpskDemod(received);
            
            % LDPC decoding
            decoded = hDec(demodulated);
            
            % Count errors
            bitErr = sum(decoded(1:k) ~= data);
            totErr = totErr + bitErr;
            num = num + k;
            
            % Print progress for every 10 blocks
            if mod(num, 10*k) == 0 && totErr > 0
                fprintf('  Progress: Eb/N0 = %.2f dB, Bits = %d, Errors = %d, BER = %.2e\n', ...
                    current_ebn0, num, totErr, totErr/num);
            end
        end
        
        BER(i) = totErr/num;
        if BER(i) == 0
            BER(i) = 1e-6;  
        end
        fprintf('Complete: Eb/N0 = %.2f dB, BER = %.2e\n', current_ebn0, BER(i));
    end
end