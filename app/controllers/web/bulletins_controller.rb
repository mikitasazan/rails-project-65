# frozen_string_literal: true

class Web::BulletinsController < Web::ApplicationController
  before_action :require_signed_in_user!, only: %i[new create edit update to_moderate archive]

  def index
    @bulletins = Bulletin.published.order(created_at: :desc)
  end

  def show
    @bulletin = Bulletin.find(params.expect(:id))
  end

  def new
    @bulletin = Bulletin.new
    @categories = Category.order(:name)
  end

  def edit
    @bulletin = current_user.bulletins.find(params.expect(:id))
    @categories = Category.order(:name)
  end

  def create
    @bulletin = current_user.bulletins.build(bulletin_params)

    if @bulletin.save
      redirect_to profile_path, notice: t(".success")
    else
      @categories = Category.order(:name)
      render :new, status: :unprocessable_content
    end
  end

  def update
    @bulletin = current_user.bulletins.find(params.expect(:id))

    if @bulletin.update(bulletin_params)
      redirect_to profile_path, notice: t(".success")
    else
      @categories = Category.order(:name)
      render :edit, status: :unprocessable_content
    end
  end

  def to_moderate
    @bulletin = current_user.bulletins.find(params.expect(:id))

    if @bulletin.may_to_moderate?
      @bulletin.to_moderate!
      redirect_to profile_path, notice: t(".success")
    else
      redirect_to profile_path, alert: t(".failure")
    end
  end

  def archive
    @bulletin = current_user.bulletins.find(params.expect(:id))

    if @bulletin.may_archive?
      @bulletin.archive!
      redirect_to profile_path, notice: t(".success")
    else
      redirect_to profile_path, alert: t(".failure")
    end
  end

  private

  def bulletin_params
    params.expect(bulletin: %i[title description category_id image])
  end
end
