require "json"

module Qdrant::Api
  class Livez
    def initialize(@conn : Connection); end

    # Kubernetes livez endpoint Kubernetes liveness probe. Returns 200 as soon as the HTTP API is serving requests. It does not inspect collections, shards or consensus state, and is identical to &#x60;/healthz&#x60;. A failure indicates the process is unresponsive and should be restarted.
    def list : Response(String)
      @conn.request(String,
        method: :GET,
        path: "/livez",
        accept: %w[text/plain],
        raw: true,
        auth: %w[api-key bearerAuth])
    end
  end
end
