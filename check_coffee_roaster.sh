#!/bin/bash

# 🚩 1. Set paths and site name
BENCH_DIR=~/coffee_bench
SITE_NAME=coffeesite.local
APP_NAME=coffee_roaster

echo "🔍 Navigating to Bench Directory: $BENCH_DIR"
cd "$BENCH_DIR" || { echo "❌ Bench directory not found!"; exit 1; }

# 🚩 2. Activate virtual environment
if [ -f env/bin/activate ]; then
    echo "✅ Activating virtual environment..."
    source env/bin/activate
else
    echo "❌ Virtual environment not found at env/bin/activate"
    exit 1
fi

# 🚩 3. Check correct bench path
BENCH_EXEC=env/bin/bench
if [ ! -f "$BENCH_EXEC" ]; then
    echo "❌ bench not found at $BENCH_EXEC"
    exit 1
fi

# 🚩 4. Show bench version
echo "🛠️ Bench version:"
$BENCH_EXEC --version

# 🚩 5. Show apps in apps.txt
echo "📦 Apps listed in sites/apps.txt:"
cat sites/apps.txt

# 🚩 6. Check if $APP_NAME is in apps.txt, add if missing
grep -qxF "$APP_NAME" sites/apps.txt || {
    echo "⚠️ $APP_NAME not found in apps.txt — adding..."
    echo "$APP_NAME" >> sites/apps.txt
}

# 🚩 7. List installed apps on site
echo "📡 Installed apps on site $SITE_NAME:"
$BENCH_EXEC --site "$SITE_NAME" list-apps

# 🚩 8. Check if app is installed, install if missing
if ! $BENCH_EXEC --site "$SITE_NAME" list-apps | grep -q "$APP_NAME"; then
    echo "🧩 Installing app $APP_NAME on site $SITE_NAME..."
    $BENCH_EXEC --site "$SITE_NAME" install-app "$APP_NAME"
else
    echo "✅ $APP_NAME is already installed on $SITE_NAME"
fi

# 🚩 9. Validate app folder structure
APP_PATH=$BENCH_DIR/apps/$APP_NAME
echo "📁 Checking structure of $APP_PATH..."

if [ -d "$APP_PATH/$APP_NAME" ]; then
    echo "✅ Found main module folder: $APP_PATH/$APP_NAME"
else
    echo "❌ Missing expected module folder: $APP_PATH/$APP_NAME"
    exit 1
fi

# 🚩 10. Reinstall app editable mode (optional refresh)
echo "♻️ Reinstalling app $APP_NAME in editable mode..."
pip install -e apps/"$APP_NAME"

echo "✅ All checks completed. $APP_NAME is properly set up on $SITE_NAME."
