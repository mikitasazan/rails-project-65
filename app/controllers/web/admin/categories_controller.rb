# frozen_string_literal: true

class Web::Admin::CategoriesController < Web::Admin::ApplicationController
  def index
    @categories = Category.order(:name)
  end

  def new
    @category = Category.new
  end

  def edit
    @category = Category.find(params.expect(:id))
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to admin_categories_path, notice: t(".success")
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    @category = Category.find(params.expect(:id))

    if @category.update(category_params)
      redirect_to admin_categories_path, notice: t(".success")
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @category = Category.find(params.expect(:id))

    if @category.bulletins.exists?
      redirect_to admin_categories_path, alert: t(".has_bulletins")
    else
      @category.destroy
      redirect_to admin_categories_path, notice: t(".success")
    end
  end

  private

  def category_params
    params.expect(category: %i[name])
  end
end
