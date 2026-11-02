# Utopia on Railway: upstream image (deeplethe/utopia v0.1.0-rc9, pinned by digest) + a tiny start wrapper
# that binds Railway's injected PORT (fallback 1516) so the public domain and health check always match.
FROM ghcr.io/deeplethe/utopia:0.1.0-rc9@sha256:9bba072bf510519425c141e71642cdfaf085c2b8dfde2b9c35bb8c6a31b95755
COPY railway/railway-start.sh /usr/local/bin/railway-start.sh
RUN chmod 755 /usr/local/bin/railway-start.sh
# Plain defaults live in the image so the Railway template only carries references.
# UTOPIA_JWT_SECRET / UTOPIA_SECRET_KEY are deliberately NOT set: Utopia generates them on first start
# (JWT secret in the database, sealing key in /app/data/secret.key on the volume).
ENV UTOPIA_WEB_DIST=/app/web-dist \
    UTOPIA_DATA_DIR=/app/data \
    UTOPIA_DB_MAX_CONNECTIONS=32 \
    RUST_LOG=info
EXPOSE 1516
ENTRYPOINT ["/usr/local/bin/railway-start.sh"]
CMD ["utopia-server"]
