# frozen_string_literal: true

class DiscourseGamification::AdminGamificationLeaderboardController < Admin::AdminController

  def index
    render_serialized({
      leaderboards: DiscourseGamification::GamificationLeaderboard.all
    }, AdminGamificationIndexSerializer, root: false)
  end

  def create
    params.require([:name, :created_by_id])

    leaderboard = DiscourseGamification::GamificationLeaderboard.new(name: params[:name], created_by_id: params[:created_by_id])
    if leaderboard.save
      render_serialized(leaderboard, LeaderboardSerializer, root: false)
    else
      render_json_error(leaderboard)
    end
  end

  def update
    params.require(:name)

    leaderboard = DiscourseGamification::GamificationLeaderboard.find_by(name: params[:name])
    raise Discourse::NotFound unless leaderboard

    if leaderboard.update(
        name: params[:name],
        to_date: params[:to_date],
        from_date: params[:from_date],
      )
      render json: success_json
    else
      render_json_error(leaderboard)
    end
  end

  def destroy
    params.require(:name)

    leaderboard = DiscourseGamification::GamificationLeaderboard.find_by(name: params[:name])
    leaderboard.destroy if leaderboard
    render json: success_json
  end
end
