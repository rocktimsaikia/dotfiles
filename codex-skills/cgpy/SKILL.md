---
name: cgpy
description: Run Python scripts or shell commands inside the Codingal API container with the codingal virtualenv activated.
---

1. Run `source ~/.pyenv/versions/codingal/bin/activate` to activate the virtual environment
2. For script execution, create a Python script in `/api/` directory and run:
   `docker compose exec api python your_script.py`
3. For simple operations, use:
   `docker compose exec api python manage.py shell -c "your_python_code_here"`
4. Now understand and run whatever is being asked. Context: $ARGUMENTS
