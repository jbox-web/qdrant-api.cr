require "json"

module Qdrant::Api
  class Readyz
    def initialize(@conn : Connection); end

    # Kubernetes readyz endpoint Kubernetes readiness probe. Checks the instance and waits out pending data operations to see when it can start accepting traffic. In a distributed deployment it returns 200 only once the node has caught up with the cluster consensus commit and its local shards are healthy; otherwise it returns 503. In a single-node deployment it always returns 200 once the API is up. Use it to decide when to route traffic to the instance.
    def list : Response(String)
      @conn.request(String,
        method: :GET,
        path: "/readyz",
        accept: %w[text/plain],
        raw: true,
        auth: %w[api-key bearerAuth])
    end
  end
end
