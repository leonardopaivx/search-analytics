class SearchesController < ApplicationController
  include VisitorSessionable

  def index
  end

  def show
    q = params[:q].to_s.strip
    results = q.present? ? Article.search(q).limit(10) : []
    render json: {
      query: q,
      results: results.map { |a| { id: a.id, title: a.title } }
    }
  end
end
