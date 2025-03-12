# Build Stage
FROM node:16-alpine as build
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .
RUN npm run build

# Production Stage
FROM alpine:3.12  # Known vulnerable version
LABEL maintainer="sarthak"

# Add an intentionally vulnerable package
RUN apk add --no-cache openssl=1.1.1g-r0  # Vulnerable version of OpenSSL

# Create a security misconfiguration
RUN echo "root::0:0::/:/bin/sh" >> /etc/passwd  # Adds a security risk

# Copy build files
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80

# Start server
CMD ["nginx", "-g", "daemon off;"]
