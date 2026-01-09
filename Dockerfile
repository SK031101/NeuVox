# Stage 1: Build the Flutter Web Application
FROM ubuntu:latest AS build-env

# Install prerequisites
RUN apt-get update && apt-get install -y curl git unzip

# Define variables
ARG FLUTTER_SDK=/usr/local/flutter
ARG FLUTTER_VERSION=3.27.0
ARG APP=/app/

# Clone Flutter
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_SDK
RUN cd $FLUTTER_SDK && git checkout stable

# Setup path
ENV PATH="$FLUTTER_SDK/bin:$FLUTTER_SDK/bin/cache/dart-sdk/bin:${PATH}"

# Create app directory
WORKDIR $APP

# Copy pubspec files first for better caching
COPY pubspec.yaml pubspec.lock ./

# Get dependencies
RUN flutter pub get

# Copy the rest of the code
COPY . .

# Build for web
RUN flutter build web --release

# Stage 2: Serve with Nginx
FROM nginx:1.25-alpine

# Copy build artifacts from previous stage
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
