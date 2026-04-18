FROM postgres:17-alpine AS builder

RUN apk add --no-cache \
  --repository=http://alpinelinux.org \
  --repository=http://alpinelinux.org \
  postgresql-dev make gcc libc-dev git clang19 llvm19-dev llvm19

RUN git clone https://github.com/sraoss/pg_ivm.git /tmp/pg_ivm \
  && cd /tmp/pg_ivm \
  && make install

FROM postgres:17-alpine

COPY --from=builder /usr/local/lib/postgresql/pg_ivm.so /usr/local/lib/postgresql/
COPY --from=builder /usr/local/share/postgresql/extension/pg_ivm* /usr/local/share/postgresql/extension/
COPY --from=builder /usr/local/lib/postgresql/bitcode/pg_ivm* /usr/local/lib/postgresql/bitcode/
COPY --from=builder /usr/local/lib/postgresql/bitcode/pg_ivm /usr/local/lib/postgresql/bitcode/pg_ivm

RUN apk add --no-cache \
  --repository=http://alpinelinux.org \
  --repository=http://alpinelinux.org \
  llvm19-libs
