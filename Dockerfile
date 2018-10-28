FROM node

COPY app /application

WORKDIR application

RUN npm install


CMD ["node","src/server.js"]

