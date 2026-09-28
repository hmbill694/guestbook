# syntax=docker/dockerfile:1@sha256:ecfaec9ed6d810b56388c508f4121597bfbba70d41a6dfeee4d8cad5f295fc32

# This is the Node that SHIPS — independent of the dev toolchain in devenv.nix
# and of package.json `engines`. Renovate bumps the tag and maintains the digest.
FROM node:24-bookworm-slim@sha256:0e0ff40c39bc087845bfb27465a0df4ea419520094bc35842ff83dd8cbe6f9b6 AS deps
WORKDIR /src
COPY package.json package-lock.json ./
RUN --mount=type=cache,target=/root/.npm npm ci

FROM deps AS builder
COPY . .
RUN npm run build
RUN --mount=type=cache,target=/root/.npm npm ci --omit=dev --ignore-scripts
# distroless has no shell, so the volume mount point is created here.
RUN mkdir -p /out/data

FROM gcr.io/distroless/nodejs24-debian12:nonroot@sha256:14d42e2511532589a7c7e01a753667a74fcc96266e137e8125006b87b0c32d0a
WORKDIR /app
COPY --from=builder /src/node_modules ./node_modules
COPY --from=builder /src/dist ./dist
COPY --from=builder /src/package.json ./package.json
COPY --from=builder --chown=nonroot:nonroot /out/data /data
ARG VERSION=0.0.0-dev
ENV APP_VERSION=${VERSION} \
    HOST=0.0.0.0 \
    PORT=4321 \
    DB_PATH=/data/guestbook.db
USER nonroot
VOLUME /data
EXPOSE 4321
CMD ["dist/server/entry.mjs"]
