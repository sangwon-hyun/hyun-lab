# Contributing to the Lab Procedures Repository

Thank you for contributing to our lab procedures repository! This guide will help you add or update procedures effectively.

## Adding a New Procedure

### 1. Choose the Right Category

Place your procedure in the appropriate category:
- **Experimental:** Bench work, sample preparation, assays
- **Computational:** Data analysis, software workflows, pipelines  
- **Safety:** Safety protocols, emergency procedures
- **Equipment:** Equipment operation, maintenance, troubleshooting

If you're unsure, ask the lab manager.

### 2. Use the Template

Start with the [procedure template](./templates/procedure-template.md):

```bash
cp templates/procedure-template.md procedures/[category]/[your-procedure-name].md
```

### 3. Write Your Procedure

Follow these guidelines:

#### Title and Metadata
- Use a clear, descriptive title
- Include author, date, and version number
- Keep metadata up to date

#### Purpose
- Explain what the procedure accomplishes
- Describe when it should be used
- Keep it brief (2-3 sentences)

#### Prerequisites
- List required training or certifications
- Mention equipment or materials needed
- Note any dependent procedures

#### Safety Considerations
- **Always include safety information**
- List required PPE
- Describe potential hazards
- Explain mitigation strategies

#### Procedure Steps
- Number steps sequentially
- Use clear, active voice ("Mix the solution" not "The solution should be mixed")
- Include expected outcomes for each step
- Add notes, tips, or warnings as needed
- Use subsections for complex steps

#### Quality Control
- Describe how to verify success
- Include checkpoints
- Mention validation methods

#### Troubleshooting
- Use a table format for common issues
- Include problem, cause, and solution
- Add details based on experience

#### References
- Link to related procedures
- Cite protocols or papers
- Include manufacturer documentation

### 4. Update the Category README

After creating your procedure, add it to the category's README:

```markdown
- [Your Procedure Name](./your-procedure-name.md) - Brief description
```

### 5. Review Checklist

Before submitting, ensure your procedure has:

- [ ] Clear, descriptive title
- [ ] Complete metadata (author, date, version)
- [ ] Purpose statement
- [ ] Prerequisites listed
- [ ] Safety considerations included
- [ ] Step-by-step instructions with expected outcomes
- [ ] Quality control section
- [ ] Troubleshooting guidance
- [ ] References
- [ ] Revision history table
- [ ] Link added to category README

## Updating an Existing Procedure

### Making Updates

1. Edit the procedure file
2. Update the "Last Updated" date
3. Increment the version number (e.g., 1.0 → 1.1 for minor changes, 1.0 → 2.0 for major changes)
4. Add an entry to the Revision History table
5. Notify the lab if changes are significant

### Version Numbering

- **Major version (X.0):** Significant changes to the procedure that could affect results or safety
- **Minor version (X.Y):** Small improvements, clarifications, or corrections that don't change the core procedure

### Revision History

Always update the revision history table:

```markdown
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.1 | Jan 2026 | J. Doe | Added troubleshooting section |
| 1.0 | Dec 2025 | J. Doe | Initial version |
```

## Style Guidelines

### Writing Style

- Use clear, concise language
- Write in active voice
- Use present tense
- Be specific with measurements and times
- Define acronyms on first use
- Avoid jargon when possible

### Formatting

- Use Markdown formatting
- Use headers to organize sections
- Use bullet points for lists
- Use numbered lists for sequential steps
- Use tables for structured information
- Use code blocks for commands or code

### Naming Conventions

- File names: lowercase with hyphens (e.g., `sample-preparation.md`)
- Be descriptive but concise
- Avoid special characters

## Getting Help

If you need assistance:
- **Questions about procedure content:** Contact an experienced lab member
- **Questions about formatting:** Refer to this guide and the template
- **Technical issues:** Contact the lab admin

## Best Practices

1. **Test your procedure:** If possible, have someone else follow your written procedure to identify unclear steps
2. **Include photos or diagrams:** Visual aids can clarify complex steps
3. **Link to related procedures:** Help users find connected information
4. **Keep it current:** Review and update procedures regularly
5. **Document everything:** Include details that might seem obvious—they may not be to everyone

## Review Process

For critical procedures (especially safety-related):
1. Draft the procedure
2. Have it reviewed by an experienced lab member
3. Test the procedure
4. Make revisions based on feedback
5. Get final approval from the lab manager or PI

## Questions?

Contact the lab manager or repository maintainer with any questions or suggestions for improving this guide.

---

Thank you for helping maintain high-quality documentation for our lab!
