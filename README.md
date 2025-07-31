# Neural Network-Based Scheduling for 6G Multi-User Network

## Project Overview

This project presents a neural network-based scheduler for multi-user 6G networks. It simulates a realistic Rayleigh fading environment and compares the performance of a trained neural network scheduler against a standard Round-Robin baseline. Implemented in MATLAB, the system aims to optimize throughput and energy efficiency—key priorities for next-generation wireless communication.

## Research Context

With the anticipated demands of 6G systems—including dense user connectivity, high throughput, and energy efficiency—effective user scheduling is a core challenge. Traditional schedulers like Round-Robin do not account for fluctuating channel conditions, often leading to suboptimal performance. In contrast, machine learning-based schedulers can learn adaptive strategies from channel data, offering performance gains in dynamic environments.

## Features

- Neural network scheduler trained on channel gain data.
- Baseline Round-Robin scheduler for benchmarking.
- Rayleigh fading model for simulating realistic 6G conditions.
- Evaluation metrics: throughput, energy consumption, throughput gain, and variance.
- Visual comparison of scheduler performance over time.

## Technologies

- MATLAB R2020a or later
- MATLAB Neural Network Toolbox
- MATLAB plotting tools

## File Structure

```
6g-ai-scheduler/
├── main.m                  # Entry point for simulation and evaluation
├── simulate_channel.m      # Rayleigh channel generator
├── round_robin_scheduler.m # Traditional Round-Robin scheduling
├── evaluate_schedulers.m   # Applies both schedulers and collects metrics
├── visualize_results.m     # Plot generation
├── figures/                # Output plots (e.g., throughput-comparison.png)
├── README.md
```

## Setup Instructions

### Prerequisites

- MATLAB R2020a or later
- Neural Network Toolbox

### Installation

```bash
git clone https://github.com/your-username/6g-scheduler.git
cd 6g-scheduler
```

### Running the Simulation

1. Open MATLAB.
2. Navigate to the project directory.
3. Run:

```matlab
main
```

This will:

- Simulate Rayleigh fading channels
- Train the neural network scheduler
- Evaluate and compare both schedulers
- Generate plots in the `figures/` directory

## Methodology

### Channel Simulation

Rayleigh fading is used to model wireless multipath effects. The simulation generates a matrix of channel gains with:

- `numUsers = 10`
- `numTimeSlots = 100`

### Neural Scheduler Training

The network is trained using 1000 synthetic channel gain vectors to predict which user should be scheduled based on instantaneous channel conditions.

### Scheduler Comparison

- **Round-Robin**: Fixed user order, no awareness of channel state.
- **Neural Network**: Selects users based on predicted scores from trained model.

### Evaluation Metrics

- **Throughput (Gbps)**: Computed using Shannon capacity: `BW * log2(1 + SNR)`
- **Energy Consumption**: Fixed power model (0.1 W per transmission)
- **Throughput Gain**: Improvement of NN scheduler over RR baseline
- **Variance**: Measures stability of achieved throughput

## Results

Example output:

- **NN Throughput**: 1.82 Gbps
- **RR Throughput**: 1.45 Gbps
- **Throughput Gain**: 25.43%
- **Energy**: Equal for both (constant power)

Visualizations saved in:

- `figures/throughput-comparison.png`

## Future Work

- Replace neural network with LSTM to model time correlations in channel states.
- Implement adaptive power control to reduce energy usage.
- Extend simulation to mmWave and terahertz bands for 6G realism.
- Increase scalability to hundreds of users for macro simulations.

## References

[1] Z. Zhang et al., “6G wireless networks: Vision, requirements, architecture, and key technologies,” IEEE Veh. Technol. Mag., vol. 14, no. 3, 2019.

[2] T. Cover, J. Thomas, _Elements of Information Theory_, 2nd ed., Wiley, 2006.

[3] G. L. Stuber, _Principles of Mobile Communication_, 4th ed., Springer, 2017.

[4] H. Yang et al., “Deep learning-based resource allocation for 6G,” IEEE Netw., vol. 34, no. 5, 2020.

## License

This project is licensed under the MIT License.
