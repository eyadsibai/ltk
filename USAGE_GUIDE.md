# LTK Domain Plugins - Daily Usage Guide

This guide shows how to utilize the ltk domain plugins for your daily tasks.

## Quick Reference

| Task | Plugin | Key Components |
|------|--------|----------------|
| Write code | ltk-engineering | code-reviewer, test-analyzer, architecture-analyzer |
| Create content | ltk-product | content-marketer, content-research-writer |
| SEO optimization | ltk-product | seo-* agents (10 specialized agents) |
| Sales & leads | ltk-product | sales-automator, lead-research-assistant |
| Social media | ltk-product | tiktok-strategist, growth-hacker |
| Database work | ltk-data | sql-expert, database-optimizer |
| Deploy & infra | ltk-devops | security-analyzer, deployment-engineer |
| Git workflows | ltk-github | pr-reviewer, smart-commit |
| Design work | ltk-design | frontend-developer, accessibility |

---

## ltk-product: Marketing, Sales & Business

### Content Marketing

**Agents:**

- `content-marketer` - AI-powered content strategy, omnichannel distribution
- `content-research-writer` - Research-backed content with citations

**Skills:**

- `content-writing` - Writing techniques and frameworks
- `brand-guidelines` - Maintain brand consistency

**Daily Use:**

```
"Help me write a blog post about [topic] for our target audience"
"Create a content calendar for Q1"
"Research and write an article about [subject] with citations"
```

### SEO Suite (10 Specialized Agents)

| Agent | Purpose |
|-------|---------|
| `seo-keyword-strategist` | Keyword research and strategy |
| `seo-content-planner` | Content planning for SEO |
| `seo-content-writer` | SEO-optimized content creation |
| `seo-content-auditor` | Audit existing content for SEO |
| `seo-meta-optimizer` | Title tags, meta descriptions |
| `seo-structure-architect` | Site structure optimization |
| `seo-snippet-hunter` | Featured snippet optimization |
| `seo-authority-builder` | Link building strategies |
| `seo-content-refresher` | Update old content |
| `seo-cannibalization-detector` | Find keyword cannibalization |

**Daily Use:**

```
"Analyze my website's SEO and suggest improvements"
"Find keyword opportunities for [topic]"
"Audit this page for SEO issues"
"Help me get featured snippets for [query]"
```

### Sales & Lead Generation

**Agents:**

- `sales-automator` - Cold emails, follow-ups, proposals
- `product-sales-specialist` - RFP responses, product demos
- `startup-analyst` - Business analysis and strategy

**Skills:**

- `lead-research-assistant` - Find and qualify leads
- `competitive-ads-extractor` - Analyze competitor ads
- `competitive-landscape` - Market competitive analysis

**Commands:**

- `/business-case` - Create a business case
- `/financial-projections` - Generate financial projections
- `/market-opportunity` - Analyze market opportunity

**Daily Use:**

```
"Write a cold email sequence for [product]"
"Research leads in [industry] for our product"
"Create a proposal for [client]"
"Analyze our competitors' advertising strategies"
```

### Social Media & Growth

**Agents:**

- `growth-hacker` - Viral loops, growth experiments, AARRR framework
- `tiktok-strategist` - TikTok campaigns, viral content, algorithm optimization

**Skills:**

- `slack-gif-creator` - Create GIFs for social content
- `domain-name-brainstormer` - Generate domain name ideas

**Daily Use:**

```
"Design a viral growth loop for our product"
"Create a TikTok content strategy"
"Help me come up with domain names for [brand]"
```

### Business Documents

**Skills:**

- `document-skills/docx` - Create Word documents
- `document-skills/pptx` - Create PowerPoint presentations
- `document-skills/xlsx` - Create Excel spreadsheets
- `document-skills/pdf` - Work with PDFs

**Commands:**

- `/financial-projections` - Financial modeling
- `/business-case` - Business case documents
- `/market-opportunity` - Market analysis

**Daily Use:**

```
"Create a pitch deck for [company]"
"Generate a financial projection spreadsheet"
"Create a business case document for [initiative]"
```

---

## ltk-engineering: Software Development

### Code Quality

**Agents:**

- `code-reviewer` - Review code for issues
- `architecture-analyzer` - Analyze code architecture
- `test-analyzer` - Analyze test coverage
- `refactor-assistant` - Safe code refactoring

**Commands:**

- `/validate-build` - Run and validate builds
- `/analyze-coverage` - Analyze test coverage
- `/check-quality` - Code quality metrics
- `/refactor` - Guided refactoring

**Daily Use:**

```
"Review this PR for code quality"
"Analyze the architecture of this module"
"Find gaps in our test coverage"
/validate-build
/check-quality
```

### Testing

**Agents:**

- `test-agent` - Write and run tests
- `tdd-orchestrator` - Test-driven development
- `bug-validator` - Validate bug fixes

**Skills:**

- `test-driven-development` - TDD practices
- `e2e-testing` - End-to-end testing

**Commands:**

- `/test-file` - Test a specific file
- `/debug` - Debug issues

**Daily Use:**

```
"Write tests for this function"
"Help me fix this failing test"
/test-file src/utils.py
```

---

## ltk-data: Data & Databases

**Agents:**

- `sql-expert` - Query optimization, database design
- `database-optimizer` - Performance tuning
- `data-integrity-guardian` - Data quality checks

**Skills:**

- Full data science stack: polars, pandas, scikit-learn
- ML: transformers, huggingface, llm-training
- Visualization: matplotlib, seaborn

**Daily Use:**

```
"Optimize this SQL query"
"Design a database schema for [use case]"
"Help me analyze this dataset"
"Build a machine learning pipeline for [task]"
```

---

## ltk-devops: Infrastructure & Security

**Agents:**

- `security-analyzer` - Security scanning
- `threat-modeling-expert` - STRIDE analysis
- `deployment-engineer` - Deployment automation
- `devops-automator` - CI/CD automation

**Commands:**

- `/deploy` - Deploy with pre-flight checks
- `/scan-security` - Security analysis

**Skills:**

- `k8s-security` - Kubernetes security
- `secrets-management` - Secrets handling
- `helm-charts` - Helm chart development

**Daily Use:**

```
"Scan this code for security vulnerabilities"
"Create a threat model for our API"
/deploy
/scan-security
```

---

## ltk-github: Git Workflows

**Agents:**

- `pr-reviewer` - Review pull requests
- `pr-comment-resolver` - Address PR comments
- `github-issue-fixer` - Fix GitHub issues

**Commands:**

- `/smart-commit` - Intelligent commits
- `/create-pr` - Create pull requests
- `/fix-issue` - Fix a GitHub issue

**Skills:**

- `git-workflows` - Git best practices
- `changelog-generator` - Generate changelogs

**Daily Use:**

```
/smart-commit
/create-pr
"Fix issue #123"
"Review this PR"
```

---

## ltk-design: UI/UX & Design

**Agents:**

- `frontend-developer` - Frontend implementation
- `mobile-developer` - Mobile development

**Skills:**

- `ui-ux` - UI/UX best practices
- `accessibility` - WCAG compliance
- `design-systems` - Design system development

**Daily Use:**

```
"Review this UI for accessibility issues"
"Help me implement this design"
"Create a design system for [project]"
```

---

## ltk-core: Foundations (Always Installed)

### Thinking & Planning

**Commands:**

- `/think` - Light reflection
- `/think-harder` - Deep analysis
- `/ultrathink` - Maximum reasoning
- `/ralph-loop` - Iterative development loop

**Skills:**

- `prompt-engineering` - Effective prompting
- `context-optimization` - Optimize context usage
- `multi-agent-patterns` - Multi-agent architectures

### Workflows

**Commands:**

- `/lfg` - Let's F*ing Go (start workflow)
- `/brainstorm` - Brainstorming session
- `/sync-submodules` - Sync plugin submodules

**Daily Use:**

```
/think "How should I approach [problem]?"
/ultrathink "Design an architecture for [system]"
/ralph-loop "Build feature X iteratively"
```

---

## Installation by Use Case

```bash
# Content creator / Marketer
./install.sh --preset=product /path/to/project

# Software developer
./install.sh --preset=developer /path/to/project

# Full-stack developer
./install.sh --preset=fullstack /path/to/project

# DevOps engineer
./install.sh --preset=devops /path/to/project

# Designer
./install.sh --preset=design /path/to/project

# Everything
./install.sh --all /path/to/project
```

---

## Tips for Daily Use

1. **Use agents for complex tasks** - Agents have specialized knowledge
2. **Use commands for quick actions** - `/smart-commit` is faster than explaining
3. **Skills load automatically** - Just ask about the topic
4. **Combine plugins** - Install multiple for cross-functional work
5. **Use `/think` for planning** - Before starting complex tasks

---

## Using Commands

Commands are invoked directly by name (no prefix needed):

```bash
/sync-submodules      # Sync from submodules
/smart-commit         # Intelligent commit
/validate-build       # Run build validation
/think                # Light reflection
/ultrathink           # Deep reasoning
/create-pr            # Create pull request
/scan-security        # Security analysis
/business-case        # Generate business case
```

Commands are defined by the `name` field in each command file.
