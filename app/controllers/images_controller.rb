class ImagesController < ApplicationController
  def index
    @image_list = Image.all
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(image_url: params[:image][:image_url])

    if @image.save
      redirect_to image_path(@image)
    else
      render(new_image_path)
    end
  end

  def show
    @image = Image.find(params[:id])
  end
end
