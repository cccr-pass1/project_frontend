# Build stage
FROM node:18-alpine AS build

WORKDIR /app

# Add non-root user
RUN addgroup -S app && adduser -S app -G app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm ci

# Copy source files
COPY . .

# Change ownership of the app directory
RUN chown -R app:app /app

# Switch to non-root user
USER app

# Build the application
RUN npm run build

# Production stage
FROM nginx:stable-alpine

# Copy built files from build stage
COPY --from=build /app/build /usr/share/nginx/html

# Copy custom Nginx config if you have one
# COPY nginx.conf /etc/nginx/nginx.conf

# Add non-root user
RUN adduser -D -g 'www' www

# Change ownership of the nginx html directory
RUN chown -R www:www /usr/share/nginx/html

# Switch to non-root user
USER www

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]