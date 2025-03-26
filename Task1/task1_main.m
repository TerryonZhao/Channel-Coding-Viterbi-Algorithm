N = 1e5;
EbN0 = -1:8;
maxNumErrs = 100; % get at least 100 bit errors (more is better)
maxNum = 1e6; % OR stop if maxNum bits have been simulated
  
BER_hard = zeros(1, length(EbN0));
BER_soft = zeros(1, length(EbN0));

idx_enc = 2;  
trellis2 = trellis_ub(idx_enc);    % E2 for distspec
spec2 = distspec(trellis2, 10);
ub2 = calculate_bound(spec2, EbN0);

idx_mod = 1;    %0: BPSK; 1: QPSK; 2: AMPM
trellis = build_trellis(idx_enc);

% Simulate Hard Decision Decoding
for i = 1:length(EbN0) 
  idx_rec = 1;
  totErr = 0; 
  num = 0;

  while((totErr < maxNumErrs) && (num < maxNum))
  
  bits = randsrc(1,N,[0 1]);
  [bits_enc, x_soft] = encoder(bits, idx_enc);
  symb = mapper(bits_enc, idx_mod);
  y = awgn(symb, EbN0(i), idx_enc, idx_mod);
  if idx_rec == 0 || idx_rec == 1
      y_bar = demapper(y, idx_mod);
  elseif idx_rec == 2
      y_bar = y;
  end

  if idx_rec == 0
      bits_dec = y_bar;
  elseif idx_rec == 1
      % Use vitdec instead of hard_decoder
      bits_dec = hard_decoder(y_bar, trellis);
  elseif idx_rec == 2
      bits_dec = soft_new(y_bar, x_soft, idx_enc, idx_mod);
  end

  bitErr = sum(bits_dec ~= bits);
  totErr = totErr + bitErr;
  num = num + N;

  end

  BER_hard(i) = totErr/num;

end

% Simulate Soft Decision Decoding
for i = 1:length(EbN0) 
  idx_rec = 2;
  totErr = 0; 
  num = 0;

  while((totErr < maxNumErrs) && (num < maxNum))
  
  bits = randsrc(1,N,[0 1]);
  [bits_enc, x_soft] = encoder(bits, idx_enc);
  symb = mapper(bits_enc, idx_mod);
  y = awgn(symb, EbN0(i), idx_enc, idx_mod);
  if idx_rec == 0 || idx_rec == 1
      y_bar = demapper(y, idx_mod);
  elseif idx_rec == 2
      y_bar = y;
  end

  if idx_rec == 0
      bits_dec = y_bar;
  elseif idx_rec == 1
      % Use vitdec instead of hard_decoder
      bits_dec = hard_decoder(y_bar, trellis);
  elseif idx_rec == 2
      bits_dec = soft_new(y_bar, x_soft, idx_enc, idx_mod);
  end

  bitErr = sum(bits_dec ~= bits);
  totErr = totErr + bitErr;
  num = num + N;

  end

  BER_soft(i) = totErr/num;

end

% Figure
figure;
uncoded_BER = get_uncoded_BER(N, EbN0, idx_mod);

semilogy(EbN0, ub2, '--', 'DisplayName', 'Upperbound');
hold on;
semilogy(EbN0, BER_soft, '-s', 'DisplayName', 'E2 - QPSK - Soft');
semilogy(EbN0, BER_hard, '-^', 'DisplayName', 'E2 - QPSK - Hard');
semilogy(EbN0, uncoded_BER, '-d', 'DisplayName', 'Uncoded');

xlabel('Eb/N0 [dB]');
ylabel('BER');
grid on;
legend('show');
ylim([1e-4 1]);

disp('Result:')
BER_soft
BER_hard
uncoded_BER