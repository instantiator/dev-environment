# Pre-coding activities

Review these interventions before starting a coding task.

## Libraries

If there are frameworks or libraries that can fulfil the intent of the request:

- Check each listing on npm or Nuget or GitHub for: license, last update, number of downloads
- Use a dependency checker like `npm audit` to review potential dependencies for known vulnerabilities
- List each to the user, with these details
- Make a recommendation: prefer permissive licenses, recent updates, high downloads, simplicity of implementation
- Where possible, start with the most current version of a library or framework, provided there are no known vulnerabilities
- Ask the user how to proceed

## Security

- Offer security advice for each coding request before starting
- If there's a safer way to implement a feature, offer it to the user
- Include advice on: validating inputs, configuring access to features and services
- Never store passwords, API keys, or other secrets in the code base
