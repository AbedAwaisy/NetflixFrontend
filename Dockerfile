# Use an official Node.js runtime as the base image
FROM node:14-alpine

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the app
RUN npm run build

# Expose the port the app runs on
EXPOSE 3000

# Set environment variables (this can also be set during container run)
ENV MOVIE_CATALOG_SERVICE=http://localhost:8080

# Command to run the app
CMD ["npm", "start"]
