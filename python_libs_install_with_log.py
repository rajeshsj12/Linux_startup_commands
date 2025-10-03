import subprocess
import sys
import os
from datetime import datetime
import pkg_resources
from pathlib import Path

# File paths for logs and errors
log_file = "installation_logs.txt"
error_file = "installation_errors.txt"

# Comprehensive list of libraries to install (fixed and updated)
libraries = [
    # Web Development
    "django", "flask", "fastapi", "sqlalchemy", "dash", "bokeh", 
    "aiohttp", "requests", "beautifulsoup4", "wtforms", "jinja2", 
    "gunicorn", "uvicorn", "bcrypt", "passlib",

    # Data Science & Machine Learning
    "tensorflow", "numpy", "pandas", "matplotlib", 
    "seaborn", "scikit-learn", "jupyter", "scipy", "statsmodels", 
    "plotly", "nltk", "gensim", "xgboost", "lightgbm", "pycaret", 
    "pyspark", "modin", "dask", "mlflow", "yellowbrick", "optuna", 
    "imbalanced-learn", "catboost", "huggingface-hub", "transformers", "torch", 
    "keras-tuner", "shap",

    # NLP
    "textacy", "flair", "spacy", "sentence-transformers", "pyLDAvis",

    # Excel
    "openpyxl", "xlrd", "xlwt", "xlwings", "pyexcel", 
    "xlsxwriter", "tablib",

    # SQL
    "pymysql", "psycopg2-binary", "pyodbc", "mysql-connector-python", 
    "alembic", "duckdb", "sqlalchemy-migrate", 
    "sqlalchemy-utils",

    # Visualization
    "altair", "folium", "geopandas", "pygal", "holoviews", "plotnine", 
    "mplfinance", "cartopy",

    # Big Data
    "vaex", "apache-airflow", "luigi", 
    "kafka-python", "hdfs3", "spark-nlp",

    # Development Utilities
    "pytest-cov", "black", "autopep8", "flake8", "pylint", "mypy",

    # Specialized
    "shapely", "opencv-python", "moviepy", "pytesseract", 
    "pytest", "pycryptodome", "tqdm",
    
    # Google Cloud (specific packages instead of generic 'google')
    "google-cloud-storage", "google-auth", "google-api-python-client"
]

# Helper function to log messages with error handling
def log_message(message, file_path):
    try:
        # Ensure the directory exists
        Path(file_path).parent.mkdir(parents=True, exist_ok=True)
        with open(file_path, "a", encoding="utf-8") as file:
            file.write(message + "\n")
    except Exception as e:
        print(f"Failed to write to log file {file_path}: {e}")

# Check if a package is already installed
def is_package_installed(package_name):
    try:
        # Handle package names with extras (like package[extra])
        base_package = package_name.split('[')[0]
        pkg_resources.get_distribution(base_package)
        return True
    except pkg_resources.DistributionNotFound:
        return False

# Install each library and log the results
def install_library(library, skip_installed=True):
    if skip_installed and is_package_installed(library):
        skip_message = f"{datetime.now().strftime('%Y-%m-%d %H:%M:%S')} - SKIPPED: {library} is already installed."
        print(skip_message)
        log_message(skip_message, log_file)
        return True
    
    try:
        start_time = datetime.now()
        
        # Use more robust pip installation with timeout
        result = subprocess.run([
            sys.executable, "-m", "pip", "install", library, "--timeout", "300"
        ], capture_output=True, text=True, timeout=360)
        
        duration = datetime.now() - start_time
        
        if result.returncode == 0:
            success_message = f"{datetime.now().strftime('%Y-%m-%d %H:%M:%S')} - SUCCESS: Installed {library} in {duration.total_seconds():.2f} seconds."
            print(success_message)
            log_message(success_message, log_file)
            return True
        else:
            error_message = f"{datetime.now().strftime('%Y-%m-%d %H:%M:%S')} - ERROR: Failed to install {library}. Return code: {result.returncode}"
            if result.stderr:
                error_message += f"\nSTDERR: {result.stderr.strip()}"
            print(error_message)
            log_message(error_message, error_file)
            return False
            
    except subprocess.TimeoutExpired:
        error_message = f"{datetime.now().strftime('%Y-%m-%d %H:%M:%S')} - ERROR: Installation of {library} timed out after 6 minutes."
        print(error_message)
        log_message(error_message, error_file)
        return False
    except Exception as e:
        error_message = f"{datetime.now().strftime('%Y-%m-%d %H:%M:%S')} - ERROR: Failed to install {library}. Error: {e}"
        print(error_message)
        log_message(error_message, error_file)
        return False

# Clear previous logs safely
def clear_logs():
    try:
        with open(log_file, "w", encoding="utf-8") as f:
            f.write(f"Installation started at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
        with open(error_file, "w", encoding="utf-8") as f:
            f.write(f"Error log started at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
    except Exception as e:
        print(f"Warning: Could not clear log files: {e}")

# Main installation function
def main():
    print("Python Package Mass Installer")
    print("=" * 50)
    
    # Check Python version
    python_version = sys.version_info
    if python_version < (3, 7):
        print("Warning: Python 3.7+ is recommended for compatibility with all packages.")
    
    # Clear previous logs
    clear_logs()
    
    # Start installation
    total_libraries = len(libraries)
    successful_installs = 0
    failed_installs = 0
    skipped_installs = 0
    
    print(f"Starting installation of {total_libraries} libraries...")
    print(f"Logs will be saved to: {os.path.abspath(log_file)}")
    print(f"Errors will be saved to: {os.path.abspath(error_file)}")
    print("-" * 50)
    
    for i, lib in enumerate(libraries, 1):
        print(f"\n[{i}/{total_libraries}] Processing {lib}...")
        
        if is_package_installed(lib):
            print(f"✓ {lib} is already installed - skipping")
            skipped_installs += 1
            skip_message = f"{datetime.now().strftime('%Y-%m-%d %H:%M:%S')} - SKIPPED: {lib} is already installed."
            log_message(skip_message, log_file)
        else:
            success = install_library(lib, skip_installed=False)
            if success:
                successful_installs += 1
                print(f"✓ {lib} installed successfully")
            else:
                failed_installs += 1
                print(f"✗ {lib} failed to install")
    
    # Final summary
    print("\n" + "=" * 50)
    print("Installation Summary:")
    print(f"Total libraries processed: {total_libraries}")
    print(f"Successfully installed: {successful_installs}")
    print(f"Already installed (skipped): {skipped_installs}")
    print(f"Failed installations: {failed_installs}")
    print(f"Success rate: {((successful_installs + skipped_installs) / total_libraries) * 100:.1f}%")
    print(f"\nDetailed logs: {os.path.abspath(log_file)}")
    if failed_installs > 0:
        print(f"Error details: {os.path.abspath(error_file)}")
    
    # Log final summary
    summary_message = f"""
Installation completed at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
Total: {total_libraries}, Successful: {successful_installs}, Skipped: {skipped_installs}, Failed: {failed_installs}
Success rate: {((successful_installs + skipped_installs) / total_libraries) * 100:.1f}%
"""
    log_message(summary_message, log_file)

if __name__ == "__main__":
    main()
