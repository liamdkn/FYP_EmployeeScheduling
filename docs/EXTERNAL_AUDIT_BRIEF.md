# External Security Audit Brief

**Project:** Employee Scheduling & Roster Generation  
**Owner and original developer:** Liam Durkan  
**Original submission:** South East Technological University, 22 April 2024  
**Audit brief prepared:** 13 November 2026  
**Review branch:** `maintenance/security-and-documentation`  
**Base commit:** `ce17bb0` on `origin/main`

## Repository provenance

Two public repositories form the authentic development record:

1. **Early development repository**  
   https://github.com/liamdkn/final-year-project  
   Early Flutter work is stored under `Code/my_app`. Its latest commit is dated February 2024.

2. **Canonical completed repository**  
   https://github.com/liamdkn/FYP_EmployeeScheduling  
   This is the later and most complete 2024 codebase. It continues through April 2024 and adds the Flask backend, expanded Flutter application, Firebase integration and final roster-generation implementation.

The repositories have unrelated Git roots and different layouts. They have intentionally not been merged or rewritten. The canonical repository links back to the early repository and explains the relationship in its README.

Supporting primary material:

- SETU showcase: https://showcase.setu.ie/C00264405/
- Final report: https://showcase.setu.ie/C00264405/assets/FYP_Project_Report.pdf
- Poster: https://showcase.setu.ie/C00264405/assets/FYP_Poster.pdf
- Functional specification: https://showcase.setu.ie/C00264405/assets/FYP_Functional_Spec.pdf

## Audit objective

Assess whether the proposed maintenance branch removes known credential exposure and closes the most direct API access-control failures without rewriting the original 2024 application, genetic algorithm, UI, workflows or data model.

The desired outcome is a preserved academic project that is safe to publish as a portfolio artefact. It is not intended to become an actively hosted production service as part of this work.

## Explicitly out of scope

- Feature development or redesign
- Algorithm replacement or optimisation
- Flutter UI refactoring
- Data-model migration
- Multi-tenant product development
- New hosting or production credentials
- Git history rewriting or force-pushing without separate approval
- Claims that the original project was created with AI assistance

## Credential incident and response

The public canonical repository contained:

- two Firebase/Google Cloud service-account JSON files; and
- a Mailtrap SMTP credential embedded in the Flask email service.

Treat all three credentials as compromised. Do not reproduce credential values in an audit report, terminal transcript, screenshot or patch.

The repository owner has confirmed that:

- both affected Google Cloud service accounts were disabled;
- both exposed user-managed service-account keys were deleted;
- the Mailtrap token/SMTP credential was revoked; and
- no replacement credentials were created.

The historical Git objects still contain the revoked credentials. The current branch removes the files from the active tree but deliberately does not rewrite history. The auditor should assess whether revocation plus preservation is sufficient for this portfolio repository or whether a coordinated history rewrite is warranted.

## Proposed security changes

### Secret handling

- Remove both tracked service-account JSON files.
- Add ignore rules for Firebase Admin keys, service-account files, `.env` files, private-key formats and generated output.
- Add a non-secret `.env.example`.
- Replace hardcoded backend service-account paths with Google Application Default Credentials.
- Move SMTP configuration and the demonstration business email to environment variables.
- Remove the embedded Mailtrap credential.

### API authentication and authorisation

- Verify Firebase ID tokens on protected Flask routes.
- Derive the caller identity from the verified token rather than `User-id` or `User-Type` request headers.
- Require a business account for employee-list, shift-creation, roster-management and request-approval operations.
- Allow employee record access only to the same authenticated employee or a business account.
- Prevent employee accounts from retrieving unpublished rosters directly.
- Add Firebase bearer tokens to the existing Flutter HTTP requests.

### Network and dependencies

- Replace unrestricted CORS with an environment-configured allowlist.
- Reduce the backend deployment requirements to packages actually imported by the Flask application.
- Pin the reviewed backend dependency versions.

### Verification coverage

- Add focused backend tests for missing tokens, valid tokens, employee denial and business access.
- Run `pip-audit` against the backend requirements.
- Run redacted secret scans against the current tree and Git history.

## Preservation guarantee to verify

The net branch should leave these paths byte-for-byte unchanged from `origin/main`:

- `python-flask-api/app/scripts/roster_generation.py`
- `my_app/lib/views/`
- `my_app/lib/models/`
- `my_app/pubspec.yaml`
- `my_app/pubspec.lock`
- `my_app/test/widget_test.dart`

The Flutter service files change only to attach the authenticated user's Firebase token to the existing HTTP requests.

## Verification evidence recorded locally

- Four authentication/authorisation unit tests pass.
- Backend requirements install successfully with Python 3.12.
- `pip-audit -r python-flask-api/requirements.txt` reports no known vulnerabilities.
- Python compilation succeeds.
- The Flask application imports and registers its routes with Firebase emulator environment variables.
- Redacted secret scanning finds no service-account private keys in the current working tree.
- Historical scanning still detects the revoked private keys in old commits, as expected.
- Firebase client API keys remain in platform configuration. These are public Firebase application identifiers, not service-account credentials; their API and application restrictions still require console review.
- No live Firebase end-to-end test was performed after revocation, and no replacement environment was created.

## Commands for an independent reviewer

Run these from a clone or supplied source archive. Do not print deleted JSON contents.

```bash
git status --short --branch
git diff --name-status origin/main
git diff --stat origin/main

git diff --quiet origin/main -- \
  python-flask-api/app/scripts/roster_generation.py \
  my_app/lib/views \
  my_app/lib/models \
  my_app/pubspec.yaml \
  my_app/pubspec.lock \
  my_app/test/widget_test.dart

PYTHONPATH=python-flask-api python -m unittest discover \
  -s python-flask-api/tests -v

python -m compileall -q python-flask-api
pip-audit -r python-flask-api/requirements.txt
```

Recommended redacted secret scans:

```bash
gitleaks dir . --redact=100
gitleaks git . --redact=100
```

Historical findings are expected. The report must distinguish revoked secrets in old commits from active secrets in the proposed branch tip.

## Residual risks requiring independent judgement

These items have not been concealed or declared resolved:

1. **Open business registration and tenant isolation**  
   A Firebase-authenticated user can follow the original business sign-up workflow and create a business document for their own UID. Business-only API checks currently establish role from the presence of that document. Original Firestore collections also retain single-business assumptions and do not consistently carry a business owner ID. An auditor should assess this as an authorisation and tenant-isolation risk before any public redeployment.

2. **Firestore rules are absent**  
   No Firestore rules file was included in the original repository. The Flask backend uses the Admin SDK, which bypasses Firestore Security Rules. The Flutter code primarily uses Firebase Authentication and the Flask API, but console rules and enabled Firebase products must be reviewed separately.

3. **Historical production identifiers remain**  
   The preserved Flutter code contains hardcoded demonstration business and roster document IDs and references the historical Render API URL. These remain to preserve original behaviour, but should be treated as historical deployment assumptions rather than production configuration.

4. **Historical secrets remain in Git objects**  
   Revocation makes the known credentials unusable, but scanners will continue to flag the public history. Rewriting history would require repository coordination, force-pushing and invalidating existing clones and links.

5. **Firebase client-key restrictions are unverified**  
   Client Firebase API keys are public by design, but the Google Cloud console should restrict them to the correct applications and Firebase-related APIs.

6. **No active deployment verification**  
   Confirm that the historical Render service is suspended or deleted. The maintenance work did not log into or modify Render.

7. **Limited automated coverage**  
   The original repository contains only a template Flutter test. Security middleware has focused unit coverage, but route-by-route integration, malformed-input, rate-limit and abuse-case testing remain appropriate for an external audit.

8. **Legacy root dependency snapshot**  
   The root `requirements.txt` appears to be a broad historical workstation/notebook export. The deployable Flask requirements are maintained separately in `python-flask-api/requirements.txt`.

## Requested auditor deliverables

Please provide:

- a severity-ranked findings report;
- confirmation that the proposed tree contains no active private credentials;
- review of token validation, role checks and ownership enforcement;
- review of CORS and error-handling exposure;
- dependency and supply-chain findings;
- an opinion on history preservation versus history rewriting;
- explicit identification of anything that must be fixed before the branch is pushed or merged; and
- a separate list of improvements that are advisable only if the application is ever redeployed.

Do not include private keys or revoked token values in the report.

## Safe pre-push handoff

The review branch is currently local and must not be pushed without owner approval. Do not send the repository's `.git` directory to an auditor because it contains the revoked historical keys.

After the README and audit brief are approved and committed locally, create a history-free source archive:

```bash
git archive --format=zip \
  --output ../FYP-security-review.zip \
  maintenance/security-and-documentation
```

The auditor can compare that archive with the public canonical repository at commit `ce17bb0`. A patch containing the deleted credential files should not be generated or distributed, because deletion patches can reproduce the private-key contents.

## Pre-push decision gates

No push or merge should occur until Liam Durkan has reviewed and approved:

1. the employer-facing README;
2. the external audit findings;
3. every net source-code change;
4. the treatment of residual authorisation risks;
5. whether local revert-pair commits should be squashed into clean security commits; and
6. the final destination branch and pull-request description.
