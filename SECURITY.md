# Security policy

## Current support

Until tagged releases are published, security fixes target the latest commit on
the default branch.

## Reporting

Do not post secrets, tokens, private process command lines, or sensitive logs
in a public issue.

Prefer a private GitHub security advisory when enabled for the repository.
Otherwise, contact the maintainer through the GitHub profile before sending
sensitive reproduction details.

Useful information includes:

- Affected command and options.
- Linux distribution and Bash version.
- Minimal reproduction steps.
- Security impact.
- Sanitized proof of concept.

## Relevant security areas

Examples include:

- Command injection.
- Unsafe quoting.
- Unsafe log paths.
- Unexpected file overwrite behavior.
- Leakage of sensitive process arguments.
