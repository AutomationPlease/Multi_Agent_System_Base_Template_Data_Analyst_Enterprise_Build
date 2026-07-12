FROM python:3.14-slim

# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

WORKDIR /app

# Install system dependencies + uv
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir uv

# Copy dependency files first
COPY pyproject.toml uv.lock* ./

# Install dependencies using uv
RUN uv pip install --system --no-cache -r pyproject.toml

# Copy the rest of the application
COPY . .

# Create logs directory and fix permissions
RUN mkdir -p logs/security && \
    chown -R appuser:appuser /app && \
    chmod -R 755 /app

# Switch to non-root user
USER appuser

# Security + performance environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    SECURITY_MODE=strict \
    AGENT_SAFE_ROOT=/app

CMD ["python", "main.py"]
