---
name: ghl-instructions
description: "GoHighLevel (GHL) instructions and tutorials for CRM, marketing automation, and workflows. Use when asked about GHL, GoHighLevel, HighLevel, or related topics including workflows, automations, contacts, pipelines, email/SMS campaigns, funnels, landing pages, triggers, actions, or appointments."
metadata: {"clawdbot":{"emoji":"🚀"}}
---

# GoHighLevel (GHL) Instructions

Comprehensive guide for using GoHighLevel CRM and marketing automation platform.

## Quick Reference

### Workflows & Automations
- **Create workflow**: Settings > Workflows > Create Workflow
- **Trigger types**: Contact Created, Tag Added, Form Submitted, Appointment Booked, etc.
- **Common actions**: Send Email, Send SMS, Add Tag, Move to Pipeline Stage, Wait, If/Else

### Contacts & Pipelines
- **Add contact**: Contacts > Add Contact (or import CSV)
- **Create pipeline**: Settings > Pipelines > Create Pipeline
- **Pipeline stages**: Customize stages like Lead, Qualified, Proposal, Won/Lost

### Campaigns & Marketing
- **Email campaign**: Marketing > Emails > Create Campaign
- **SMS campaign**: Marketing > SMS > Create Campaign
- **Funnels**: Sites > Funnels > Create Funnel
- **Landing pages**: Sites > Websites > Create Page

## Detailed Guides

For step-by-step instructions on specific topics:

- **Workflows & Automations**: See [references/workflows.md](references/workflows.md) for trigger setup, action configuration, conditional logic, and workflow examples
- **Contacts & Pipelines**: See [references/contacts-pipelines.md](references/contacts-pipelines.md) for CRM management, custom fields, pipeline stages, and lead tracking
- **Campaigns & Marketing**: See [references/campaigns.md](references/campaigns.md) for email templates, SMS campaigns, funnels, and marketing automation

## Common Tasks

### Set Up Lead Capture Automation
1. Create a form or funnel page
2. Create workflow with "Form Submitted" trigger
3. Add actions: Add Tag, Send Email, Add to Pipeline

### Create Follow-Up Sequence
1. Create workflow with trigger (e.g., "Tag Added")
2. Add Wait action (e.g., 1 day)
3. Add Send Email/SMS action
4. Repeat Wait + Send for multi-step sequence

### Move Leads Through Pipeline
1. Create workflow with appropriate trigger
2. Add "Update Contact Field" or "Add to Pipeline" action
3. Use If/Else for conditional routing

### Send Appointment Reminders
1. Create workflow with "Appointment Scheduled" trigger
2. Add Wait action (e.g., 24 hours before)
3. Add Send SMS/Email reminder action

## Tips

- **Test workflows** using Test mode before activating
- **Use tags** to segment contacts and trigger automations
- **Custom fields** help track specific data for your business
- **Snapshots** let you backup and restore account settings
