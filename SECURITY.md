# Security Policy

## Supported Versions

Use this section to tell people about which versions of your project are
currently being supported with security updates.

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability within SSR Framework, please send an email to [security@ssrframework.dev](mailto:security@ssrframework.dev). All security vulnerabilities will be promptly addressed.

Please do not open a public issue for a security vulnerability.

### What to include

To help us understand the nature of the vulnerability, please provide:

- A description of the vulnerability
- Steps to reproduce the issue
- Potential impact of the vulnerability
- Any suggested fixes (if you have them)

### What to expect

- **Acknowledgment**: We will acknowledge receipt of your vulnerability report within 48 hours.
- **Assessment**: We will assess the vulnerability and determine its severity within 7 days.
- **Updates**: We will keep you informed of our progress as we work to address the issue.
- **Disclosure**: Once the vulnerability is fixed, we will publicly disclose it and credit you (unless you prefer to remain anonymous).

## Security Best Practices

When using SSR Framework, we recommend:

1. **Keep dependencies updated**: Regularly update your dependencies to get the latest security patches.
2. **Validate user input**: Always validate and sanitize user input on both client and server side.
3. **Use HTTPS**: Always use HTTPS in production to encrypt data in transit.
4. **Implement rate limiting**: Protect your API endpoints from abuse with rate limiting.
5. **Use secure headers**: Implement security headers like CSP, X-Frame-Options, etc.
6. **Keep secrets safe**: Never commit secrets or sensitive data to version control.
7. **Regular security audits**: Periodically review your code and dependencies for security issues.

## Security Features

SSR Framework includes several security features:

- **Input validation**: Built-in validation utilities
- **SQL injection protection**: Parameterized queries with SQLite
- **XSS protection**: Template escaping by default
- **CSRF protection**: Token-based CSRF protection (planned)
- **Rate limiting**: Built-in rate limiting middleware
- **Security headers**: Automatic security headers

## Dependencies

SSR Framework depends on several third-party packages. We monitor these dependencies for security vulnerabilities and update them promptly when security patches are available.

## Contact

For security concerns, please contact:

- Email: security@ssrframework.dev
- GitHub Security Advisory: [Create advisory](https://github.com/flutterdocteur/ssr_framework/security/advisories/new)
