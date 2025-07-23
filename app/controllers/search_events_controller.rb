class SearchEventsController < ApplicationController
  include VisitorSessionable
  protect_from_forgery except: :create

  def create
    payload = SearchEvents::Payload.new(extract_payload)
    return head :no_content unless payload.valid?

    SearchEvents::Ingest.call(session: current_visitor_session, payload: payload)
    head :accepted
  end

  private

  def extract_payload
    permitted = params.permit(:query, :final, :typed_at, search_event: [ :query, :final, :typed_at ])
    raw = permitted.to_h.symbolize_keys
    inner = raw.delete(:search_event) || {}
    raw.reverse_merge(inner).slice(:query, :final, :typed_at)
  end
end
