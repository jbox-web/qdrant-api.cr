require "./spec_helper"

# Hand-maintained smoke test: verifies the generated client wires together.
# Survives regeneration (the `generate` task only wipes generated artifacts).
Spectator.describe Qdrant::Api::Client do
  it "builds a per-instance client with a configured connection" do
    client = Qdrant::Api::Client.new(host: "localhost:6333", scheme: "http")

    expect(client.connection).to be_a(Qdrant::Api::Connection)
    expect(client.connection.config.host).to eq("localhost:6333")
  end

  it "exposes namespaced sub-clients off the facade" do
    client = Qdrant::Api::Client.new(host: "localhost:6333", scheme: "http")

    expect(client.collections).to be_a(Qdrant::Api::Collections)
    expect(client.collections.points).to be_a(Qdrant::Api::Collections::Points)
  end
end
