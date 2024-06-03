FROM oven/bun:1-alpine as base
WORKDIR /app

# install dependencies into temp directory
# this will cache them and speed up future builds
FROM base AS install
COPY package.json bun.lockb ./
RUN bun install --frozen-lockfile

ENV NODE_ENV=production

COPY src/ ./src

RUN bun run build
RUN chmod +x dist/hori

# copy production dependencies and source code into final image
FROM base AS release
#RUN addgroup -S hori && adduser -S hori -G hori

COPY --from=install --chown=bun /app/dist/ .
# run the app
USER bun
EXPOSE 80/tcp
ENTRYPOINT [ "/app/hori" ]
