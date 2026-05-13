---
name: create-management-command
description: Create a Django management command in `api/apps/<app>/management/commands`, asking for the app name, snake_case command name, brief description, and whether the command performs multiple database writes so `transaction.atomic()` can be used when needed.
---

# Create Management Command

Use this skill when the user asks to create a Django management command.

## Required Inputs

Ask for these if the user has not already provided them:

1. Django app name
2. Command name in `snake_case`
3. Brief description of what the command does
4. Whether the command performs multiple database write operations

## Workflow

1. Inspect the target app for existing management commands and nearby patterns before writing the new file.
2. Create missing package directories under `api/apps/<app>/management/commands/`.
3. Ensure both `management/__init__.py` and `management/commands/__init__.py` exist.
4. Create `api/apps/<app>/management/commands/<command_name>.py`.
5. Include a `--dry-run` flag.
6. Add graceful `Ctrl+C` handling with `signal.signal(signal.SIGINT, self.signal_handler)`.
7. Add counters for `success_count`, `error_count`, and `skipped_count`.
8. Print a summary at the end.
9. If the command performs multiple writes for one item, wrap those writes in `with transaction.atomic():`.
10. Verify with:
   - `docker compose exec api python manage.py <command_name> --help`
   - `docker compose exec api python manage.py <command_name> --dry-run`

## Required Patterns

1. Use `print()` rather than `self.stdout.write()`.
2. Use `tqdm` for item-processing loops so long-running commands show progress clearly.
3. Add `time.sleep(5)` inside the item-processing loop to avoid rate limiting.
4. Wrap item processing in `try/except` so a single failure does not stop the command.
5. Import the models and helpers the command needs at the top of the file.
6. Leave clear `TODO` markers where business logic must be filled in.

## Template Rules

Use this shape when multiple database writes happen per item:

```python
import signal
import sys
import time

from django.core.management.base import BaseCommand
from django.db import transaction
from tqdm import tqdm


class Command(BaseCommand):
    help = "<brief description>"

    def add_arguments(self, parser):
        parser.add_argument(
            "--dry-run",
            action="store_true",
            help="Run in dry-run mode without making actual changes",
        )

    def handle(self, *args, **options):
        signal.signal(signal.SIGINT, self.signal_handler)

        dry_run = options["dry_run"]

        if dry_run:
            print("Running in DRY-RUN mode - no actual changes will be made")

        # TODO: Replace with the real queryset or iterable.
        items = []
        total_count = len(items)
        print(f"Found {total_count} items to process")

        if total_count == 0:
            print("No items to process")
            return

        success_count = 0
        error_count = 0
        skipped_count = 0

        for item in tqdm(items, desc="Processing items"):
            try:
                if dry_run:
                    print(f"[DRY-RUN] Would process item: {item}")
                    success_count += 1
                else:
                    with transaction.atomic():
                        # TODO: Add all DB writes for one item here.
                        pass

                    print(f"Processed item: {item}")
                    success_count += 1
            except Exception as exc:
                error_count += 1
                print(f"Error processing item: {exc}")

            time.sleep(5)

        print("\n" + "=" * 60)
        print("Summary:")
        print(f"Total items: {total_count}")
        print(f"Successfully processed: {success_count}")
        print(f"Errors: {error_count}")
        print(f"Skipped: {skipped_count}")
        print("=" * 60)

        if dry_run:
            print("\nThis was a DRY-RUN. No actual changes were made.")

    def signal_handler(self, sig, frame):
        print("\n\nCommand interrupted. Exiting gracefully...")
        sys.exit(0)
```

Use this shape when the command does not do multiple DB writes per item:

```python
import signal
import sys
import time

from django.core.management.base import BaseCommand
from tqdm import tqdm


class Command(BaseCommand):
    help = "<brief description>"

    def add_arguments(self, parser):
        parser.add_argument(
            "--dry-run",
            action="store_true",
            help="Run in dry-run mode without sending actual notifications",
        )

    def handle(self, *args, **options):
        signal.signal(signal.SIGINT, self.signal_handler)

        dry_run = options["dry_run"]

        if dry_run:
            print("Running in DRY-RUN mode - no actual changes will be made")

        # TODO: Replace with the real queryset or iterable.
        items = []
        total_count = len(items)
        print(f"Found {total_count} items to process")

        if total_count == 0:
            print("No items to process")
            return

        success_count = 0
        error_count = 0
        skipped_count = 0

        for item in tqdm(items, desc="Processing items"):
            try:
                if dry_run:
                    print(f"[DRY-RUN] Would process item: {item}")
                    success_count += 1
                else:
                    # TODO: Add non-transactional processing here.
                    print(f"Processed item: {item}")
                    success_count += 1
            except Exception as exc:
                error_count += 1
                print(f"Error processing item: {exc}")

            time.sleep(5)

        print("\n" + "=" * 60)
        print("Summary:")
        print(f"Total items: {total_count}")
        print(f"Successfully processed: {success_count}")
        print(f"Errors: {error_count}")
        print(f"Skipped: {skipped_count}")
        print("=" * 60)

        if dry_run:
            print("\nThis was a DRY-RUN. No actual changes were made.")

    def signal_handler(self, sig, frame):
        print("\n\nCommand interrupted. Exiting gracefully...")
        sys.exit(0)
```
