function visualize_results(rrThroughput, nnThroughput, rrEnergy, nnEnergy, numTimeSlots)
    % Visualizes throughput and energy comparison
    % Inputs:
    %   rrThroughput - Round-Robin throughput (bps)
    %   nnThroughput - Neural network throughput (bps)
    %   rrEnergy - Round-Robin energy (Watts)
    %   nnEnergy - Neural network energy (Watts)
    %   numTimeSlots - Number of time slots
    
    figure;
    subplot(2,1,1);
    plot(1:numTimeSlots, rrThroughput/1e6, 'b-', 'DisplayName', 'Round-Robin');
    hold on;
    plot(1:numTimeSlots, nnThroughput/1e6, 'r-', 'DisplayName', 'Neural Network');
    xlabel('Time Slot'); ylabel('Throughput (Mbps)');
    title('Throughput Comparison'); legend; grid on;
    
    subplot(2,1,2);
    plot(1:numTimeSlots, rrEnergy*1000, 'b-', 'DisplayName', 'Round-Robin');
    hold on;
    plot(1:numTimeSlots, nnEnergy*1000, 'r-', 'DisplayName', 'Neural Network');
    xlabel('Time Slot'); ylabel('Energy (mW)');
    title('Energy Comparison'); legend; grid on;
    
    saveas(gcf, 'figures/throughput-comparison.png');
end