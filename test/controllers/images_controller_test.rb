require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  test 'new image form is displayed' do
    get new_image_path

    assert_response :ok
    assert_select "input[value='Create Image']"
  end

  test 'valid url gets put into database' do
    assert_difference 'Image.count', 1 do
      post images_path, params: {
        image: {
          image_url: 'https://learn.appfolio.com/apm/www/images/apm-logo-v2.png'
        }
      }
    end

    assert_redirected_to image_path(Image.last.id)
    assert_equal 'https://learn.appfolio.com/apm/www/images/apm-logo-v2.png', Image.last.image_url
  end

  test 'invalid url renders new image page with error' do
    post images_path, params: {
      image: {
        image_url: 'invalid_url'
      }
    }

    assert_select "span[class='error']", 'Input must be a valid URI'
  end

  test 'renders image correctly in show' do
    image = Image.create!(image_url: 'https://learn.appfolio.com/apm/www/images/apm-logo-v2.png')
    get image_path(image.id)

    assert_response :ok
    assert_select 'img', src: image.image_url
  end

  test 'should get index' do
    get images_path

    assert_response :success
    assert_select 'h1', 'Image Index'
  end

  test 'index page contains as many images as image table' do
    get images_path

    assert_response :success
    assert_select 'img', count: Image.count
  end

  test 'first image in index page has first available id in table' do
    Image.create!(image_url: 'https://test01.png')
    Image.create!(image_url: 'https://test02.jpg')
    Image.create!(image_url: 'https://test03.jpg')
    get images_path

    assert_response :success
    assert_select 'img', src: Image.first.image_url
  end
end
