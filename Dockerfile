FROM node:current-alpine AS base

RUN mkdir /app
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY package.json yarn.lock ./

# Building
FROM base AS builder

RUN yarn install
COPY . .
RUN yarn build

# Release
FROM base AS release

ENV NODE_ENV production
RUN yarn install --prod
COPY --from=builder /app/dist ./dist

CMD ["yarn", "start"]
