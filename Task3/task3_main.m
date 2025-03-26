% Simulation Options
N = 1e5;
EbN0 = -1:8;
maxNumErrs = 100; % get at least 100 bit errors (more is better)
maxNum = 1e6; % OR stop if maxNum bits have been simulated

% pre-allocate a vector for BER results
BER_S1 = zeros(1, length(EbN0));
BER_S2 = zeros(1, length(EbN0));
BER_S3 = zeros(1, length(EbN0));


idx_mod = 1;    %0: BPSK; 1: QPSK; 2: AMPM
idx_rec = 2;    %0: uncoded; 1: hard; 2: soft

for i = 1:length(EbN0) 
  idx_enc = 3;  
  idx_mod = 0;
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
      bits_dec = hard_decoder(y_bar, trellis);
  elseif idx_rec == 2
      bits_dec = soft_new(y_bar, x_soft, idx_enc, idx_mod);
  end

  bitErr = sum(bits_dec ~= bits);
  totErr = totErr + bitErr;
  num = num + N;

  end

  BER_S1(i) = totErr/num;

end

for i = 1:length(EbN0) 
  idx_enc = 3;  
  idx_mod = 1;
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
      bits_dec = hard_decoder(y_bar, trellis);
  elseif idx_rec == 2
      bits_dec = soft_new(y_bar, x_soft, idx_enc, idx_mod);
  end

  bitErr = sum(bits_dec ~= bits);
  totErr = totErr + bitErr;
  num = num + N;

  end

  BER_S2(i) = totErr/num;

end

for i = 1:length(EbN0) 
  idx_enc = 4;  
  idx_mod = 2;
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
      bits_dec = hard_decoder(y_bar, trellis);
  elseif idx_rec == 2
      bits_dec = soft_new(y_bar, x_soft, idx_enc, idx_mod);
  end

  bitErr = sum(bits_dec ~= bits);
  totErr = totErr + bitErr;
  num = num + N;

  end

  BER_S3(i) = totErr/num;

end

% Figure
figure;
BPSK_uncoded = get_uncoded_BER(N, EbN0, 0);
QPSK_uncoded = get_uncoded_BER(N, EbN0, 1);
AMPM_uncoded = get_uncoded_BER(N, EbN0, 2);

% Figure
semilogy(EbN0, BPSK_uncoded, '--', 'DisplayName', 'System 1 - Uncoded', 'Color', [0, 0.447, 0.741] );
hold on;
semilogy(EbN0, BER_S1, '-s', 'DisplayName', 'System 1 - Coded', 'Color', [0.301, 0.745, 0.933]);
hold on;
semilogy(EbN0, QPSK_uncoded, '--', 'DisplayName', 'System 2 - Uncoded', 'Color', [0.850, 0.325, 0.098] );
hold on;
semilogy(EbN0, BER_S2, '-s', 'DisplayName', 'System 2 - Coded', 'Color', [0.635, 0.078, 0.184]);
hold on;
semilogy(EbN0, AMPM_uncoded, '--', 'DisplayName', 'System 3 - Uncoded', 'Color', [0.929, 0.694, 0.125] );
hold on;
semilogy(EbN0, BER_S3, '-s', 'DisplayName', 'System 3 - Coded', 'Color', [0.996, 0.835, 0.0]);

xlabel('EbN0 [dB])');
ylabel('BER');
title('BER versus Eb/N0');
grid on;
legend('show');
ylim([1e-4 1]);

% BER_S1
% BER_S2
% BER_S3
% 
% BPSK_uncoded
% QPSK_uncoded
% AMPM_uncoded