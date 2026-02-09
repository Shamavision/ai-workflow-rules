# Security Disclaimers - AI Workflow Rules v9.0

> **IMPORTANT LEGAL NOTICE**
> **Please read carefully before using this framework**

---

## ⚠️ What This Framework Provides

✅ **Tools and Guidelines** for secure AI-assisted development
✅ **Automated Checks** via pre-commit hooks
✅ **Best Practices** based on OWASP, GDPR, industry standards
✅ **AI-Specific Protection** (prompt injection, PII detection)

---

## ❌ What This Framework DOES NOT Guarantee

❌ **100% Protection** from all security threats
❌ **Compliance Certification** (GDPR, SOC2, ISO, PCI-DSS)
❌ **Zero Vulnerabilities** (we fix bugs as discovered)
❌ **Legal Liability** for data breaches or losses
❌ **Professional Security Audit** (hire auditors for that)

---

## License: GPL v3

```
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the GNU General Public License for more details.
```

**Translation:** We provide this framework "as is". No guarantees. No warranty. Use at your own risk.

---

## Shared Responsibility Model

### 🛠️ Our Responsibilities

- Maintain open-source codebase
- Update security patterns when new threats emerge
- Fix reported bugs and vulnerabilities
- Provide documentation and examples
- Respond to security reports on GitHub

### 👤 Your Responsibilities

- **Configure** tools for your specific use case
- **Review** all AI-generated code before committing
- **Test** security in your environment
- **Audit** your application with professionals
- **Hire** security experts for mission-critical apps
- **Purchase** cyber insurance to cover incidents
- **Comply** with regulations (GDPR, PCI-DSS, etc.)

---

## For Mission-Critical Applications

**If your application:**
- Handles financial transactions
- Stores sensitive user data (health, PII)
- Serves >100,000 users
- Is regulated (HIPAA, PCI-DSS, GDPR)

**You MUST:**

🏢 **Hire security professionals**
   - Full code review by certified auditors
   - Penetration testing before production launch

🔍 **Conduct compliance audits**
   - GDPR: Hire data protection officer
   - SOC2: Hire compliance consultant
   - PCI-DSS: Hire Qualified Security Assessor (QSA)
   - ISO 27001: Hire certification body

💼 **Purchase cyber insurance**
   - Coverage: $1M+ for data breaches
   - Incident response services included

🚨 **Implement incident response plan**
   - CSIRT team (Computer Security Incident Response Team)
   - 24/7 monitoring (SIEM, EDR)
   - Breach notification procedures

---

## Ukrainian Market Notice

This framework includes **Ukrainian-specific compliance tools**:

✅ Zero tolerance for russian tracking services
✅ Ukrainian PII patterns (IPN, passport, phone)
✅ GDPR compliance helpers (PII detection)

**However:**
- ❌ This is NOT a substitute for legal consultation
- ❌ Consult with Ukrainian lawyers for full compliance
- ❌ Data protection officer (DPO) required for GDPR

**Relevant laws:**
- Law of Ukraine "On Personal Data Protection"
- GDPR (if serving EU customers)
- Ukrainian Cybersecurity Law

---

## Examples of What Can Still Go Wrong

Even with this framework, you may still have:

- **Business logic bugs**
  - Example: Users can withdraw more money than they have
  - Solution: Proper testing, code review

- **Zero-day vulnerabilities**
  - Example: Newly discovered exploit in Node.js
  - Solution: Keep dependencies updated, monitor CVEs

- **Social engineering attacks**
  - Example: Employee tricked into revealing password
  - Solution: Security awareness training

- **Infrastructure compromises**
  - Example: AWS S3 bucket misconfigured as public
  - Solution: Cloud security posture management (CSPM)

---

## Limitation of Liability

To the maximum extent permitted by law:

- ❌ **No warranty** of any kind (express or implied)
- ❌ **Not liable** for any damages (direct, indirect, incidental)
- ❌ **Not liable** for data breaches or security incidents
- ❌ **Not liable** for lost profits or business interruption

**If you disagree with these terms, do not use this framework.**

---

## Third-Party Integrations

This framework may integrate with:
- TruffleHog (secret scanning)
- Semgrep (SAST)
- Snyk (SCA)

**Their disclaimers apply separately.** We are not responsible for third-party tools.

---

## No Professional Relationship

Using this framework does NOT create:
- ❌ Professional security services relationship
- ❌ Legal or compliance consulting relationship
- ❌ Warranty or support agreement
- ❌ Indemnification obligation

For professional services, hire certified consultants.

---

## Changes to This Disclaimer

We may update this disclaimer. Check the latest version at:
https://github.com/Shamavision/ai-workflow-rules

**By using this framework, you acknowledge:**
- ✅ You have read and understood these disclaimers
- ✅ You accept the GPL v3 license terms
- ✅ You understand the shared responsibility model
- ✅ You will not hold us liable for security incidents

---

## Contact for Security Issues

**Do NOT publicly disclose security vulnerabilities.**

Report privately via:
- GitHub Security Advisories: https://github.com/Shamavision/ai-workflow-rules/security/advisories
- Email: shamavision@wellme.ua (encrypt with PGP if sensitive)

We will respond within 72 hours.

---

## References

- [Threat Model](THREAT_MODEL.md) - What we protect vs don't
- [Security Policy](.ai/security-policy.json) - Detection rules
- [AI Protection Policy](.ai/ai-protection-policy.json) - AI-specific rules
- [GPL v3 License](../LICENSE) - Full license text

---

**Made in Ukraine 🇺🇦** | **Framework Version 9.0.0** | **GPL v3**

**Last Updated:** 2026-02-05
