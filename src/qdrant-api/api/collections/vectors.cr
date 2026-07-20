require "json"

module Qdrant::Api
  class Collections::Vectors
    def initialize(@conn : Connection); end

    # Delete named vector Delete a named vector from a collection
    def delete(collection_name : String, vector_name : String, *, wait : Bool? = nil, ordering : Qdrant::Api::WriteOrdering? = nil, timeout : Int32? = nil) : Response(Qdrant::Api::CreateFieldIndex200Response)
      @conn.request(Qdrant::Api::CreateFieldIndex200Response,
        method: :DELETE,
        path: "/collections/{collection_name}/vectors/{vector_name}".sub("{collection_name}", Qdrant::Api.enc(collection_name)).sub("{vector_name}", Qdrant::Api.enc(vector_name)),
        query: {"wait" => wait, "ordering" => ordering, "timeout" => timeout},
        accept: %w[application/json],
        auth: %w[api-key bearerAuth])
    end

    # Create named vector Create a new named vector on an existing collection
    def update(collection_name : String, vector_name : String, vector_name_config : Qdrant::Api::VectorNameConfig? = nil, *, wait : Bool? = nil, ordering : Qdrant::Api::WriteOrdering? = nil, timeout : Int32? = nil) : Response(Qdrant::Api::CreateFieldIndex200Response)
      @conn.request(Qdrant::Api::CreateFieldIndex200Response,
        method: :PUT,
        path: "/collections/{collection_name}/vectors/{vector_name}".sub("{collection_name}", Qdrant::Api.enc(collection_name)).sub("{vector_name}", Qdrant::Api.enc(vector_name)),
        body: vector_name_config,
        query: {"wait" => wait, "ordering" => ordering, "timeout" => timeout},
        accept: %w[application/json],
        content_type: %w[application/json],
        auth: %w[api-key bearerAuth])
    end
  end
end
