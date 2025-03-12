# Build Stage
FROM node:16-alpine as build
WORKDIR /app
COPY package.json ./ 
RUN npm install
COPY . .  
RUN npm run build

# Production Stage
FROM nginx:alpine

# Use an older Alpine version with known vulnerabilities
FROM alpine:3.12 

# Intentionally install a vulnerable package
RUN apk add --no-cache curl=7.69.1-r1  # Vulnerable version of curl

# Upgrade a package with known issues
RUN apk --no-cache upgrade libxml2  

# Set up Nginx and copy build files
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
