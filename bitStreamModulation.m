function y = bitStreamModulation(pulse, b, t, HS, K)
% function y = bitStreamModulation(pulse, b, t)
% Inputs:
%   pulse - pulse shape
%   b - bit stream
%   t - associated time vector
%   HS - 1 if using half sine
% Outputs:
%   y - Modulated signal
factor = b*2 - 1;
y = pulse*factor(1);
if HS == 1
    for i = 2:length(b)
        y = [y(1:end-1) factor(i)*pulse];
    end
else
    for i = 2:length(b)
        dummy = factor(i)*pulse;
%         y(end-(2*K-1):end) = y(end-(2*K-1):end)+dummy(1:2*K);
%         y = [y dummy(2*K+1:end)];
        %y = [y(1:end-2*K) y(end-(2*K-1):end)+dummy(1:2*K) dummy(2*K+1:end)];
        y = [y(1:end-(2*K-1)*32) y(end-(2*K-1)*32+1:end)+dummy(1:(2*K-1)*32) dummy((2*K-1)*32+1:end)];
    end
end

        
    