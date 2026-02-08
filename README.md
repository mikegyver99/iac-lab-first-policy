# Terraform Sentinel Policy Set

This repository contains Sentinel policies for Terraform Cloud/Enterprise that enforce infrastructure as code best practices and organizational standards.

## Overview

This policy set includes two policies:

1. **Private Module Registry (PMR) Enforcement** - Ensures all modules are sourced from your organization's Private Module Registry
2. **Mandatory Tags Enforcement** - Requires specific tags on AWS EC2 instances

## Policies

### 1. Private Module Registry Enforcement

**File:** `require-modules-from-pmr.sentinel`

**Purpose:** Validates that all modules loaded directly by the root module are sourced from the Private Module Registry (PMR) of your Terraform Cloud/Enterprise organization.

**Enforcement Level:** `hard-mandatory`

**Parameters:**
- `address` - The address of the TFC/TFE server (default: `app.terraform.io`)
- `organization` - The organization on the TFC/TFE server (required)

**Example:** This policy ensures modules are referenced like:
```hcl
module "example" {
  source  = "app.terraform.io/your-org/module-name/aws"
  version = "1.0.0"
}
```

### 2. Mandatory Tags Enforcement

**File:** `enforce-mandatory-tags.sentinel`

**Purpose:** Requires that all AWS EC2 instances have mandatory tags applied.

**Enforcement Level:** `hard-mandatory`

**Required Tags:**
- `Name`
- `Environment`

**Example:** EC2 instances must include these tags:
```hcl
resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  
  tags = {
    Name        = "my-instance"
    Environment = "production"
  }
}
```

## Usage

### Applying to Terraform Cloud/Enterprise

1. Push this repository to a VCS provider (GitHub, GitLab, etc.)
2. In Terraform Cloud/Enterprise, navigate to your organization settings
3. Go to **Policy Sets** and click **Connect a new policy set**
4. Select your VCS provider and this repository
5. Configure the policy set:
   - Set the **Name** and **Description**
   - Choose **Policies enforced on selected workspaces** or **Policies enforced globally**
   - Set the required parameter `organization` to your TFC/TFE organization name
6. Apply the policy set

### Testing Locally

To test these policies locally, you can use the Sentinel CLI:

```bash
# Install Sentinel CLI
# Download from https://docs.hashicorp.com/sentinel/downloads

# Run a test
sentinel test

# Apply a specific policy
sentinel apply require-modules-from-pmr.sentinel
```

## Configuration

The `sentinel.hcl` file defines the policy set configuration:

```hcl
policy "first policy pmr" {
  source            = "./require-modules-from-pmr.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "enforce tags" {
  source            = "./enforce-mandatory-tags.sentinel"
  enforcement_level = "hard-mandatory"
}
```

### Enforcement Levels

- **hard-mandatory**: Must pass for the run to proceed. Cannot be overridden.
- **soft-mandatory**: Must pass unless an override is specified.
- **advisory**: Provides information but never prevents the run from proceeding.

## Customization

### Modifying Required Tags

To change the required tags, edit `enforce-mandatory-tags.sentinel`:

```sentinel
### List of mandatory tags ###
mandatory_tags = [
  "Name",
  "Environment",
  "Owner",      # Add additional tags
  "CostCenter", # as needed
]
```

### Changing Module Source Requirements

To modify the PMR source requirements, adjust the parameters in your Terraform Cloud/Enterprise policy set configuration or modify the `require-modules-from-pmr.sentinel` policy.

## Learn More

- [Sentinel Documentation](https://docs.hashicorp.com/sentinel)
- [Terraform Cloud Sentinel Policies](https://www.terraform.io/docs/cloud/sentinel/index.html)
- [Sentinel Language Specification](https://docs.hashicorp.com/sentinel/language)
