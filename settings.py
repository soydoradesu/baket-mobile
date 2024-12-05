INSTALLED_APPS = [
    ...
    'corsheaders',
    ...
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.common.CommonMiddleware',
    # ... other middleware
]

# Add CORS settings
CORS_ORIGIN_ALLOW_ALL = True  # Only for development
CORS_ALLOW_CREDENTIALS = True

CORS_ALLOWED_ORIGINS = [
    "http://localhost:3000",
    "http://127.0.0.1:3000",
    "http://localhost:55625",  # Add your Flutter web port
    "http://127.0.0.1:55625",  # Add your Flutter web port
]

CORS_ALLOW_METHODS = [
    'DELETE',
    'GET',
    'OPTIONS',
    'PATCH',
    'POST',
    'PUT',
]

CORS_ALLOW_HEADERS = [
    'accept',
    'accept-encoding',
    'authorization',
    'content-type',
    'dnt',
    'origin',
    'user-agent',
    'x-csrftoken',
    'x-requested-with',
]

# Additional settings that might help
CORS_EXPOSE_HEADERS = ['*']
CORS_ALLOW_ALL_ORIGINS = True  # Only for development
CORS_ORIGIN_ALLOW_ALL = True   # Only for development
