module Analytics
  class TermsController < ApplicationController
    include VisitorSessionable

    def index
      report = TermsReport.call(period: params[:period])

      @top_terms = report.top_terms
      @top_visitors = report.top_visitors
      @terms_by_visitor = report.terms_by_visitor

      respond_to do |format|
        format.html
        format.json { render json: TermsReportSerializer.new(report).as_json }
      end
    end
  end
end
