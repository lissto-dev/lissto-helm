# Lissto Helm Chart

A comprehensive Helm chart for deploying Lissto - a Kubernetes stack management platform that simplifies deploying and managing Docker Compose-based applications on Kubernetes.

## Overview

This Helm chart installs and manages the following Lissto components:

- **Controller (Operator)**: Kubernetes operator that manages Lissto custom resources
- **API Server**: REST API for managing stacks, blueprints, and environments
- **Slack Bot**: Integration for managing Lissto resources via Slack
- **Configuration**: ConfigMap for shared configuration across components
- **Custom Resource Definitions (CRDs)**: Blueprint, Env, Stack, and StackLifecycle resources

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+

## Quick Start

```bash
# Install the chart
helm install lissto . --namespace lissto-system --create-namespace
```

## Contributing

Contributions are welcome! Please see the main Lissto repository for contribution guidelines.

## License

See the LICENSE file in the main Lissto repository.

## Support

- GitHub Issues: https://github.com/lissto-dev/lissto/issues
- Documentation: https://github.com/lissto-dev/lissto

