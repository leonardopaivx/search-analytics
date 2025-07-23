class SearchTermCompressor
  def initialize(visitor_session)
    @session = visitor_session
  end

  def ingest!(final_event)
    term_text = final_event.query.to_s.strip
    return if term_text.blank?

    now = Time.current

    SearchTerm.transaction do
      term = @session.search_terms.lock('FOR UPDATE').find_by(term: term_text)

      if term
        term.update!(occurences: term.occurences + 1, last_seen_at: now)
      else
        @session.search_terms.create!(
          term: term_text,
          occurences: 1,
          first_seen_at: now,
          last_seen_at: now
        )
      end
    end
  end
end
