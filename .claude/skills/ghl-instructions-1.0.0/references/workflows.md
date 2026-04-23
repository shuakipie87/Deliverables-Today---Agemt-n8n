# GHL Workflows & Automations Guide

## Table of Contents
- [Creating Workflows](#creating-workflows)
- [Triggers](#triggers)
- [Actions](#actions)
- [Conditional Logic](#conditional-logic)
- [Workflow Examples](#workflow-examples)

## Creating Workflows

### Access Workflows
1. Go to **Settings** (gear icon)
2. Click **Workflows** in left sidebar
3. Click **Create Workflow** button

### Workflow Builder Interface
- **Left panel**: Triggers and actions library
- **Center canvas**: Visual workflow builder
- **Right panel**: Configuration for selected element

### Building a Workflow
1. Select a **Trigger** (starting point)
2. Add **Actions** (what happens)
3. Use **Wait** steps for delays
4. Add **Conditions** for branching logic
5. **Save** and **Publish** when ready

## Triggers

### Contact Triggers
| Trigger | Description |
|---------|-------------|
| Contact Created | Fires when new contact is added |
| Contact Tag Added | Fires when specific tag is added |
| Contact Tag Removed | Fires when specific tag is removed |
| Contact Changed | Fires when contact field changes |
| Contact DND | Fires when DND status changes |

### Form & Survey Triggers
| Trigger | Description |
|---------|-------------|
| Form Submitted | Fires when form is completed |
| Survey Submitted | Fires when survey is completed |
| Order Form Submitted | Fires when order form is submitted |

### Appointment Triggers
| Trigger | Description |
|---------|-------------|
| Appointment Scheduled | Fires when appointment is booked |
| Appointment Cancelled | Fires when appointment is cancelled |
| Appointment Rescheduled | Fires when appointment is moved |
| Appointment Status Changed | Fires on any status change |

### Pipeline Triggers
| Trigger | Description |
|---------|-------------|
| Pipeline Stage Changed | Fires when contact moves stages |
| Opportunity Status Changed | Fires on opportunity update |

### Communication Triggers
| Trigger | Description |
|---------|-------------|
| Customer Reply | Fires when contact replies |
| Email Opened | Fires when email is opened |
| Email Clicked | Fires when email link is clicked |
| SMS Received | Fires on incoming SMS |

### Payment Triggers
| Trigger | Description |
|---------|-------------|
| Invoice Created | Fires when invoice is generated |
| Payment Received | Fires when payment completes |
| Subscription Created | Fires on new subscription |

## Actions

### Communication Actions
| Action | Description |
|--------|-------------|
| Send Email | Send templated or custom email |
| Send SMS | Send text message |
| Send Voicemail Drop | Leave pre-recorded voicemail |
| Send Internal Notification | Alert team members |

### Contact Management Actions
| Action | Description |
|--------|-------------|
| Add Tag | Add tag to contact |
| Remove Tag | Remove tag from contact |
| Update Contact Field | Modify any contact field |
| Delete Contact | Remove contact from system |
| Add to Workflow | Trigger another workflow |
| Remove from Workflow | Stop another workflow |

### Pipeline Actions
| Action | Description |
|--------|-------------|
| Add to Pipeline | Create opportunity in pipeline |
| Update Pipeline Stage | Move to specific stage |
| Update Opportunity | Modify opportunity details |

### Task Actions
| Action | Description |
|--------|-------------|
| Create Task | Assign task to team member |
| Create Appointment | Book calendar appointment |

### Timing Actions
| Action | Description |
|--------|-------------|
| Wait | Pause for set duration |
| Wait Until | Pause until specific time/date |
| Go To | Jump to another step |

## Conditional Logic

### If/Else Conditions
Add branching based on contact data:
- Contact field values
- Tag presence
- Pipeline stage
- Custom field values

### Setting Up If/Else
1. Add **If/Else** action
2. Configure condition (e.g., "If tag contains 'VIP'")
3. Build **Yes** branch (condition true)
4. Build **No** branch (condition false)

### Common Condition Types
- **Contact has tag**: Route based on tags
- **Contact field equals**: Check specific values
- **Pipeline stage is**: Route by current stage
- **Custom field contains**: Check custom data

## Workflow Examples

### New Lead Nurture Sequence
```
Trigger: Form Submitted
  |
  v
Add Tag: "New Lead"
  |
  v
Send Email: Welcome Email
  |
  v
Wait: 2 days
  |
  v
Send SMS: Check-in message
  |
  v
Wait: 3 days
  |
  v
If/Else: Email Opened?
  Yes -> Send Email: Case Study
  No  -> Send SMS: Follow-up
```

### Appointment Reminder System
```
Trigger: Appointment Scheduled
  |
  v
Wait Until: 24 hours before appointment
  |
  v
Send SMS: "Reminder: Your appointment is tomorrow at {{appointment.time}}"
  |
  v
Wait Until: 1 hour before appointment
  |
  v
Send SMS: "Your appointment is in 1 hour!"
```

### Pipeline Stage Automation
```
Trigger: Pipeline Stage Changed to "Proposal Sent"
  |
  v
Send Email: Proposal follow-up
  |
  v
Create Task: "Follow up call" (due in 3 days)
  |
  v
Wait: 7 days
  |
  v
If/Else: Stage still "Proposal Sent"?
  Yes -> Send Email: Second follow-up
  No  -> End workflow
```

### Re-engagement Campaign
```
Trigger: Contact Tag Added "Inactive"
  |
  v
Wait: 30 days
  |
  v
Send Email: "We miss you" offer
  |
  v
Wait: 7 days
  |
  v
If/Else: Email clicked?
  Yes -> Remove Tag "Inactive", Add Tag "Re-engaged"
  No  -> Send SMS: Final offer message
```

## Best Practices

1. **Test before publishing**: Use test mode to verify workflow logic
2. **Use descriptive names**: Name workflows clearly (e.g., "New Lead - 7 Day Nurture")
3. **Set enrollment limits**: Prevent contacts from entering same workflow multiple times
4. **Monitor performance**: Check workflow stats regularly
5. **Use tags strategically**: Tags help segment and trigger automations
6. **Keep it simple**: Start simple, add complexity as needed
