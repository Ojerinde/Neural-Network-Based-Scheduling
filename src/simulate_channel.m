function channelGains = simulate_channel(numUsers, numTimeSlots)
%SIMULATE_CHANNEL Simulate Rayleigh fading channels for multiple users over time.
%   channelGains = SIMULATE_CHANNEL(numUsers, numTimeSlots) returns a
%   numUsers-by-numTimeSlots matrix of instantaneous channel power gains.
%
%   Does NOT set the random seed here. An earlier version called rng(42)
%   on every invocation, which meant calling this function twice (e.g.
%   once for evaluation data, once for training data elsewhere) reset the
%   random stream back to the same starting point both times -- the first
%   min(numTimeSlots) columns of any two calls would be identical, an
%   unintended overlap between what should be independent samples. Set
%   the seed once, in the top-level script (main.m), instead.
    channelGains = zeros(numUsers, numTimeSlots);
    for t = 1:numTimeSlots
        channelGains(:, t) = abs((randn(numUsers, 1) + 1i*randn(numUsers, 1))/sqrt(2)).^2;
    end
end
