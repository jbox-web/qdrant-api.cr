require "json"

module Qdrant::Api
  class Cluster
    def initialize(@conn : Connection); end

    # Tries to recover current peer Raft state.
    def recover : Response(Qdrant::Api::CreateShardKey200Response)
      @conn.request(Qdrant::Api::CreateShardKey200Response,
        method: :POST,
        path: "/cluster/recover",
        accept: %w[application/json],
        auth: %w[api-key bearerAuth])
    end

    # Get cluster status info Get information about the current state and composition of the cluster
    def status : Response(Qdrant::Api::ClusterStatus200Response)
      @conn.request(Qdrant::Api::ClusterStatus200Response,
        method: :GET,
        path: "/cluster",
        accept: %w[application/json],
        auth: %w[api-key bearerAuth])
    end

    # Collect cluster telemetry data Get telemetry data, from the point of view of the cluster. This includes peers info, collections info, shard transfers, and resharding status
    def telemetry(*, details_level : Int32? = nil, timeout : Int32? = nil) : Response(Qdrant::Api::ClusterTelemetry200Response)
      @conn.request(Qdrant::Api::ClusterTelemetry200Response,
        method: :GET,
        path: "/cluster/telemetry",
        query: {"details_level" => details_level, "timeout" => timeout},
        accept: %w[application/json],
        auth: %w[api-key bearerAuth])
    end
  end
end
