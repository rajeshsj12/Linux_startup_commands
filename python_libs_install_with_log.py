import subprocess
import sys
from datetime import datetime

# File paths for logs and errors
log_file = "installation_logs.txt"
error_file = "installation_errors.txt"

# Comprehensive list of libraries to install
libraries = [
    # Web Development
    "django", "flask", "fastapi", "sqlalchemy", "dash", "bokeh", 
    "aiohttp", "requests", "beautifulsoup4", "wtforms", 

    # Data Science & Machine Learning
    "tensorflow", "keras", "google", "numpy", "pandas", "matplotlib", 
    "seaborn", "scikit-learn", "jupyter", "scipy", "statsmodels", 
    "plotly", "nltk", "gensim", "xgboost", "lightgbm", "pycaret", 
    "pyspark", "modin", "dask", "mlflow", "yellowbrick", "optuna", 
    "imblearn", "catboost", "huggingface-hub", 

    # NLP
    "textacy", "flair", "spacy", "sentence-transformers", "pyLDAvis", 

    # Excel
    "openpyxl", "xlrd", "xlwt", "xlwings", "pyexcel", 
    "xlsxwriter", "pyexcel-xlsxw", "ezodf", "tablib", "pyxlsb",

    # SQL
    "pymysql", "psycopg2", "sqlite3", "pyodbc", "mysql-connector-python", 
    "alembic", "duckdb", "supersqlite",

    # Visualization
    "altair", "folium", "geopandas", "pygal", "holoviews", "ggplot",

    # Big Data
    "vaex", "koalas",

    # Specialized
    "shapely", "opencv-python", "moviepy", "pytesseract", 
    "pytest", "pycryptodome", "tqdm"
]

# Helper function to log messages
def log_message(message, file_path):
    with open(file_path, "a") as file:
        file.write(message + "\n")

# Install each library and log the results
def install_library(library):
    try:
        start_time = datetime.now()
        subprocess.check_call([sys.executable, "-m", "pip", "install", library])
        duration = datetime.now() - start_time
        success_message = f"{datetime.now()} - SUCCESS: Installed {library} in {duration} seconds."
        print(success_message)
        log_message(success_message, log_file)
    except Exception as e:
        error_message = f"{datetime.now()} - ERROR: Failed to install {library}. Error: {e}"
        print(error_message)
        log_message(error_message, error_file)

# Clear previous logs
open(log_file, "w").close()
open(error_file, "w").close()

# Start installation
print("Starting the installation of libraries...")
for lib in libraries:
    install_library(lib)

print(f"Installation completed! Logs are saved in '{log_file}' and errors in '{error_file}'.")
