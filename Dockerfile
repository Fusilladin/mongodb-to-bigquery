
# Use a base image with Python pre-installed
FROM python:3.11.2

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    gnupg \
    lsb-release \
    openssh-client \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Add Google Cloud SDK distribution URI as a package source and install it
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
    && apt-get update \
    && apt-get install -y google-cloud-sdk

# Install Python packages
RUN pip install functions-framework==3.5.0
RUN pip install pymongo==4.6.3
RUN pip install google-cloud-storage==2.16.0
RUN pip install google-cloud-bigquery==3.20.1
RUN pip install Flask==3.0.3
RUN pip install pandas==2.2.2
RUN pip install pyarrow==15.0.2
RUN pip install pandas-gbq==0.22.0

# Configure gcloud (dummy configuration for Dockerfile)
RUN gcloud config set core/disable_usage_reporting true \
    && gcloud config set component_manager/disable_update_check true \
    && gcloud config set metrics/environment github_docker_image

# Install git if not already installed, useful for debugging
RUN apt-get update && apt-get install -y git

# Attempt to fetch from GitHub directly using curl for testing connectivity and DNS resolution
RUN curl -L https://github.com/Fusilladin/mongodb-to-bigquery.git > /dev/null

# Clone the specific repository containing the Python script
RUN git clone https://github.com/Fusilladin/mongodb-to-bigquery.git /app


# Set the working directory to the repository folder
WORKDIR /app

# Expose port for Flask app
EXPOSE 8080

# Define the command to run your application
CMD ["python", "main.py"]
