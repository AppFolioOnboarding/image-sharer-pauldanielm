class ImagesController < ApplicationController
  def index
    @image_list = if params[:tag]
                    Image.tagged_with(params[:tag]).order(created_at: :desc)
                  else
                    Image.order(created_at: :desc)
                  end
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(params.require(:image).permit(:image_url, :tag_list))

    if @image.save
      flash[:success] = 'Successfully added new image.'
      redirect_to image_path(@image)
    else
      flash[:error] = "Couldn't add image"
      render(new_image_path)
    end
  end

  def show
    @image = Image.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Couldn't find image with id: #{params[:id]}"
    redirect_to(images_path)
  end

  def destroy
    begin
      @image = Image.find(params[:id])
      @image.destroy
      flash[:success] = 'Deleted image successfully'
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Failed to delete image'
    end

    redirect_to(images_path)
  end
end
