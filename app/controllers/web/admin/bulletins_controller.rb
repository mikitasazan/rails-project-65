# frozen_string_literal: true

class Web::Admin::BulletinsController < Web::Admin::ApplicationController
  def publish
    @bulletin = Bulletin.find(params.expect(:id))

    if @bulletin.may_publish?
      @bulletin.publish!
      redirect_back fallback_location: admin_root_path, notice: t(".success")
    else
      redirect_back fallback_location: admin_root_path, alert: t(".error")
    end
  end

  def reject
    @bulletin = Bulletin.find(params.expect(:id))

    if @bulletin.may_reject?
      @bulletin.reject!
      redirect_back fallback_location: admin_root_path, notice: t(".success")
    else
      redirect_back fallback_location: admin_root_path, alert: t(".error")
    end
  end

  def archive
    @bulletin = Bulletin.find(params.expect(:id))

    if @bulletin.may_archive?
      @bulletin.archive!
      redirect_back fallback_location: admin_root_path, notice: t(".success")
    else
      redirect_back fallback_location: admin_root_path, alert: t(".error")
    end
  end
end
