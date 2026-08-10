require "json"

module Qdrant::Api
  class Quotas
    def initialize(@conn : Connection); end

    # Set global quotas Replace the cluster-wide resource quota configuration. The new configuration is propagated to every peer through consensus and persisted, so it survives restarts
    def bulk_update(quota_config : Qdrant::Api::QuotaConfig? = nil, *, wait : Bool? = nil) : Response(Qdrant::Api::CreateShardKey200Response)
      @conn.request(Qdrant::Api::CreateShardKey200Response,
        method: :PUT,
        path: "/quotas",
        body: quota_config,
        query: {"wait" => wait},
        accept: %w[application/json],
        content_type: %w[application/json],
        auth: %w[api-key bearerAuth])
    end

    # Get global quotas Get the cluster-wide resource quota configuration, together with the current utilization it is measured against. The configuration is the same on every peer, but the reported utilization is for the node serving this request only - memory and disk are node-local, so query each peer to see where the whole cluster stands.
    def list : Response(Qdrant::Api::GetQuotas200Response)
      @conn.request(Qdrant::Api::GetQuotas200Response,
        method: :GET,
        path: "/quotas",
        accept: %w[application/json],
        auth: %w[api-key bearerAuth])
    end
  end
end
