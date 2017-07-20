import os
def is_executable(f_path):
    return os.path.isfile(f_path) and os.access(f_path, os.X_OK)