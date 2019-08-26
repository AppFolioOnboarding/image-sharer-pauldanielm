class ImagesController < ApplicationController
  def index
    @image_list = Image.order(created_at: :desc)
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(params.require(:image).permit(:image_url, :tag_list))

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
