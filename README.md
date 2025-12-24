# What is Lissto

Lissto is a DevEnv and DevEx(perience) platform that simplifies the development of applications on Kubernetes.
It bridges the gap between Docker Compose loved by developers and Kubernetes loved by DevOps and platform engineers.


## Lissto Helm Chart



Deploy the Lissto Platform on Kubernetes with ease.

### Quick Start

```bash
# Add the Helm repository
helm repo add lissto https://helm.lissto.dev/charts
helm repo update

# Install Lissto
helm install lissto lissto/lissto --namespace lissto-system --create-namespace
```

**Prerequisites:** Kubernetes 1.19+, Helm 3.0+

### What Gets Installed

- **Controller** - Manages your stacks and deployments
- **API Server** - REST API for stack management
- **Slack Bot** (optional) - Manage stacks from Slack
- **Custom Resources** - Blueprint, Env, Stack CRDs

## Installation Options

### With Custom Values

```bash
helm install lissto lissto/lissto \
  -f custom-values.yaml \
  --namespace lissto-system \
  --create-namespace
```

### Specific Version

```bash
helm install lissto lissto/lissto \
  --version 0.1.0 \
  --namespace lissto-system \
  --create-namespace
```

### Disable Slack Bot

```bash
helm install lissto lissto/lissto \
  --set bot.enabled=false \
  --namespace lissto-system \
  --create-namespace
```

## Common Configurations

### Enable API Ingress

```yaml
# custom-values.yaml
api:
  ingress:
    enabled: true
    className: nginx
    hosts:
      - host: lissto.example.com
        paths:
          - path: /
            pathType: Prefix
```

### Use Custom Image Registry

```yaml
global:
  imageRegistry: myregistry.io/lissto
```

### Configure Slack Bot

```yaml
bot:
  enabled: true
  slack:
    botToken: "xoxb-your-bot-token"
    appToken: "xapp-your-app-token"
    signingSecret: "your-signing-secret"
```

## Managing Your Installation

```bash
# Upgrade to latest version
helm repo update
helm upgrade lissto lissto/lissto --namespace lissto-system

# Upgrade with custom values
helm upgrade lissto lissto/lissto -f custom-values.yaml --namespace lissto-system

# Uninstall
helm uninstall lissto --namespace lissto-system

# Check status
kubectl get pods -n lissto-system

# View logs
kubectl logs -n lissto-system -l app.kubernetes.io/name=lissto-api -f

# List available versions
helm search repo lissto --versions
```

## Configuration Reference

See `values.yaml` for all available options including:
- Image versions and pull policies
- Resource limits and requests
- Service and ingress configuration
- Component toggles (enable/disable)
- Namespace configuration
- Repository and stack settings

## Development & Contributing

### Local Development

If you want to install from source for development:

```bash
git clone https://github.com/lissto-dev/lissto.git
cd lissto/lissto-helm

# Install locally
helm install lissto . --namespace lissto-system --create-namespace
```

See [QUICKSTART.md](./QUICKSTART.md) for development workflows and [RELEASE.md](./RELEASE.md) for release procedures.

## Support

- 🐛 Report Issues: https://github.com/lissto-dev/lissto/issues
- 📚 Documentation: https://github.com/lissto-dev/lissto
- 💬 Discussions: https://github.com/lissto-dev/lissto/discussions

