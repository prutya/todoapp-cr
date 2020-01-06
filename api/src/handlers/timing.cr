module App
  module Handlers
    # NOTE: Measures request time and logs it's properties in a format similar
    # to NGINX.
    class Timing < Base
      HEADER_CONTENT_LENGTH = "Content-Length"
      HEADER_REFERER        = "Referer"
      HEADER_USER_AGENT     = "User-Agent"

      def call(ctx : HTTP::Server::Context)
        log.info("#{ctx.store.id}: #{ctx.request.remote_address} - \
          [#{Time.utc.to_rfc3339}] \
          \"#{ctx.request.method} #{ctx.request.path} #{ctx.request.version}\" \
          #{ctx.request.headers[HEADER_REFERER]?} \
          #{ctx.request.headers[HEADER_USER_AGENT]?}"
        )

        elapsed = Time.measure do
          call_next(ctx)
        end

        log.info("#{ctx.store.id}: #{ctx.response.status.value} \
          #{ctx.response.headers[HEADER_CONTENT_LENGTH]?} \
          #{elapsed.total_seconds.humanize(precision: 2, significant: false)}s"
        )
      end
    end
  end
end
