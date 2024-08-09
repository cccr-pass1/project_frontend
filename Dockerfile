# Production stage
FROM nginx:stable-alpine

# Copy pre-built app
COPY build /usr/share/nginx/html

# Copy custom Nginx config if you have one
# COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]