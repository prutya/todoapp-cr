module App
  module Handlers
    # NOTE: Measures request time and logs it's properties in a format similar
    # to NGINX.
    class Timing < Base
      def call(ctx : HTTP::Server::Context)
        log.info("#{ctx.store.id}: #{ctx.request.remote_address} - \
          [#{Time.utc.to_rfc3339}] \
          \"#{ctx.request.method} #{ctx.request.path} #{ctx.request.version}\" \
          #{ctx.request.headers["Referer"]?} \
          #{ctx.request.headers["User-Agent"]?}"
        )

        elapsed = Time.measure do
          call_next(ctx)
        end

        log.info("#{ctx.store.id}: #{ctx.response.status.value} \
          #{ctx.response.headers["Content-Length"]?} \
          #{elapsed.total_seconds.humanize(precision: 2, significant: false)}s"
        )
      end
    end
  end
end
