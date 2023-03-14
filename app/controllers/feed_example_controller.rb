# frozen_string_literal: true

class FeedExampleController < ApplicationController
  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
    else
      @user = User.order('random()').first
      redirect_to feed_example_index_path(user_id: @user.id) if @user
      return
    end

    per = (params[:per] || 5).to_i
    @feed_items =
      FeedService.new(@user.id).feed_items.page(params[:page]).per(per)
    respond_to do |format|
      format.html
      format.json { render json: @feed_items.to_json(include: [:feedable]) }
    end
  end
end
