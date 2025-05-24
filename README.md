# 🔗 GCN-Accel: Open-Source RTL Graph Convolution Accelerator

**GCN-Accel** is an open-source SystemVerilog-based RTL implementation of a Graph Convolutional Network (GCN) accelerator. It is designed for efficient processing of sparse graphs and neural network operations, making it suitable for custom ASIC or FPGA deployments in AI, edge computing, and research domains.

## 📄 Description

This project offers a modular, synthesizable RTL design for accelerating GCN inference, with memory hierarchy support, FSM-based control logic, and simulation testbenches. It reads sparse matrix data (in COO format), performs feature transformations and matrix multiplications, and outputs transformed feature representations. Ideal for learning, prototyping, or deploying hardware-based GCNs.

---

## 📂 File Structure

| File                             | Description                                                                 |
|----------------------------------|-----------------------------------------------------------------------------|
| `Argmax.sv`                      | Computes index of max value in a vector.                                   |
| `Combination.sv`                 | Handles vector combinations or accumulations.                              |
| `Combination_FSM.sv`            | FSM for controlling the combination logic.                                 |
| `Counter.sv`                     | Basic counter utility module.                                              |
| `GCN.sv`                         | Top-level module implementing GCN logic.                                   |
| `GCN_TB.sv`                      | Functional testbench for `GCN.sv`.                                         |
| `GCN_TB_post_syn_apr.sv`         | Timing-aware testbench for post-synthesis/APR flows.                       |
| `Matrix_FM_WM_ADJ_Memory.sv`    | Memory for feature, weight, and adjacency matrices.                        |
| `Matrix_FM_WM_Memory.sv`         | Combined memory for feature and weight data.                               |
| `matrix_mul.sv`                  | Matrix multiplication core logic.                                          |
| `Register.sv`                    | Generic register module.                                                   |
| `Scratch_Pad.sv`                 | Temporary memory storage unit.                                             |
| `Transformation.sv`             | Applies transformation to input features.                                  |
| `Transformation_FSM.sv`         | FSM that sequences transformations.                                        |
| `Transfroamtion_Multiplication.sv` | Handles multiplication in transformation stage.                        |
| `Transfromation_TB.sv`          | Testbench for transformation logic.                                        |
| `coo_data.txt`                  | Input COO-format adjacency data.                                           |
| `feature_data.txt`              | Input node feature data.                                                   |
| `fm_wm.txt`                     | Merged feature and weight matrix data.                                     |
| `gold_address.txt`              | Golden reference for address verification.                                 |
| `weight_data.txt`               | Weight matrix for graph layers.                                            |

---

## 🚀 Features

- GCN hardware accelerator in synthesizable SystemVerilog
- Modular FSM-based design
- Supports COO-format sparse matrices
- Integrated memory blocks for FM/WM/Adj
- Testbenches for functional and post-layout simulation
- Ideal for FPGA/ASIC deployment

---

## 🛠️ Simulation

Use a simulator like VCS, ModelSim, or Xcelium:
`cd simulation`
`make sim_rtl`
