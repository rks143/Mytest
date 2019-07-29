## Stage 0, "build-stage", based on Node.js, to build and compile the frontend
#Step 1 We need to specify version of Node as per our requirement.
FROM node:8.9.4 as build-stage


# Create app directory
WORKDIR /app

# Install app dependencies
COPY package.json package-lock.json  /app/
RUN  npm install

# Copy project files into the docker image
COPY .  /app

ARG configuration=production
#RUN npm run build -- --output-path=./dist --configuration $configuration

## Build the angular app in production mode and store the artifacts in dist folder
RUN npm install -g ng-cli
RUN npm run build

# # Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx
FROM nginx:latest

## Create Root folder of nginx Website.
RUN mkdir -p /var/www/vhost/UItestapp.com

## From 'builder' copy website to default nginx public folder
COPY --from=build-stage /app/dist  /var/www/vhost/UItestapp.com/

##Copy the nginx config from root folder to docker image file
COPY  nginx.conf /etc/nginx/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
