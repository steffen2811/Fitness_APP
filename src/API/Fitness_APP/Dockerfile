FROM node:8.12.0
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app
CMD set DEBUG=Fitness_APP:* & npm start
EXPOSE 3333