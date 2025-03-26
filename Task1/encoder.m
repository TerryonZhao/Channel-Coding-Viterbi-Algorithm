function [bits_enc,x_soft] = encoder(bits, idx_enc)
%ENCODER Encodes input bits using specified convolutional encoder
%
% bits_enc = encoder(bits, idx_enc)
%
% bits:    Input bit vector to be encoded
% idx_enc: Encoder selection
%          0 - Uncoded (no encoding)
%          1 - E1: Rate-1/2, G = (1 + D^2, 1 + D + D^2)
%          2 - E2: Rate-1/2, G = (1 + D^2 + D^3 + D^4, 1 + D^2 + D^3)
%          3 - E3: Rate-1/2, G = (1 + D^3 + D^4, 1 + D + D^3 + D^4)
%          4 - E4: Rate-2/3 convolutional encoder
%
% bits_enc: Encoded output bit vector

switch idx_enc
    case 0
        % Uncoded
        bits_enc = bits;
    case 1
        bits_conv = [bits];
        % E1: Rate-1/2 convolutional encoder
        % Generator polynomials: G = (1 + D^2, 1 + D + D^2)
        d1 = [1 0 1]; % Coefficients for D^0, D^1, D^2
        d2 = [1 1 1];
        c1 = mod(conv(bits_conv,d1),2);
        c2 = mod(conv(bits_conv,d2),2);
        b = length(d1)-1;
        c1 = c1(1:end-b);
        c2 = c2(1:end-b);
        bits_enc = [c1;c2];
        bits_enc = reshape(bits_enc,1,[]);

        x_soft = [0 0 1 1 0 1 1 0 1 1 0 0 1 0 0 1];
        
    case 2
        bits_conv = [bits];
        % E2: Rate-1/2 convolutional encoder
        % Generator polynomials: G = (1 + D^2 + D^3 + D^4, 1 + D^2 + D^3)
        d1 = [1 0 1 1 1]; % Coefficients for D^0 to D^4
        d2 = [1 0 1 1 0];
        c1 = mod(conv(bits_conv,d1),2);
        c2 = mod(conv(bits_conv,d2),2);
        b = length(d1)-1;
        c1 = c1(1:end-b);
        c2 = c2(1:end-b);
        bits_enc = [c1;c2];
        bits_enc = reshape(bits_enc,1,[]);

        x_soft = [0 0 1 0 1 1 0 1 1 1 0 1 0 0 1 0 0 0 1 0 1 1 0 1 1 1 0 1 0 0 1 0 1 1 0 1 0 0 1 0 0 0 1 0 1 1 0 1 1 1 0 1 0 0 1 0 0 0 1 0 1 1 0 1];
        
    case 3
        bits_conv = [bits];
        % E3: Rate-1/2 convolutional encoder
        % Generator polynomials: G = (1 + D^3 + D^4, 1 + D + D^3 + D^4)
        d1 = [1 0 0 1 1]; % Coefficients for D^0 to D^4
        d2 = [1 1 0 1 1];
        c1 = mod(conv(bits_conv,d1),2);
        c2 = mod(conv(bits_conv,d2),2);
        b = length(d1)-1;
        c1 = c1(1:end-b);
        c2 = c2(1:end-b);
        bits_enc = [c1;c2];
        bits_enc = reshape(bits_enc,1,[]);

        x_soft = [0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 0 0 1 1 0 1 0 0 1 0 1 1 0 1 0 0 1 1 1 0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 0 0 1 0 1 1 0 1 0 0 1 0 1 1 0];
        
    case 4
        d = [0 0 0];
        c2 = bits(1:2:end); 
        c3 = bits(2:2:end);
        c1 = zeros(length(bits)/2,1);

        % Loop thorugh the different states and calculates codeword c1

        for i=1:length(bits)/2
            c1(i) = d(3);
            d(3) = bitxor(d(2),bits(2*i-1));
            d(2) = bitxor(d(1),bits(2*i));
            d(1) = c1(i);
        end

        % calculate codeword c2, c3 and finalize the encoding from encoder 4     

        bits_enc = zeros(1,length(c1)+length(c2)+length(c3));
        bits_enc(1:3:end) = c1;
        bits_enc(2:3:end) = c2;
        bits_enc(3:3:end) = c3;
        bits_enc = bits_enc(:); 

        
        % N = length(bits)/2;  % Number of input pairs
        % bits_enc = zeros(1, 3*N);  % Output will be 3 times longer than N
        % 
        % % Initialize shift registers for u1 and u2 (we need 3 delays maximum)
        % sr_u1 = [0 0 0];  % For D³
        % sr_u2 = [0 0 0];  % For D³
        % 
        % % Process input bits in pairs
        % for i = 1:N
        %     % Get current input pair
        %     u1 = bits(2*i-1);  % First bit of pair
        %     u2 = bits(2*i);    % Second bit of pair
        % 
        %     % Calculate outputs
        %     % c₁ = u₁D³ + u₂D
        %     c1 = mod(sr_u1(3) + sr_u2(1), 2);
        % 
        %     % c₂ = u₁(1+D³) = u₁ + u₁D³
        %     c2 = mod(u1 + sr_u1(3), 2);
        % 
        %     % c₃ = u₂(1+D³) = u₂ + u₂D³
        %     c3 = mod(u2 + sr_u2(3), 2);
        % 
        %     % Store outputs
        %     bits_enc(3*i-2:3*i) = [c1 c2 c3];
        % 
        %     % Update shift registers
        %     sr_u1 = [u1, sr_u1(1:2)];    % Shift and insert u1
        %     sr_u2 = [u2, sr_u2(1:2)];    % Shift and insert u2
        % 
        % end
        % bits_enc = bits_enc';

        


        x_soft =  [0 0 0 0 1 0 0 0 1 0 1 1 1 0 0 1 1 0 1 0 1 1 1 1 0 1 0 0 0 0 0 1 1 0 0 1 1 1 0 1 0 0 1 1 1 1 0 1 0 0 1 0 1 1 0 0 0 0 1 0 1 0 1 1 1 1 1 0 0 1 1 0 0 1 1 0 0 1 0 1 0 0 0 0 1 1 1 1 0 1 1 1 0 1 0 0];
            

        end

        
 
end