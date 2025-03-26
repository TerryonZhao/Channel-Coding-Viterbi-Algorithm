function BER = get_uncoded_BER(N, EbN0, idx_mod)

% Simulation Options
maxNumErrs = 100; % get at least 100 bit errors (more is better)
maxNum = 1e6; % OR stop if maxNum bits have been simulated
BER = zeros(1, length(EbN0)); % pre-allocate a vector for BER results

idx_enc = 0;    %0: uncoded;


for i = 1:length(EbN0) % use parfor ('help parfor') to parallelize  
  totErr = 0;  % Number of errors observed
  num = 0; % Number of bits processed

  while((totErr < maxNumErrs) && (num < maxNum))
% [SRC] generate N information bits 
  bits = randsrc(1,N,[0 1]);

  % [ENC] convolutional encoder
  bits_enc = encoder(bits, idx_enc);

  % [MOD] symbol mapper
  symb = mapper(bits_enc, idx_mod);
  %scatterplot(symb);

  % [CHA] add Gaussian noise
  y = awgn(symb, EbN0(i), idx_enc, idx_mod);
  %scatterplot(y);

  % Demapper(not used by soft receiver)
  y_demapper = demapper(y, idx_mod);

  if idx_mod == 2
      y_demapper = y_demapper(1:1e5);
  end

  bitErr = sum(y_demapper ~= bits);
  totErr = totErr + bitErr;
  num = num + N;

  end

  BER(i) = totErr/num;

end