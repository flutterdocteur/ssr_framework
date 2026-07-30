# Contributing to SSR Framework

First off, thank you for considering contributing to SSR Framework! It's people like you that make SSR Framework such a great tool.

## Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the [troubleshooting guide](docs/guides/troubleshooting.md) as you might find out that you don't need to create one. When you are creating a bug report, please include as many details as possible:

- **Use a clear and descriptive title** for the issue to identify the problem.
- **Describe the exact steps which reproduce the problem** in as many details as possible.
- **Provide specific examples to demonstrate the steps**.
- **Describe the behavior you observed after following the steps** and point out what exactly is the problem with that behavior.
- **Explain which behavior you expected to see instead and why.**
- **Include screenshots and animated GIFs** which show you following the described steps and clearly demonstrate the problem.
- **If the problem wasn't triggered by a specific action**, describe what you were doing before the problem happened.

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:

- **Use a clear and descriptive title** for the issue to identify the suggestion.
- **Provide a step-by-step description of the suggested enhancement** in as many details as possible.
- **Provide specific examples to demonstrate the steps**.
- **Describe the current behavior** and **explain which behavior you expected to see instead** and why.
- **Include screenshots and animated GIFs** which help you demonstrate the steps or point out the part of SSR Framework which the suggestion is related to.
- **Explain why this enhancement would be useful** to most SSR Framework users.

### Pull Requests

The process described here has several goals:

- Maintain SSR Framework's quality
- Fix problems that are important to users
- Engage the community in working toward the best possible SSR Framework
- Enable a sustainable system for SSR Framework's maintainers to review contributions

Please follow these steps to have your contribution considered by the maintainers:

1. **Fork the repository** and create your branch from `main`.
2. **If you've added code** that should be tested, add tests.
3. **If you've changed APIs**, update the documentation.
4. **Ensure the test suite passes**.
5. **Make sure your code lints**.
6. **Issue that pull request**!

## Styleguides

### Git Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line
- Consider starting the commit message with an applicable emoji:
    - 🎨 `:art:` when improving the format/structure of the code
    - 🐎 `:racehorse:` when improving performance
    - 🚱 `:non-potable_water:` when plugging memory leaks
    - 📝 `:memo:` when writing docs
    - 🐛 `:bug:` when fixing a bug
    - 🔥 `:fire:` when removing code or files
    - 💚 `:green_heart:` when fixing the CI build
    - ✅ `:white_check_mark:` when adding tests
    - 🔒 `:lock:` when dealing with security
    - ⬆️ `:arrow_up:` when upgrading dependencies
    - ⬇️ `:arrow_down:` when downgrading dependencies
    - ♻️ `:recycle:` when refactoring code

### Dart Styleguide

All Dart code must follow the [Dart style guide](https://dart.dev/guides/language/effective-dart/style).

Key points:
- Use `lowerCamelCase` for variable and function names
- Use `UpperCamelCase` for class names
- Use `UPPER_SNAKE_CASE` for constants
- Use 2 spaces for indentation
- Use `//` for single-line comments
- Use `///` for documentation comments
- Keep lines under 80 characters when possible

### Documentation Styleguide

- Use [Markdown](https://guides.github.com/features/mastering-markdown/) for documentation.
- Reference methods and classes in parentheses: `SsrConfig()`
- Reference classes and methods with their full path when they could be ambiguous.
- Include examples for all public APIs.

## Development Process

### Setting Up Your Development Environment

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/yourusername/ssr_framework.git
   cd ssr_framework
   ```
3. Install dependencies:
   ```bash
   ./install.sh
   ```
4. Create a branch for your changes:
   ```bash
   git checkout -b feature/my-feature
   ```

### Running Tests

Before submitting your pull request, make sure all tests pass:

```bash
# Run server tests
cd packages/ssr_server
dart test

# Run client tests
cd packages/ssr_client
dart test -p chrome

# Run all tests
cd packages/ssr_example
dart test
```

### Building the Project

```bash
cd packages/ssr_example
ssr build --release
```

### Code Review Process

The core team looks at Pull Requests on a regular basis. After feedback has been given we expect responses within two weeks. After two weeks we may close the pull request if it isn't showing any activity.

## Community

- Join our [Discord server](https://discord.gg/ssrframework) for discussions
- Follow us on [Twitter](https://twitter.com/ssrframework) for updates
- Read our [blog](https://ssrframework.dev/blog) for tutorials and announcements

## Recognition

Contributors who have made significant contributions will be:
- Listed in the README.md
- Added to the CONTRIBUTORS.md file
- Mentioned in release notes

Thank you for contributing to SSR Framework! 🎉
