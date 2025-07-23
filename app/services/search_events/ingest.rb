module SearchEvents
  class Ingest
    def self.call(session:, payload:)
      return if payload.query.blank?
      # NOTE: Non-final keystroke events could be buffered in an in-memory or ephemeral store
      # (e.g., Redis with a TTL, Kafka/Redpanda stream, etc.) for UX analytics, instead of
      # persisting every raw event in Postgres and bloating the primary database.
      if payload.final
        event = session.search_events.create!(
          query: payload.query,
          typed_at: payload.typed_at,
          request_id: SecureRandom.uuid,
          )

        SearchTermCompressor.new(session).ingest!(event)
      end
    end
  end
end
