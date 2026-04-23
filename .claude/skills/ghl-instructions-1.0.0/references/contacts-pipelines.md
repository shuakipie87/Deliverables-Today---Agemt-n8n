# GHL Contacts & Pipelines Guide

## Table of Contents
- [Contact Management](#contact-management)
- [Custom Fields](#custom-fields)
- [Tags](#tags)
- [Pipelines](#pipelines)
- [Smart Lists](#smart-lists)

## Contact Management

### Adding Contacts

#### Manual Entry
1. Go to **Contacts** tab
2. Click **Add Contact** button
3. Fill in required fields (Name, Email/Phone)
4. Add optional fields as needed
5. Click **Save**

#### CSV Import
1. Go to **Contacts** > **Import**
2. Upload CSV file
3. Map columns to GHL fields
4. Choose duplicate handling option
5. Start import

#### API/Zapier Integration
- Connect via Zapier for automated imports
- Use GHL API for custom integrations
- Set up webhook triggers for real-time sync

### Contact Record Details

#### Standard Fields
- First Name, Last Name
- Email, Phone
- Address (Street, City, State, ZIP, Country)
- Source, Tags
- Assigned User

#### Activity Timeline
- View all interactions
- Emails, SMS, calls, notes
- Appointment history
- Task completions

### Contact Actions

| Action | How To |
|--------|--------|
| Send Email | Click email icon or "Send Email" |
| Send SMS | Click SMS icon or "Send SMS" |
| Call | Click phone icon (requires phone integration) |
| Add Note | Click "Add Note" in timeline |
| Add Task | Click "Add Task" button |
| Book Appointment | Click "Book Appointment" |

## Custom Fields

### Creating Custom Fields
1. Go to **Settings** > **Custom Fields**
2. Click **Add Field**
3. Choose field type
4. Enter field name
5. Configure options
6. Save

### Field Types
| Type | Use Case |
|------|----------|
| Text | Short text, names, IDs |
| Text Area | Long text, notes |
| Number | Quantities, scores |
| Phone | Phone numbers |
| Email | Email addresses |
| Date | Birthdates, deadlines |
| Dropdown | Single selection from list |
| Multi-select | Multiple selections |
| Checkbox | Yes/No values |
| File Upload | Documents, images |

### Custom Field Best Practices
- Use clear, descriptive names
- Group related fields with folders
- Set required fields sparingly
- Use dropdowns for consistent data

## Tags

### What Tags Are For
- Segment contacts into groups
- Trigger workflow automations
- Filter and search contacts
- Track lead status/source

### Managing Tags
1. Go to **Settings** > **Tags**
2. Create, edit, or delete tags
3. Use folders to organize tags

### Applying Tags

#### Manual Tagging
- Open contact record
- Click tag field
- Select or type tag names

#### Automatic Tagging
- Form submissions can add tags
- Workflow actions add/remove tags
- Triggers based on behavior

### Tag Naming Conventions
Use consistent naming:
- `Source: Facebook`
- `Status: Qualified`
- `Interest: Product A`
- `Campaign: Summer 2024`

## Pipelines

### Creating a Pipeline
1. Go to **Settings** > **Pipelines**
2. Click **Create Pipeline**
3. Name your pipeline
4. Add stages
5. Save

### Pipeline Stages

#### Default Stage Examples
1. **New Lead** - Initial contact
2. **Contacted** - First outreach made
3. **Qualified** - Meets criteria
4. **Proposal** - Offer sent
5. **Negotiation** - Discussing terms
6. **Won** - Deal closed
7. **Lost** - Deal lost

#### Stage Configuration
- Name and color
- Probability percentage
- Automation triggers

### Working with Opportunities

#### Creating an Opportunity
1. Open contact record
2. Click **Add Opportunity**
3. Select pipeline
4. Set stage, value, expected close date
5. Save

#### Moving Through Stages
- Drag and drop in pipeline view
- Click opportunity > change stage
- Automate via workflows

### Pipeline Views

#### Kanban View
- Visual board with stage columns
- Drag cards between stages
- Quick overview of all deals

#### List View
- Sortable table format
- Filter by any field
- Bulk actions available

### Pipeline Reporting
- Total pipeline value
- Stage conversion rates
- Average deal size
- Time in each stage

## Smart Lists

### What Are Smart Lists
Saved filters that automatically update based on criteria.

### Creating Smart Lists
1. Go to **Contacts**
2. Apply filters (tags, fields, dates, etc.)
3. Click **Save as Smart List**
4. Name the list
5. Save

### Filter Options
- Tags (has/doesn't have)
- Custom fields (equals, contains, etc.)
- Date ranges (created, last activity)
- Pipeline stage
- Assigned user
- Activity status

### Smart List Examples

#### Hot Leads
- Tag: "Qualified"
- Last activity: Within 7 days
- Pipeline stage: Proposal or Negotiation

#### Stale Contacts
- Last activity: More than 30 days ago
- Not in stage: Won or Lost

#### VIP Customers
- Tag: "Customer"
- Custom field "Lifetime Value" > $5000

### Using Smart Lists
- Export for campaigns
- Bulk actions (tag, assign, delete)
- Monitor with saved searches
- Trigger workflow enrollments
