module Analytics
  class TermsReportSerializer
    def initialize(report)
      @report = report
    end

    def as_json(*)
      {
        terms: @report.top_terms.map { |t| { term: t.term, total: t.total.to_i } },
        visitors: @report.top_visitors.map  { |v| { name: v.name, total_terms: v.total_terms.to_i, distinct_terms: v.distinct_terms.to_i } },
        terms_by_visitor: @report.terms_by_visitor.map { |r| { name: r.name, term: r.term, total: r.total.to_i } }
      }
    end
  end
end
