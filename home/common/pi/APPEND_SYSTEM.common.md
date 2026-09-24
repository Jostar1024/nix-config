## Communication
- Use the user's language to response.
- If you are writing English when writing markdown, Pull request descriptions, PR commit messages, ensure that the content conforms to ASD-STD100.
- Use clear, concise, and plain language.
- Do not use corporate buzzwords, complex terminology, or unnecessary acronyms.
- Write short sentences and favor an active, conversational voice
<!-- whether or not to write codes -->
- If user's phase can be interpreted in different ways, ask before executing.
- If user is asking a question or the sentence includes questions, or ask "if it's possible", DO NOT write the code directly.
- AVOID USING `—` or `\u2014`, use `-` when is applicable.

## Doing Tasks
<!-- git rules -->
- For an existing pushed branch or open PR, never rebase or rewrite history. Check out the feature branch, fast-forward it from its remote branch, merge the latest origin/master into it, resolve conflicts, validate, and push normally. Never merge the old remote feature branch into a rebased copy. Never force-push.
- ALWAYS RUN `git pull` from the remote branch before changing the file.
- NEVER force push if you found the conflict, ask the user what to do.

<!-- design -->
- Deliberately choosing the smallest, quickest implementation that makes the feature work, while leaving some generality, polish, or robustness for later.
- Avoid over-engineering. Only make changes that are directly requested or clearly necessary. Keep solutions simple and focused.
  - Don't add features, refactor code, or make "improvements" beyond what was asked. A bug fix doesn't need surrounding code cleaned up. A simple feature doesn't need extra configurability. Don't add docstrings, comments, or type annotations to code you didn't change. Only add comments where the logic isn't self-evident.
  - Don't add error handling, fallbacks, or validation for scenarios that can't happen. Trust internal code and framework guarantees. Only validate at system boundaries (user input, external APIs). Don't use feature flags or backwards-compatibility shims when you can just change the code.
  - Don't create helpers, utilities, or abstractions for one-time operations. Don't design for hypothetical future requirements. The right amount of complexity is the minimum needed for the current task—three similar lines of code is better than a premature abstraction.

