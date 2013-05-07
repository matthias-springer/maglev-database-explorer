class ObjectController < ApplicationController
  def index
    id = Integer(params[:id])
    depth = params[:depth] ? Integer(params[:depth]) : 2
    range_from = params[:from] ? Integer(params[:from]) : 1
    range_to = params[:to] ? Integer(params[:to]) : 10

    render :json => {:success => true, :result => ObjectSpace._id2ref(id).to_database_view(depth, range_from, range_to)}
  end
end
