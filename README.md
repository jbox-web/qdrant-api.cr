# qdrant-api

[![CI](https://github.com/jbox-web/qdrant-api.cr/actions/workflows/ci.yml/badge.svg)](https://github.com/jbox-web/qdrant-api.cr/actions/workflows/ci.yml)
[![Docs](https://github.com/jbox-web/qdrant-api.cr/actions/workflows/docs.yml/badge.svg)](https://jbox-web.github.io/qdrant-api.cr)
[![Release](https://img.shields.io/github/v/release/jbox-web/qdrant-api.cr?include_prereleases&sort=semver)](https://github.com/jbox-web/qdrant-api.cr/releases)
[![Crystal](https://img.shields.io/badge/crystal-%3E%3D%201.18-black?logo=crystal)](https://crystal-lang.org)
[![License](https://img.shields.io/github/license/jbox-web/qdrant-api.cr)](LICENSE)

Low-level [Qdrant](https://qdrant.tech) REST client for Crystal — a per-instance
client with namespaced sub-clients and typed responses, **generated** from Qdrant's
OpenAPI spec via [`openapi-generator`](https://github.com/OpenAPITools/openapi-generator).

> Looking for an idiomatic, RAG-oriented wrapper? Use
> [qdrant-client](https://github.com/jbox-web/qdrant-client.cr) instead. This shard
> is the thin, fully-typed transport layer it builds on.

📖 **[API documentation](https://jbox-web.github.io/qdrant-api.cr)**

## Features

- **Per-instance** `Client.new(host:)` — no global singleton, multiple clients coexist.
- **Namespaced sub-clients** mirroring the API: `client.collections.points.search(...)`.
- **Typed responses**: every call returns a `Response(T)` exposing `value`, `status`,
  `headers` and `success?`.
- Generated from a **pinned Qdrant version** (currently `1.12.0`), committed to the repo.

## Installation

Add the dependency to your `shard.yml`:

```yaml
dependencies:
  qdrant-api:
    github: jbox-web/qdrant-api.cr
```

Then run `shards install`.

## Usage

```crystal
require "qdrant-api"

client = Qdrant::Api::Client.new(host: "localhost:6333", scheme: "http")

# Create a collection (PUT /collections/{name})
client.collections.update(
  "demo",
  Qdrant::Api::CreateCollection.new(
    vectors: Qdrant::Api::VectorsConfig.new(
      Qdrant::Api::VectorParams.new(size: 4, distance: "Dot")
    )
  )
)

# Search (POST /collections/{name}/points/search)
response = client.collections.points.search(
  "demo",
  Qdrant::Api::SearchRequest.new(
    vector: Qdrant::Api::NamedVectorStruct.new([0.2, 0.1, 0.9, 0.7] of Float32),
    limit: 3
  )
)

response.success? # => true
response.status   # => 200
response.value    # => Qdrant::Api::SearchPoints200Response
```

Authenticated instances pass a token:

```crystal
client = Qdrant::Api::Client.new(host: "xyz.cloud.qdrant.io", token: ENV["QDRANT_API_KEY"])
```

## Development

The shard is **generated** — do not edit `src/` by hand. Tooling is [mise](https://mise.jdx.dev):

```sh
mise run build     # regenerate + format against the pinned QDRANT_VERSION
mise run dev:deps  # shards install
mise run dev:spec  # run the spec suite
mise run dev:docs  # generate API docs into ./docs
```

The generator is the idiomatic Crystal client from
[openapi-generator#24070](https://github.com/OpenAPITools/openapi-generator/pull/24070).
Its jar is built from that branch and is **not committed** (CI rebuilds it on
`mise run build`); see `.github/workflows/regenerate.yml`.

## License

MIT — see [LICENSE](LICENSE).
