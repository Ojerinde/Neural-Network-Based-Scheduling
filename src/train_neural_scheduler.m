function channelGains = simulate_channel(numUsers, numTimeSlots)
    % Simulates Rayleigh fading channels for multiple users over time slots
    % Inputs:
    %   numUsers - Number of users in the network
    %   numTimeSlots - Number of time slots for simulation
    % Outputs:
    %   channelGains - Matrix of channel gains (numUsers x numTimeSlots)
    
    rng(42); % Set random seed for reproducibility
    channelGains = zeros(numUsers, numTimeSlots);
    for t = 1:numTimeSlots
        channelGains(:, t) = abs((randn(numUsers, 1) + 1i*randn(numUsers, 1))/sqrt(2)).^2;
    end
end