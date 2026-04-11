# Hermes Agent on AWS with Bedrock

> Deploy [Hermes Agent](https://github.com/NousResearch/hermes-agent) on AWS using Amazon Bedrock and native AWS services. One-click CloudFormation deployment — no API keys, no manual setup.

English | [简体中文](README_CN.md)

---

## ⚠️ Pending Upstream Merge

This project depends on our native Bedrock provider PR:

- **PR:** [NousResearch/hermes-agent#7920](https://github.com/NousResearch/hermes-agent/pull/7920) — `feat: native AWS Bedrock provider via Converse API`
- **Issue:** [NousResearch/hermes-agent#3863](https://github.com/NousResearch/hermes-agent/issues/3863) — `[Feature]: Native AWS Bedrock provider support`

Currently installs from our fork branch (`feat/native-aws-bedrock-provider`), pinned to the April 11, 2026 tested version. Once the PR is merged, we will switch to the official PyPI release.

---

## What is Hermes Agent?

[Hermes Agent](https://github.com/NousResearch/hermes-agent) is an open-source, self-improving AI agent built by [Nous Research](https://nousresearch.com). It creates skills from experience, improves them during use, and builds a persistent model of who you are across sessions. Python-based, MIT licensed.

This project is the **Hermes Agent** counterpart to our [OpenClaw on AWS with Bedrock](https://github.com/JiaDe-Wu/clawdbot-aws-bedrock) deployment (accepted into [aws-samples](https://github.com/aws-samples/sample-Moltbot-on-AWS-with-Bedrock)).

### Hermes Agent vs OpenClaw

| Dimension | OpenClaw | Hermes Agent | Edge |
|-----------|----------|-------------|------|
| GitHub Stars | 346K+ | 54K+ | OpenClaw |
| Contributors | 1200+ | 142+ | OpenClaw |
| Language | TypeScript / Node.js | Python | Depends |
| License | MIT | MIT | Tie |
| Architecture | Gateway-centric control plane | AIAgent self-evolving loop | Hermes |
| Learning Loop | None (static skills) | Built-in auto-learning | Hermes |
| Skill Creation | Manual authoring | Auto + manual | Hermes |
| Skill Improvement | Manual editing | Auto-optimization | Hermes |
| Memory System | Markdown files | Layered + pluggable backends | Hermes |
| User Modeling | Basic (USER.md) | Honcho dialectic modeling | Hermes |
| IM Channels | 20+ (Feishu, WeChat, WhatsApp, etc.) | 6+ (Telegram, Discord, Slack, etc.) | OpenClaw |
| Terminal Backends | 2 (local, Docker) | 6 (local, Docker, SSH, Modal, Daytona, Singularity) | Hermes |
| Enterprise | Yes (admin console, permissions, audit) | No | OpenClaw |
| Security Defaults | Weak (multiple CVEs) | Strong (secure by default) | Hermes |
| Community Ecosystem | 5700+ skills | 83+ projects | OpenClaw |
| Research Tools | None | Atropos RL / trajectory export | Hermes |
| MCP Support | Yes | Yes + MCP Server mode | Hermes |
| Sub-Agents | Thread-bound sessions | Fully isolated independent agents | Hermes |
| Deployment Cost | ~$5-15/month VPS | ~$5/month VPS | Hermes |

---

## Quick Start

### ⚡ One-Click Deploy (~8 minutes)

**Prerequisites:**
- An AWS account
- An EC2 key pair in your target region ([create one](https://console.aws.amazon.com/ec2/home#KeyPairs:))
- Bedrock model access enabled ([enable here](https://console.aws.amazon.com/bedrock/home#/modelaccess))

**3 steps:**
1. ✅ Click **"Launch Stack"** below
2. ✅ Select your EC2 key pair → click **Create Stack**
3. ✅ Wait ~8 minutes → check **Outputs** tab → connect and chat

| Region | Launch Stack |
|--------|-------------|
| **US East (Ohio)** | [![Launch Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=us-east-2#/stacks/create/review?stackName=hermes-bedrock&templateURL=https://sharefile-jiade.s3.cn-northwest-1.amazonaws.com.cn/hermes-bedrock.yaml) |
| **US East (N. Virginia)** | [![Launch Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?stackName=hermes-bedrock&templateURL=https://sharefile-jiade.s3.cn-northwest-1.amazonaws.com.cn/hermes-bedrock.yaml) |
| **US West (Oregon)** | [![Launch Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=us-west-2#/stacks/create/review?stackName=hermes-bedrock&templateURL=https://sharefile-jiade.s3.cn-northwest-1.amazonaws.com.cn/hermes-bedrock.yaml) |
| **EU (Ireland)** | [![Launch Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks/create/review?stackName=hermes-bedrock&templateURL=https://sharefile-jiade.s3.cn-northwest-1.amazonaws.com.cn/hermes-bedrock.yaml) |
| **Asia Pacific (Tokyo)** | [![Launch Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=ap-northeast-1#/stacks/create/review?stackName=hermes-bedrock&templateURL=https://sharefile-jiade.s3.cn-northwest-1.amazonaws.com.cn/hermes-bedrock.yaml) |

> Uses cross-region inference profiles — deploy in any region, requests auto-route to optimal locations.

**What happens automatically:**
- Creates VPC, subnets, security groups
- Launches EC2 instance (Ubuntu 24.04)
- Installs Python 3.12, Hermes Agent, boto3
- Configures Bedrock as the default provider with IAM role authentication
- Signals CloudFormation when ready

### CLI Deploy (Alternative)

```bash
git clone https://github.com/JiaDe-Wu/sample-hermes-agent-on-aws-with-bedrock.git
cd sample-hermes-agent-on-aws-with-bedrock
./deploy.sh hermes-bedrock us-east-2 your-keypair
```

---

## Connect to Your Instance

After deployment, go to the **CloudFormation Outputs** tab.

### Option A: EC2 Console (Easiest — no setup required)

1. Go to [EC2 Console → Instances](https://console.aws.amazon.com/ec2/home#Instances:)
2. Find the instance named `hermes-bedrock-instance`
3. Select it → click **Connect** (top right)
4. Choose **Session Manager** tab → click **Connect**
5. In the terminal:

```bash
sudo su - ubuntu
hermes chat
```

### Option B: SSM from Your Terminal

```bash
# Copy from CloudFormation Outputs → Step2ConnectSSM
aws ssm start-session --target i-0xxxxxxxxxxxx --region us-east-2

# Then:
sudo su - ubuntu
hermes chat
```

> Requires [SSM Session Manager Plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html) installed locally.

### Option C: SSH

Only if you set `AllowedSSHCIDR` to your IP during deployment:

```bash
ssh -i your-key.pem ubuntu@<public-ip>
hermes chat
```

---

## Using Hermes Agent

### Commands

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
| `Ctrl+C` | Interrupt current generation |
| `/exit` | Exit |

---

## Available Bedrock Models

| Model | ID | Best For |
|-------|-----|---------|
| **Claude Sonnet 4.6** (default) | `us.anthropic.claude-sonnet-4-6` | General purpose, coding |
| **Claude Opus 4.6** | `us.anthropic.claude-opus-4-6-v1` | Complex reasoning |
| **Claude Haiku 4.5** | `us.anthropic.claude-haiku-4-5-20251001-v1:0` | Fast, cheap |
| **Amazon Nova Pro** | `us.amazon.nova-pro-v1:0` | AWS-native, balanced |
| **Amazon Nova Micro** | `us.amazon.nova-micro-v1:0` | Fastest, cheapest |
| **DeepSeek V3.2** | `deepseek.v3.2` | Strong open model |
| **Llama 4 Scout 17B** | `us.meta.llama4-scout-17b-instruct-v1:0` | Meta's latest |

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

## Cost

| Component | Monthly |
|-----------|---------|
| EC2 (t3.medium) | ~$30 |
| EBS (30GB gp3) | ~$2.40 |
| VPC Endpoints (optional) | ~$22 |
| Bedrock usage | Pay-per-use |
| **Total infrastructure** | **~$33-65** |

## Cleanup

```bash
aws cloudformation delete-stack --stack-name hermes-bedrock --region us-east-2
```

Or delete from the [CloudFormation Console](https://console.aws.amazon.com/cloudformation/).

---

## About the Bedrock Integration

This deployment uses our **native Bedrock Converse API integration** — not the OpenAI-compatible endpoint.

### What We Built

| Component | Description |
|-----------|-------------|
| `agent/bedrock_adapter.py` | Converse API adapter — message/tool conversion, streaming with delta callbacks, interrupt support |
| AWS credential chain | IAM roles, SSO, env vars, IMDS — zero API key management |
| Dynamic model discovery | `ListFoundationModels` + `ListInferenceProfiles` with caching |
| Guardrails | Optional Bedrock Guardrails via `config.yaml` |
| Error classification | `ThrottlingException`, `ModelNotReadyException`, context overflow — proper retry/backoff |
| Context lengths | Static table for all Bedrock models, correct compression thresholds |
| Usage pricing | Accurate `/usage` cost tracking for Bedrock models |
| `hermes doctor` | Bedrock diagnostics — credential detection, API health, model count |
| `hermes auth` | AWS IAM identity and region display |
| `/model` switch | Mid-conversation model switching with Bedrock discovery validation |

### Implementation Reference

Follows the same architecture as [OpenClaw's `extensions/amazon-bedrock/`](https://github.com/openclaw/openclaw/tree/main/extensions/amazon-bedrock) plugin. IMDS credential detection addresses the same issue as [OpenClaw PR #62673](https://github.com/openclaw/openclaw/pull/62673).

### Testing

- **107 automated tests** — all passing on Python 3.11.14
- **4 models end-to-end** — Claude Sonnet 4.6, Nova Pro, DeepSeek V3.2, Llama 4 Scout
- **CloudFormation end-to-end** — stack deploy → SSM connect → `hermes chat` → multi-model
- **Gateway verified** — Feishu messaging platform tested

### Related Links

| Resource | URL |
|----------|-----|
| Hermes Agent Bedrock PR | [#7920](https://github.com/NousResearch/hermes-agent/pull/7920) |
| Feature Request Issue | [#3863](https://github.com/NousResearch/hermes-agent/issues/3863) |
| OpenClaw on AWS (reference) | [clawdbot-aws-bedrock](https://github.com/JiaDe-Wu/clawdbot-aws-bedrock) |
| OpenClaw on AWS (aws-samples) | [sample-Moltbot-on-AWS-with-Bedrock](https://github.com/aws-samples/sample-Moltbot-on-AWS-with-Bedrock) |

---

## Security

- 🔐 **No API keys** — IAM role authentication via instance metadata
- 🔒 **No open ports** — SSM Session Manager (SSH optional, disabled by default)
- 🛡️ **Private network** — VPC Endpoints keep Bedrock traffic off the internet (optional)
- 📊 **Audit trail** — CloudTrail logs every Bedrock API call

## License

MIT. Hermes Agent is [MIT licensed](https://github.com/NousResearch/hermes-agent/blob/main/LICENSE).

---

**Built for AWS customers who want a self-improving AI agent on infrastructure they control.**
