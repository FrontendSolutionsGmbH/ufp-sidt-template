# Example Root Dockerfile, this can be multistage and whatever, this time we build anode8 application
FROM node:8-slim
EXPOSE 3000

# Register search path of installed app node modules
ENV PATH ${PATH}:/application/node_modules/.bin
# Copy the Application data
COPY . /application

WORKDIR application

# Install dependencies
RUN npm install
# Create Swagger apidoc
RUN npm run swagger


CMD ["npm","run","app"]

