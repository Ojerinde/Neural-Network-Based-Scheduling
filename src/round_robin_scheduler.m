function [rrSchedule, rrThroughput, rrEnergy] = round_robin_scheduler(channelGains, bandwidth, txPower, noisePower)
    % Implements Round-Robin scheduler
    % Inputs:
    %   channelGains - Matrix of channel gains (numUsers x numTimeSlots)
    %   bandwidth - System bandwidth (Hz)
    %   txPower - Transmit power (Watts)
    %   noisePower - Noise power (Watts)
    % Outputs:
    %   rrSchedule - User schedule (1 x numTimeSlots)
    %   rrThroughput - Throughput per time slot (bps)
    %   rrEnergy - Energy consumption per time slot (Watts)
    
    numUsers = size(channelGains, 1);
    numTimeSlots = size(channelGains, 2);
    rrSchedule = mod((0:numTimeSlots-1), numUsers) + 1;
    rrThroughput = zeros(1, numTimeSlots);
    rrEnergy = zeros(1, numTimeSlots);
    
    for t = 1:numTimeSlots
        user = rrSchedule(t);
        snr = channelGains(user, t) * txPower / noisePower;
        rrThroughput(t) = bandwidth * log2(1 + snr);
        rrEnergy(t) = txPower;
    end
end