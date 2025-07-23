# app/controllers/analytics/terms_controller.rb
module Analytics
  class TermsController < ApplicationController
    include VisitorSessionable

    def index
      from = period_from(params[:period])

      @top_terms = SearchTerm
                     .where('created_at >= ?', from)
                     .group(:term)
                     .select('term, SUM(occurences) AS total')
                     .order('total DESC')
                     .limit(20)

      @top_visitors = VisitorSession
                        .joins(:search_terms)
                        .where('search_terms.created_at >= ?', from)
                        .select('visitor_sessions.display_name AS name,
                                 SUM(search_terms.occurences) AS total_terms,
                                 COUNT(DISTINCT search_terms.term) AS distinct_terms')
                        .group('visitor_sessions.id')
                        .order('total_terms DESC')
                        .limit(20)

      @terms_by_visitor = SearchTerm
                            .joins(:visitor_session)
                            .where('search_terms.created_at >= ?', from)
                            .select('visitor_sessions.display_name AS name,
                                     search_terms.term AS term,
                                     SUM(search_terms.occurences) AS total')
                            .group('visitor_sessions.display_name', 'search_terms.term')
                            .order('total DESC')
                            .limit(50)

      respond_to do |format|
        format.html
        format.json do
          render json: {
            terms: @top_terms.map { |t| { term: t.term, total: t.total.to_i } },
            visitors: @top_visitors.map { |v| { name: v.name, total_terms: v.total_terms.to_i, distinct_terms: v.distinct_terms.to_i } },
            terms_by_visitor: @terms_by_visitor.map { |r| { name: r.name, term: r.term, total: r.total.to_i } }
          }
        end
      end
    end

    private

    def period_from(period_param)
      case period_param.to_s
      when '24h' then 24.hours.ago
      when '30d' then 30.days.ago
      else 7.days.ago
      end
    end
  end
end
