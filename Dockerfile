# Use official Python image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Copy project files
COPY . /app

# Install dependencies
RUN pip install --upgrade pip && pip install -r requirements.txt

# Expose port
EXPOSE 8000

# Start FastAPI application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

