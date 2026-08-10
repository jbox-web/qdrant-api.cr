require "json"

module Qdrant::Api
  class Healthz
    def initialize(@conn : Connection); end

    # Kubernetes healthz endpoint Liveness-style health check. Returns 200 as soon as the HTTP API is serving requests. It does not inspect collections, shards or consensus state, and is identical to &#x60;/livez&#x60;. Use it only to detect whether the process is up and responsive.
    def list : Response(String)
      @conn.request(String,
        method: :GET,
        path: "/healthz",
        accept: %w[text/plain],
        raw: true,
        auth: %w[api-key bearerAuth])
    end
  end
end
