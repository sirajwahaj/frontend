# Use a smaller Node.js image for the base
FROM node:slim as build

# Set the working directory in the container
WORKDIR /var/www/todo-frontend

# Copy package.json and package-lock.json (if available) to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Build the application
RUN npm run build

# Use an Nginx image for serving the built files
FROM nginx:alpine

# Copy the built files from the previous stage to the Nginx HTML directory
COPY --from=build /var/www/todo-frontend/build /usr/share/nginx/html

# Expose the port the app runs on
EXPOSE 80

# Command to run the application
CMD ["nginx", "-g", "daemon off;"]
