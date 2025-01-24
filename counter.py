import os
import random
from datetime import datetime, timedelta
import holidays

DRY_RUN = False  # Change to False to stop testing

# Dutch holidays
dutch_holidays = holidays.Netherlands()

# File to update
counter_file = "counter.txt"
today = datetime.now()

# Specific dates for testing purposes
# today = datetime(2025, 1, 25)  # Example: A Saturday
# today = datetime(2025, 1, 28)  # Example: A weekday
# today = datetime(2025, 12, 25)  # Example: A holiday

weekday = today.weekday()  # Monday=0, Sunday=6


# Rules
if today in dutch_holidays:
    print("No commits today (Dutch holiday).")
    exit()

if weekday == 5:  # Saturday
    print("No commits on Saturdays.")
    exit()

if weekday == 6:  # Sunday
    # 30% chance to commit on Sundays
    if random.random() > 0.3:
        print("No commits today (Sunday rule).")
        exit()
    commits_today = random.randint(1, 4)
else:
    # Weekdays (Monday-Friday)
    commits_today = random.randint(1, 8)

# Make the specified number of commits
for _ in range(commits_today):
    # Read the current counter
    if not os.path.exists(counter_file):
        with open(counter_file, "w") as f:
            f.write("0\n")

    with open(counter_file, "r") as f:
        count = int(f.read().strip())

    # Increment the counter
    count += 1

    # Update the file
    with open(counter_file, "w") as f:
        f.write(f"{count}\n")



    if DRY_RUN:
        print("[DRY-RUN MODE] No commits will be made.")
        print(f"Would run: git add counter.txt")
        print(f"Would run: git commit -m 'Update counter: {count} at {datetime.now()}'")
        print(f"Would run: git push origin main")
    else:
        os.system("git add counter.txt")
        os.system(f'git commit -m "Update counter: {count} at {datetime.now()}')
        os.system("git push origin main")

    print(f"Today: {today}")
    print(f"Weekday: {weekday} (0=Monday, 6=Sunday)")
    print(f"Holiday: {today in dutch_holidays}")
    print(f"Commits Today: {commits_today if not DRY_RUN else 'DRY-RUN'}")
