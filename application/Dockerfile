# Example Root Dockerfile, this can be multistage and whatever, this time we build anode8 application
FROM ckleinhuis/ufp-sidt-example-app-server-dependencies:6
EXPOSE 3000

# Register search path of installed app node modules
ENV PATH ${PATH}:/application/node_modules/.bin
# Copy the Application data
COPY ./server /application

WORKDIR /application

# Create Swagger apidoc
RUN npm run swagger

CMD ["npm","run","app"]

