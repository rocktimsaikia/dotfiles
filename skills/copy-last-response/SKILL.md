---
name: copy-last-response
description: Copy the verbatim text of your most recent assistant response to the system clipboard via xclip on Linux and pbcopy on macOS.
---

# Copy last response

Use this skill when the user asks to copy your previous reply to the clipboard (e.g. "copy that", "put your last response on the clipboard").

## What "last response" means

The exact, character-for-character text of your immediately preceding assistant message — the one shown to the user right before this skill was invoked. Not the message containing the `/copy-last-response` invocation itself, and not any earlier message.

If there is no prior assistant message in this conversation, say so and stop.

## Rules

1. Do not paraphrase, summarize, reformat, translate, or strip markdown. Preserve every character, including code fences, indentation, and trailing newlines.
2. Pick the clipboard tool by OS:
   - macOS (`uname` is `Darwin`): `pbcopy`
   - Linux (`uname` is `Linux`): `xclip -selection clipboard`
3. Pipe the response text into the chosen tool with a quoted heredoc so nothing is expanded. Use a unique delimiter that cannot appear in the text:
   ```bash
   if [ "$(uname)" = "Darwin" ]; then CLIP=pbcopy
   else CLIP="xclip -selection clipboard"
   fi
   $CLIP <<'__COPY_LAST_RESPONSE_EOF__'
   <paste verbatim previous assistant response here>
   __COPY_LAST_RESPONSE_EOF__
   ```
4. If the previous response actually contains the literal string `__COPY_LAST_RESPONSE_EOF__`, switch to a different unique delimiter (append a random suffix).
5. After the command succeeds, reply with a single short line: `Copied last response to clipboard (<N> chars).`
6. If the chosen tool is missing (`pbcopy` not found on macOS, or `xclip` not installed on Linux), report that and stop — do not attempt to install it.

## Notes

- The text comes from your transcript memory, not from a file or stdin. There is nothing to read first.
- Run only the heredoc command — do not echo the response back to the user in chat output.
