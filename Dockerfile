FROM python:3.13-slim

# Set working directory
WORKDIR /app

# Copy and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY app/ .

# Expose port and start the Flask app
EXPOSE 5000
CMD ["python", "main.py"]
