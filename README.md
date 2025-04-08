# VM Health Monitor

A shell script monitoring solution that checks the health status of Ubuntu virtual machines based on CPU, memory, and disk space utilization.

## Features

- Real-time monitoring of system resources:
  - CPU usage
  - Memory utilization
  - Disk space usage
- Configurable threshold (currently set at 60%)
- Detailed explanation mode with comprehensive system metrics

## Prerequisites

- Ubuntu-based system
- `bc` package for calculations
- Basic shell utilities (`top`, `free`, `df`)

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd vm-health-monitor
```

2. Make the shell script executable:
```bash
chmod +x check_health.sh
```

## Usage

Basic health check:
```bash
./check_health.sh
```

Detailed explanation:
```bash
./check_health.sh explain
```

## How It Works

The script monitors three key system metrics:

1. **CPU Usage**: Measures the current CPU utilization percentage
2. **Memory Usage**: Calculates the percentage of used RAM
3. **Disk Usage**: Monitors the usage percentage for all mounted disk partitions

### Health Status Determination

- If all metrics are below 60% utilization: Status = HEALTHY
- If any metric reaches or exceeds 60% utilization: Status = NOT HEALTHY

### Explanation Mode

When run with the "explain" argument, the script provides:
- Detailed metrics for all monitored resources
- Specific issues if the system is unhealthy
- Current usage percentages for all components

## Output Examples

### Basic Check
```
VM Health Status: HEALTHY
```

### With Explanation (Healthy System)
```
VM Health Status: HEALTHY

All systems are running within normal parameters:
- CPU usage: 25.5%
- Memory usage: 45.2%
- Disk usage:
  /: 35%
  /home: 28%
```

### With Explanation (Unhealthy System)
```
VM Health Status: NOT HEALTHY

Issues found:
- CPU usage is high at 75.5%
- Memory usage is high at 82.3%
```

## Implementation Details

The shell script (`check_health.sh`):
- Uses native Linux commands (`top`, `free`, `df`) for resource monitoring
- Implements a threshold checking function for consistent evaluation
- Processes command line arguments for different execution modes
- Provides formatted, easy-to-read output
- Uses `bc` for precise floating-point calculations
- Handles multiple disk partitions automatically

## Contributing

Feel free to submit issues and enhancement requests!

## License

[MIT License](LICENSE)