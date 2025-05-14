#!/bin/bash

JUPYTER_CONFIG_DIR="$HOME/.jupyter/nbconfig"
CONFIG_FILE="$JUPYTER_CONFIG_DIR/notebook.json"
VENV_PATH="/media/rajesh/Rajesh/SQL/ubuntu_env/bin"

function update_system() {
    echo "🔄 Updating system..."
    sudo apt update && sudo apt upgrade -y
    echo "✅ System updated!"
}

function install_python() {
    echo "🔍 Checking Python installation..."
    if ! command -v python3 &> /dev/null; then
        echo "⚠️ Python is NOT installed! Installing..."
        sudo apt install python3 -y
        echo "✅ Python installed!"
    else
        echo "✅ Python is already installed!"
    fi
}

function activate_venv() {
    echo "🔄 Activating Python virtual environment..."
    source "$VENV_PATH/activate"
    echo "✅ Virtual environment activated!"
}

function install_jupyter() {
    echo "🔍 Checking Jupyter Notebook installation..."
    if ! command -v jupyter &> /dev/null; then
        echo "⚠️ Jupyter Notebook is NOT installed! Installing..."
        pip install jupyter
        echo "✅ Jupyter Notebook installed!"
    else
        echo "✅ Jupyter Notebook is already installed!"
    fi
}

function install_libs() {
    echo "🔄 Checking and installing required Python libraries..."
    pip install ipython-sql mysql-connector-python pymysql pandas
    echo "✅ Required libraries installed!"
}

function enable_sql_magic() {
    echo "✅ Enabling auto %%sql insertion..."
    mkdir -p "$JUPYTER_CONFIG_DIR"
    cat <<EOF > "$CONFIG_FILE"
{
    "CodeCell": {
        "cm_config": {
            "value": "%%sql"
        }
    }
}
EOF
    echo "🟢 Auto %%sql insertion is now ENABLED!"
}

function disable_sql_magic() {
    echo "🚫 Disabling auto %%sql insertion..."
    if [ -f "$CONFIG_FILE" ]; then
        rm "$CONFIG_FILE"
        echo "🔴 Auto %%sql insertion is now DISABLED!"
    else
        echo "⚠️ No configuration file found. Already disabled."
    fi
}

function auto_fix() {
    echo "🔄 Running automatic fixes..."
    
    echo "🔍 Checking if Jupyter can start..."
    if ! jupyter notebook --version &> /dev/null; then
        echo "⚠️ Jupyter Notebook is broken. Reinstalling..."
        pip install --force-reinstall jupyter notebook
        echo "✅ Jupyter Notebook reinstalled!"
    fi

    echo "🔍 Checking virtual environment..."
    if [ ! -f "$VENV_PATH/activate" ]; then
        echo "⚠️ Virtual environment not found! You may need to recreate it."
    else
        echo "✅ Virtual environment is properly configured!"
    fi

    echo "🔄 Fixing common Python package issues..."
    pip check || pip install --upgrade --force-reinstall ipython-sql pymysql pandas

    echo "✅ Automatic fixes completed!"
}

function start_mysql() {
    echo "🚀 Starting MySQL service..."
    sudo systemctl start mysql
    echo "✅ MySQL started!"
}

function stop_mysql() {
    echo "🛑 Stopping MySQL service..."
    sudo systemctl stop mysql
    echo "✅ MySQL stopped!"
}

echo "📌 Choose what you want to do:"
echo "1️⃣ Update system (apt update && apt upgrade)"
echo "2️⃣ Install Python (if missing)"
echo "3️⃣ Activate Python virtual environment"
echo "4️⃣ Install Jupyter Notebook (if missing)"
echo "5️⃣ Check and install required libraries"
echo "6️⃣ Enable auto %%sql insertion"
echo "7️⃣ Disable auto %%sql insertion"
echo "8️⃣ Run automatic fixes"
echo "9️⃣ Start MySQL"
echo "🔟 Stop MySQL"
echo "0️⃣ Exit"

read -p "🎯 Enter your choice: " choice

case $choice in
    1) update_system ;;
    2) install_python ;;
    3) activate_venv ;;
    4) install_jupyter ;;
    5) install_libs ;;
    6) enable_sql_magic ;;
    7) disable_sql_magic ;;
    8) auto_fix ;;
    9) start_mysql ;;
    10) stop_mysql ;;
    0) echo "🚀 Exiting..." ;;
    *) echo "❌ Invalid option! Please choose a valid number." ;;
esac

