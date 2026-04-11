# Hermes Agent on AWS with Bedrock

> Deploy [Hermes Agent](https://github.com/NousResearch/hermes-agent) on AWS using Amazon Bedrock and native AWS services. One-click CloudFormation deployment — no API keys, no manual setup.

English | [简体中文](README_CN.md)

---

## What is Hermes Agent?

[Hermes Agent](https://github.com/NousResearch/hermes-agent) is the self-improving AI agent built by [Nous Research](https://nousresearch.com). It's the only agent with a built-in learning loop — it creates skills from experience, improves them during use, and builds a deepening model of who you are across sessions. 19K+ GitHub stars, 242 contributors, MIT licensed.

### Hermes Agent vs OpenClaw

Both are open-source AI agents. Here's how they compare:

| | OpenClaw | Hermes Agent |
|---|---------|--------------|
| Language | TypeScript / Node.js | Python |
| Learning | No built-in learning | **Self-improving skills + persistent memory** |
| Install | `npm install -g` | `pip install` or one-line installer |
| Messaging | WhatsApp, Telegram, Discord, Slack | WhatsApp, Telegram, Discord, Slack, **Feishu, Signal, Matrix, Mattermost** |
| Terminal | Docker sandbox | **6 backends: local, Docker, SSH, Modal, Daytona, Singularity** |
| Models | OpenRouter, Anthropic, Bedrock | OpenRouter, Anthropic, Bedrock, **20+ providers** |
| Cron | No | **Built-in scheduler with platform delivery** |
| Delegation | No | **Parallel subagent spawning** |
| Research | No | **RL training environments (Atropos)** |

This project deploys Hermes Agent on AWS with **native Amazon Bedrock integration** — the same approach we built for [OpenClaw on AWS](https://github.com/JiaDe-Wu/clawdbot-aws-bedrock), now adapted for Hermes.

---

## Quick Start

### ⚡ One-Click Deploy (Recommended — ~8 minutes)

**Prerequisites:**
- An AWS account
- An EC2 key pair in your target region ([create one here](https://console.aws.amazon.com/ec2/home#KeyPairs:))
- Bedrock model access enabled ([enable here](https://console.aws.amazon.com/bedrock/home#/modelaccess))

**3 steps:**
1. ✅ Click **"Launch Stack"** below
2. ✅ Select your EC2 key pair → click **Create Stack**
3. ✅ Wait ~8 minutes → check **Outputs** tab → connect and chat

| Region | Launch Stack |
|--------|-------------|
| **US East (Ohio)** | [![Launch Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=us-east-2#/stacks/create/review?stackName=hermes-bedrock&templateURL=https://hermes-agent-templates.s3.amazonaws.com/hermes-bedrock.yaml) |
| **US East (N. Virginia)** | [![Launch Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?stackName=hermes-bedrock&templateURL=https://hermes-agent-templates.s3.amazonaws.com/hermes-bedrock.yaml) |
| **US West (Oregon)** | [![Launch Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=us-west-2#/stacks/create/review?stackName=hermes-bedrock&templateURL=https://hermes-agent-templates.s3.amazonaws.com/hermes-bedrock.yaml) |
| **EU (Ireland)** | [![Launch Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks/create/review?stackName=hermes-bedrock&templateURL=https://hermes-agent-templates.s3.amazonaws.com/hermes-bedrock.yaml) |
| **Asia Pacific (Tokyo)** | [![Launch Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=ap-northeast-1#/stacks/create/review?stackName=hermes-bedrock&templateURL=https://hermes-agent-templates.s3.amazonaws.com/hermes-bedrock.yaml) |

> **Note:** Uses cross-region inference profiles — deploy in any region, requests auto-route to optimal locations.

**What happens automatically:**
- Creates VPC, subnets, security groups
- Launches EC2 instance (Ubuntu 24.04)
- Installs Python 3.12, Hermes Agent, boto3
- Configures Bedrock as the default provider
- Sets up IAM role for Bedrock access
- Signals CloudFormation when ready

### CLI Deploy (Alternative)

```bash
git clone https://github.com/JiaDe-Wu/hermes-agent-on-aws.git
cd hermes-agent-on-aws
./deploy.sh hermes-bedrock us-east-2 your-keypair
```

---

## Connect to Your Instance

After deployment, go to the **CloudFormation Outputs** tab. You have two options:

### Option A: EC2 Console (Easiest — no setup required)

1. Go to [EC2 Console](https://console.aws.amazon.com/ec2/home#Instances:)
2. Find the instance named `hermes-bedrock-instance`
3. Right-click → **Connect**
4. Choose **Session Manager** tab → click **Connect**
5. In the terminal that opens:

```bash
sudo su - ubuntu
hermes chat
```

### Option B: SSM from Your Terminal

If you have the [SSM Session Manager Plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html) installed:

```bash
# Copy this from CloudFormation Outputs → Step2ConnectSSM
aws ssm start-session --target i-0xxxxxxxxxxxx --region us-east-2

# Then:
sudo su - ubuntu
hermes chat
```

### Option C: SSH (if you enabled it)

If you set `AllowedSSHCIDR` to your IP during deployment:

```bash
ssh -i your-key.pem ubuntu@<public-ip>
hermes chat
```

---

## Using Hermes Agent

### Interactive Chat

```bash
hermes chat
```

Type your message and press Enter. Hermes responds with streaming output. Use tools, write code, read files — all through natural conversation.

### Useful Commands

| Command | What it does |
|---------|-------------|
| `hermes chat` | Start interactive conversation |
| `hermes chat -q "question"` | Single question, get answer, exit |
| `hermes model` | Switch Bedrock models |
| `hermes doctor` | Check Bedrock access and configuration |
| `hermes gateway setup` | Connect Telegram / Discord / Slack / Feishu |
| `hermes gateway start` | Start the messaging gateway |

### In-Session Commands

| Command | What it does |
|---------|-------------|
| `/model us.amazon.nova-pro-v1:0` | Switch model mid-conversation |
| `/usage` | Show token count and cost |
| `/new` | Start fresh conversation |
| `/compress` | Compress context when it gets long |
| `Ctrl+C` | Interrupt current generation |
| `/exit` | Exit |

### Connect Messaging Platforms

Hermes supports Telegram, Discord, Slack, Feishu, WhatsApp, Signal, and more:

```bash
hermes gateway setup    # Interactive setup wizard
hermes gateway start    # Start the gateway service
```

---

## Available Bedrock Models

| Model | ID | Best For |
|-------|-----|---------|
| **Claude Sonnet 4.6** (default) | `us.anthropic.claude-sonnet-4-6` | General purpose, coding, reasoning |
| **Claude Opus 4.6** | `us.anthropic.claude-opus-4-6-v1` | Most capable, complex tasks |
| **Claude Haiku 4.5** | `us.anthropic.claude-haiku-4-5-20251001-v1:0` | Fast and cheap |
| **Amazon Nova Pro** | `us.amazon.nova-pro-v1:0` | AWS-native, balanced |
| **Amazon Nova Micro** | `us.amazon.nova-micro-v1:0` | Fastest, cheapest |
| **DeepSeek V3.2** | `deepseek.v3.2` | Strong open model |
| **Llama 4 Scout 17B** | `us.meta.llama4-scout-17b-instruct-v1:0` | Meta's latest |
| **Llama 4 Maverick 17B** | `us.meta.llama4-maverick-17b-instruct-v1:0` | Meta's creative model |

Switch models anytime:
```bash
hermes model                              # Interactive picker
hermes chat --model deepseek.v3.2         # Use specific model
```

---

## Architecture

```
You → Telegram/Discord/Slack/Feishu → EC2 (Hermes Agent) → Bedrock (Claude/Nova/...)
                                            ↓
                                      Your AWS Account
                                      (Private, Audited, Compliant)
```

| Component | Purpose |
|-----------|---------|
| EC2 (t3.medium) | Runs Hermes Agent + gateway |
| IAM Role | Authenticates with Bedrock — no API keys |
| SSM Session Manager | Secure access — no open ports |
| VPC Endpoints (optional) | Private network to Bedrock |
| CloudTrail | Automatic audit logs |

## Cost

| Component | Monthly |
|-----------|---------|
| EC2 (t3.medium) | ~$30 |
| EBS (30GB gp3) | ~$2.40 |
| VPC Endpoints (optional) | ~$22 |
| Bedrock usage | Pay-per-use |
| **Total infrastructure** | **~$33-65** |

Bedrock example: 100 conversations/day with Claude Sonnet 4.6 ≈ $10-15/month.

## Cleanup

```bash
aws cloudformation delete-stack --stack-name hermes-bedrock --region us-east-2
```

Or delete from the [CloudFormation Console](https://console.aws.amazon.com/cloudformation/).

---

## About the Bedrock Integration

This deployment uses our **native Bedrock Converse API integration** for Hermes Agent ([PR #7920](https://github.com/NousResearch/hermes-agent/pull/7920)), not the OpenAI-compatible endpoint. This gives you:

### What We Built

- **Native Converse API adapter** (`agent/bedrock_adapter.py`) — full message/tool format conversion, streaming with real-time delta callbacks, interrupt support
- **AWS credential chain** — IAM roles, SSO profiles, env vars, EC2 instance metadata (IMDS) — zero API key management
- **Dynamic model discovery** — auto-discovers foundation models + cross-region inference profiles via `ListFoundationModels` + `ListInferenceProfiles`
- **Guardrails support** — optional Bedrock Guardrails for content filtering, configured via `config.yaml`
- **Error classification** — Bedrock-specific patterns for `ThrottlingException`, `ModelNotReadyException`, context overflow — proper retry/backoff behavior
- **Context length awareness** — static table for all Bedrock models so compression triggers at the right threshold
- **Usage pricing** — accurate cost tracking for Claude, Nova, and other Bedrock models via `/usage`
- **`hermes doctor`** — Bedrock diagnostics (credential detection, API health check, model count)
- **`hermes auth`** — displays AWS IAM identity and region
- **`/model` live switch** — switch between Bedrock models mid-conversation with validation via model discovery

### Implementation Reference

Our Bedrock adapter follows the same architecture as [OpenClaw's `extensions/amazon-bedrock/`](https://github.com/openclaw/openclaw/tree/main/extensions/amazon-bedrock) plugin:
- Converse API (not InvokeModel) for unified model interface
- `auth: "aws-sdk"` credential chain (same as OpenClaw's `resolveAwsSdkEnvVarName`)
- Inference profile support (cross-region `us.*` and `global.*` prefixes)
- Guardrail config injection into Converse API calls

The IMDS credential detection addresses the same class of issue as [OpenClaw PR #62673](https://github.com/openclaw/openclaw/pull/62673) — cloud environments provide credentials via instance metadata, not environment variables.

### Testing

- **107 automated tests** — unit tests (adapter, conversion, streaming, discovery, errors) + integration tests (registry, aliases, runtime, providers, packaging)
- **EC2 end-to-end** — 4 models verified (Claude Sonnet 4.6, Nova Pro, DeepSeek V3.2, Llama 4 Scout)
- **CloudFormation end-to-end** — full stack deploy → SSM connect → `hermes chat` → multi-model conversation
- **Gateway verified** — Feishu (Lark) messaging platform tested with Bedrock provider

### Version Pinning

This deployment currently installs from our fork branch:

```
git+https://github.com/JiaDe-Wu/hermes-agent.git@feat/native-aws-bedrock-provider
```

This is pinned to the version tested on **April 11, 2026** with all 107 tests passing. Once [PR #7920](https://github.com/NousResearch/hermes-agent/pull/7920) is merged upstream, we will update the `HermesInstallSource` parameter to use the official PyPI release (`hermes-agent`). You can also change this parameter yourself in the CloudFormation console to switch sources at any time.

---

## Security

- 🔐 **No API keys** — IAM role authentication via instance metadata
- 🔒 **No open ports** — SSM Session Manager (SSH optional, disabled by default)
- 🛡️ **Private network** — VPC Endpoints keep Bedrock traffic off the internet (optional)
- 📊 **Audit trail** — CloudTrail logs every Bedrock API call
- 🏢 **Isolated** — Dedicated VPC, security groups, least-privilege IAM

## Contributing

Contributions welcome! Please fork and submit a pull request.

## License

This deployment template is MIT licensed. Hermes Agent is [MIT licensed](https://github.com/NousResearch/hermes-agent/blob/main/LICENSE).

---

**Built for AWS customers who want a self-improving AI agent on infrastructure they control.**
