FROM node:alpine AS build

WORKDIR /home/app

COPY . .

RUN npm install

RUN npm run build

RUN rm -rf node_modules
RUN npm install

FROM node:alpine AS server

WORKDIR /home/app

COPY --from=build /home/app/dist /home/app/api
COPY --from=build /home/app/node_modules /home/app/api/node_modules
COPY --from=build /home/app/tsconfig*.json /home/app/api/tsconfig*.json

EXPOSE 3777

ENV NODE_ENV=development

CMD cd /home/app/api && npm run migration:run && node src/main.js
