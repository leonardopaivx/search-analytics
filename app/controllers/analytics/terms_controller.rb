module Analytics
  class TermsController < ApplicationController
    include VisitorSessionable

    def index
      period = (params[:period] || '7d').to_s
      from = case period
               when '24h' then 24.hours.ago
               when '7d'  then 7.days.ago
               when '30d' then 30.days.ago
               else 7.days.ago
      end

      @top_terms = SearchTerm.where('created_at >= ?', from)
                             .group(:term)
                             .select('term, SUM(occurences) as total')
                             .order('total DESC')
                             .limit(20)

      respond_to do |format|
        format.html
        format.json { render json: @top_terms.map { |t| { term: t.term, total: t.total.to_i } } }
      end
    end
  end
end
