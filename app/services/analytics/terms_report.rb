module Analytics
  class TermsReport
    PERIODS = {
      '24h' => 24.hours,
      '7d'  => 7.days,
      '30d' => 30.days
    }.freeze

    Result = Data.define(:from, :top_terms, :top_visitors, :terms_by_visitor)

    def self.call(period:, limits: {})
      new(period: period, limits: limits).call
    end

    def initialize(period:, limits: {})
      @period = period.to_s
      @limits = {
        terms: 20,
        visitors: 20,
        terms_by_visitor: 50
      }.merge(limits.symbolize_keys)
    end

    def call
      from = window_start

      Result.new(
        from:,
        top_terms: query_top_terms(from),
        top_visitors: query_top_visitors(from),
        terms_by_visitor: query_terms_by_visitor(from)
      )
    end

    private

    def window_start
      PERIODS.fetch(@period, 7.days).ago
    end

    def query_top_terms(from)
      SearchTerm
        .where('created_at >= ?', from)
        .group(:term)
        .select('term, SUM(occurences) AS total')
        .order('total DESC')
        .limit(@limits[:terms])
    end

    def query_top_visitors(from)
      VisitorSession
        .joins(:search_terms)
        .where('search_terms.created_at >= ?', from)
        .select("visitor_sessions.display_name AS name,
                 SUM(search_terms.occurences) AS total_terms,
                 COUNT(DISTINCT search_terms.term) AS distinct_terms")
        .group('visitor_sessions.id')
        .order('total_terms DESC')
        .limit(@limits[:visitors])
    end

    def query_terms_by_visitor(from)
      SearchTerm
        .joins(:visitor_session)
        .where('search_terms.created_at >= ?', from)
        .select("visitor_sessions.display_name AS name,
                 search_terms.term AS term,
                 SUM(search_terms.occurences) AS total")
        .group('visitor_sessions.display_name', 'search_terms.term')
        .order('total DESC')
        .limit(@limits[:terms_by_visitor])
    end
  end
end
