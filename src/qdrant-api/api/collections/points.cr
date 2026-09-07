require "json"

module Qdrant::Api
  class Collections::Points
    def initialize(@conn : Connection); end

    # Batch update points Apply a series of update operations for points, vectors and payloads
    def batch(collection_name : String, update_operations : Qdrant::Api::UpdateOperations? = nil, *, wait : Bool? = nil, ordering : Qdrant::Api::WriteOrdering? = nil, timeout : Int32? = nil) : Response(Qdrant::Api::BatchUpdate200Response)
      @conn.request(Qdrant::Api::BatchUpdate200Response,
        method: :POST,
        path: "/collections/{collection_name}/points/batch".sub("{collection_name}", Qdrant::Api.enc(collection_name)),
        body: update_operations,
        query: {"wait" => wait, "ordering" => ordering, "timeout" => timeout},
        accept: %w[application/json],
        content_type: %w[application/json],
        auth: %w[api-key bearerAuth])
    end

    # Upsert points Perform insert + updates on points. If point with given ID already exists - it will be overwritten.
    def bulk_update(collection_name : String, point_insert_operations : Qdrant::Api::PointInsertOperations? = nil, *, wait : Bool? = nil, ordering : Qdrant::Api::WriteOrdering? = nil, timeout : Int32? = nil) : Response(Qdrant::Api::CreateFieldIndex200Response)
      @conn.request(Qdrant::Api::CreateFieldIndex200Response,
        method: :PUT,
        path: "/collections/{collection_name}/points".sub("{collection_name}", Qdrant::Api.enc(collection_name)),
        body: point_insert_operations,
        query: {"wait" => wait, "ordering" => ordering, "timeout" => timeout},
        accept: %w[application/json],
        content_type: %w[application/json],
        auth: %w[api-key bearerAuth])
    end

    # Count points Count points which matches given filtering condition
    def count(collection_name : String, count_request : Qdrant::Api::CountRequest? = nil, *, consistency : Qdrant::Api::ReadConsistency? = nil, timeout : Int32? = nil) : Response(Qdrant::Api::CountPoints200Response)
      @conn.request(Qdrant::Api::CountPoints200Response,
        method: :POST,
        path: "/collections/{collection_name}/points/count".sub("{collection_name}", Qdrant::Api.enc(collection_name)),
        body: count_request,
        query: {"consistency" => consistency, "timeout" => timeout},
        accept: %w[application/json],
        content_type: %w[application/json],
        auth: %w[api-key bearerAuth])
    end

    # Get points Retrieve multiple points by specified IDs
    def create(collection_name : String, point_request : Qdrant::Api::PointRequest? = nil, *, consistency : Qdrant::Api::ReadConsistency? = nil, timeout : Int32? = nil) : Response(Qdrant::Api::GetPoints200Response)
      @conn.request(Qdrant::Api::GetPoints200Response,
        method: :POST,
        path: "/collections/{collection_name}/points".sub("{collection_name}", Qdrant::Api.enc(collection_name)),
        body: point_request,
        query: {"consistency" => consistency, "timeout" => timeout},
        accept: %w[application/json],
        content_type: %w[application/json],
        auth: %w[api-key bearerAuth])
    end

    # Delete points Delete points
    def delete(collection_name : String, points_selector : Qdrant::Api::PointsSelector? = nil, *, wait : Bool? = nil, ordering : Qdrant::Api::WriteOrdering? = nil, timeout : Int32? = nil) : Response(Qdrant::Api::CreateFieldIndex200Response)
      @conn.request(Qdrant::Api::CreateFieldIndex200Response,
        method: :POST,
        path: "/collections/{collection_name}/points/delete".sub("{collection_name}", Qdrant::Api.enc(collection_name)),
        body: points_selector,
        query: {"wait" => wait, "ordering" => ordering, "timeout" => timeout},
        accept: %w[application/json],
        content_type: %w[application/json],
        auth: %w[api-key bearerAuth])
    end

    # Get point Retrieve full information of single point by id
    def get(collection_name : String, id : Qdrant::Api::ExtendedPointId, *, consistency : Qdrant::Api::ReadConsistency? = nil, timeout : Int32? = nil) : Response(Qdrant::Api::GetPoint200Response)
      @conn.request(Qdrant::Api::GetPoint200Response,
        method: :GET,
        path: "/collections/{collection_name}/points/{id}".sub("{collection_name}", Qdrant::Api.enc(collection_name)).sub("{id}", Qdrant::Api.enc(id)),
        query: {"consistency" => consistency, "timeout" => timeout},
        accept: %w[application/json],
        auth: %w[api-key bearerAuth])
    end

    # Overwrite payload Replace full payload of points with new one
    def payload(collection_name : String, set_payload : Qdrant::Api::SetPayload? = nil, *, wait : Bool? = nil, ordering : Qdrant::Api::WriteOrdering? = nil, timeout : Int32? = nil) : Response(Qdrant::Api::CreateFieldIndex200Response)
      @conn.request(Qdrant::Api::CreateFieldIndex200Response,
        method: :PUT,
        path: "/collections/{collection_name}/points/payload".sub("{collection_name}", Qdrant::Api.enc(collection_name)),
        body: set_payload,
        query: {"wait" => wait, "ordering" => ordering, "timeout" => timeout},
        accept: %w[application/json],
        content_type: %w[application/json],
        auth: %w[api-key bearerAuth])
    end

    # Clear payload Remove all payload for specified points
    def payload_clear(collection_name : String, points_selector : Qdrant::Api::PointsSelector? = nil, *, wait : Bool? = nil, ordering : Qdrant::Api::WriteOrdering? = nil, timeout : Int32? = nil) : Response(Qdrant::Api::CreateFieldIndex200Response)
      @conn.request(Qdrant::Api::CreateFieldIndex200Response,
        method: :POST,
        path: "/collections/{collection_name}/points/payload/clear".sub("{collection_name}", Qdrant::Api.enc(collection_name)),
        body: points_selector,
        query: {"wait" => wait, "ordering" => ordering, "timeout" => timeout},
        accept: %w[application/json],
        content_type: %w[application/json],
        auth: %w[api-key bearerAuth])
    end

    # Delete payload Delete specified key payload for points
    def payload_delete(collection_name : String, delete_payload : Qdrant::Api::DeletePayload? = nil, *, wait : Bool? = nil, ordering : Qdrant::Api::WriteOrdering? = nil, timeout : Int32? = nil) : Response(Qdrant::Api::CreateFieldIndex200Response)
      @conn.request(Qdrant::Api::CreateFieldIndex200Response,
        method: :POST,
        path: "/collections/{collection_name}/points/payload/delete".sub("{collection_name}", Qdrant::Api.enc(collection_name)),
        body: delete_payload,
        query: {"wait" => wait, "ordering" => ordering, "timeout" => timeout},
        accept: %w[application/json],
        content_type: %w[application/json],
        auth: %w[api-key bearerAuth])
    end

    # Set payload Set payload values for points
    def payload_post(collection_name : String, set_payload : Qdrant::Api::SetPayload? = nil, *, wait : Bool? = nil, ordering : Qdrant::Api::WriteOrdering? = nil, timeout : Int32? = nil) : Response(Qdrant::Api::CreateFieldIndex200Response)
      @conn.request(Qdrant::Api::CreateFieldIndex200Response,
        method: :POST,
        path: "/collections/{collection_name}/points/payload".sub("{collection_name}", Qdrant::Api.enc(collection_name)),
        body: set_payload,
        query: {"wait" => wait, "ordering" => ordering, "timeout" => timeout},
        accept: %w[application/json],
        content_type: %w[application/json],
        auth: %w[api-key bearerAuth])
    end

    # Query points Universally query points. This endpoint covers all capabilities of search, recommend, discover, filters. But also enables hybrid and multi-stage queries.
    def query(collection_name : String, query_request : Qdrant::Api::QueryRequest? = nil, *, consistency : Qdrant::Api::ReadConsistency? = nil, timeout : Int32? = nil) : Response(Qdrant::Api::QueryPoints200Response)
      @conn.request(Qdrant::Api::QueryPoints200Response,
        method: :POST,
        path: "/collections/{collection_name}/points/query".sub("{collection_name}", Qdrant::Api.enc(collection_name)),
        body: query_request,
        query: {"consistency" => consistency, "timeout" => timeout},
        accept: %w[application/json],
        content_type: %w[application/json],
        auth: %w[api-key bearerAuth])
    end

    # Query points in batch Universally query points in batch. This endpoint covers all capabilities of search, recommend, discover, filters. But also enables hybrid and multi-stage queries.
    def query_batch(collection_name : String, query_request_batch : Qdrant::Api::QueryRequestBatch? = nil, *, consistency : Qdrant::Api::ReadConsistency? = nil, timeout : Int32? = nil) : Response(Qdrant::Api::QueryBatchPoints200Response)
      @conn.request(Qdrant::Api::QueryBatchPoints200Response,
        method: :POST,
        path: "/collections/{collection_name}/points/query/batch".sub("{collection_name}", Qdrant::Api.enc(collection_name)),
        body: query_request_batch,
        query: {"consistency" => consistency, "timeout" => timeout},
        accept: %w[application/json],
        content_type: %w[application/json],
        auth: %w[api-key bearerAuth])
    end

    # Query points, grouped by a given payload field Universally query points, grouped by a given payload field
    def query_groups(collection_name : String, query_groups_request : Qdrant::Api::QueryGroupsRequest? = nil, *, consistency : Qdrant::Api::ReadConsistency? = nil, timeout : Int32? = nil) : Response(Qdrant::Api::QueryPointsGroups200Response)
      @conn.request(Qdrant::Api::QueryPointsGroups200Response,
        method: :POST,
        path: "/collections/{collection_name}/points/query/groups".sub("{collection_name}", Qdrant::Api.enc(collection_name)),
        body: query_groups_request,
        query: {"consistency" => consistency, "timeout" => timeout},
        accept: %w[application/json],
        content_type: %w[application/json],
        auth: %w[api-key bearerAuth])
    end

    # Scroll points Scroll request - paginate over all points which matches given filtering condition
    def scroll(collection_name : String, scroll_request : Qdrant::Api::ScrollRequest? = nil, *, consistency : Qdrant::Api::ReadConsistency? = nil, timeout : Int32? = nil) : Response(Qdrant::Api::ScrollPoints200Response)
      @conn.request(Qdrant::Api::ScrollPoints200Response,
        method: :POST,
        path: "/collections/{collection_name}/points/scroll".sub("{collection_name}", Qdrant::Api.enc(collection_name)),
        body: scroll_request,
        query: {"consistency" => consistency, "timeout" => timeout},
        accept: %w[application/json],
        content_type: %w[application/json],
        auth: %w[api-key bearerAuth])
    end

    # Search points matrix distance offsets Compute distance matrix for sampled points with an offset based output format
    def search_matrix_offsets(collection_name : String, search_matrix_request : Qdrant::Api::SearchMatrixRequest? = nil, *, consistency : Qdrant::Api::ReadConsistency? = nil, timeout : Int32? = nil) : Response(Qdrant::Api::SearchMatrixOffsets200Response)
      @conn.request(Qdrant::Api::SearchMatrixOffsets200Response,
        method: :POST,
        path: "/collections/{collection_name}/points/search/matrix/offsets".sub("{collection_name}", Qdrant::Api.enc(collection_name)),
        body: search_matrix_request,
        query: {"consistency" => consistency, "timeout" => timeout},
        accept: %w[application/json],
        content_type: %w[application/json],
        auth: %w[api-key bearerAuth])
    end

    # Search points matrix distance pairs Compute distance matrix for sampled points with a pair based output format
    def search_matrix_pairs(collection_name : String, search_matrix_request : Qdrant::Api::SearchMatrixRequest? = nil, *, consistency : Qdrant::Api::ReadConsistency? = nil, timeout : Int32? = nil) : Response(Qdrant::Api::SearchMatrixPairs200Response)
      @conn.request(Qdrant::Api::SearchMatrixPairs200Response,
        method: :POST,
        path: "/collections/{collection_name}/points/search/matrix/pairs".sub("{collection_name}", Qdrant::Api.enc(collection_name)),
        body: search_matrix_request,
        query: {"consistency" => consistency, "timeout" => timeout},
        accept: %w[application/json],
        content_type: %w[application/json],
        auth: %w[api-key bearerAuth])
    end

    # Update vectors Update specified named vectors on points, keep unspecified vectors intact.
    def vectors(collection_name : String, update_vectors : Qdrant::Api::UpdateVectors? = nil, *, wait : Bool? = nil, ordering : Qdrant::Api::WriteOrdering? = nil, timeout : Int32? = nil) : Response(Qdrant::Api::CreateFieldIndex200Response)
      @conn.request(Qdrant::Api::CreateFieldIndex200Response,
        method: :PUT,
        path: "/collections/{collection_name}/points/vectors".sub("{collection_name}", Qdrant::Api.enc(collection_name)),
        body: update_vectors,
        query: {"wait" => wait, "ordering" => ordering, "timeout" => timeout},
        accept: %w[application/json],
        content_type: %w[application/json],
        auth: %w[api-key bearerAuth])
    end

    # Delete vectors Delete named vectors from the given points.
    def vectors_delete(collection_name : String, delete_vectors : Qdrant::Api::DeleteVectors? = nil, *, wait : Bool? = nil, ordering : Qdrant::Api::WriteOrdering? = nil, timeout : Int32? = nil) : Response(Qdrant::Api::CreateFieldIndex200Response)
      @conn.request(Qdrant::Api::CreateFieldIndex200Response,
        method: :POST,
        path: "/collections/{collection_name}/points/vectors/delete".sub("{collection_name}", Qdrant::Api.enc(collection_name)),
        body: delete_vectors,
        query: {"wait" => wait, "ordering" => ordering, "timeout" => timeout},
        accept: %w[application/json],
        content_type: %w[application/json],
        auth: %w[api-key bearerAuth])
    end
  end
end
