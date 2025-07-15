# AI-Driven Scheduler for 6G Multi-User Wireless Networks

## 🔍 Overview

This project implements an **AI-based dynamic scheduler** for a simulated 6G wireless network. It compares a **Feedforward Neural Network (FNN)** with a traditional **Round-Robin (RR)** scheduler under **Rayleigh fading** conditions, evaluating **throughput** and **energy usage**.

## 🚀 Key Features

- Models dynamic wireless channels with **Rayleigh fading**.
- Uses a **feedforward neural network** to optimize scheduling.
- Compares with **Round-Robin** baseline.
- Achieves **9.37% throughput improvement** and **86.2% lower throughput variance**.
- Visualizes throughput and energy trade-offs.

## 🧠 Motivation

6G demands **ultra-reliable, low-latency communication (URLLC)**. Static schedulers like Round-Robin fail to adapt to dynamic channels. This project leverages machine learning to optimize resource allocation in **multi-user**, **time-varying** environments.

## 📊 Results

- **Neural Scheduler**: ~2.80 Gbps avg. throughput, 3,659.09 Mbps² variance.
- **Round-Robin**: ~2.56 Gbps avg. throughput, 26,514.98 Mbps² variance.
- **Gain**: 9.37% higher throughput, 86.2% lower variance.
- **Scalability**: NN’s low variance and adaptive scheduling suit massive access scenarios (e.g., 100+ users).

## 🧰 Tools Used

- **MATLAB** (Deep Learning Toolbox).
- Signal processing and communication system modeling.

## 📂 Files

- `script.m`: Main simulation code.
- `training-progress.png`: Neural network training curve.
- `throughput-comparison.png`: Throughput comparison plot.

## 📚 Academic Relevance

Aligns with research in:

- **AI-enabled wireless communication** (Zhang et al., _IEEE Access_, 2020).
- **6G resource allocation** (Saad et al., _IEEE Network_, 2020).
- **Intelligent systems for 6G** (Björnson et al., _IEEE Communications Magazine_, 2023).

## 🔮 Future Work

- Federated learning for privacy-preserving scheduling.
- Integration with MIMO and beamforming.
- Multi-objective optimization (latency vs. energy).

## 📜 Reference

See the [presentation](link-to-presentation) for a detailed executive summary and an inspiring science quote.

_Created: July 2025_
