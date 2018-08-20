class Api::V1::CommentsController < ApplicationController
  def index
    comments = Comment.where(user_id: params[:user_id])
    render json: comments
  end
end
