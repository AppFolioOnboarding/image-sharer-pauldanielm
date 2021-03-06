require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  test 'new image form is displayed' do
    get new_image_path

    assert_response :ok
    assert_select "input[value='Create Image']"
    assert_select "input[id='image_tag_list']"
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

  test 'image can be tagged via form' do
    post images_path, params: {
      image: {
        image_url: 'https://learn.appfolio.com/apm/www/images/apm-logo-v2.png',
        tag_list: 'test1, test2'
      }
    }

    follow_redirect!
    assert_select 'div.alert', text: 'Successfully added new image.'
    assert_equal(%w[test1 test2], Image.last.tag_list)
  end

  test 'invalid url renders new image page with error' do
    post images_path, params: {
      image: {
        image_url: 'invalid_url'
      }
    }

    assert_select 'div.alert', text: "Couldn't add image"
    assert_select "span[class='error']", 'Input must be a valid URI'
  end

  test 'renders image correctly in show' do
    image = Image.create!(image_url: 'https://learn.appfolio.com/apm/www/images/apm-logo-v2.png',
                          tag_list: 'test1, test2')
    get image_path(image.id)

    assert_response :ok
    assert_select 'img', src: image.image_url
    assert_select 'p.card-text a' do |elements|
      assert elements.map(&:text) == %w[test1 test2]
    end
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

  test 'cards in index page have text tags' do
    image = Image.create!(image_url: 'https://test01.png',
                          tag_list: 'test1')
    get images_path

    assert_response :success
    assert_select 'div.card img.card-img', src: image.image_url
    assert_select 'div.card p.card-text', text: image.tag_list.first
  end

  test 'cards in index page tags are links to filter index page' do
    Image.create!(image_url: 'https://test01.png',
                  tag_list: 'test1')
    Image.create!(image_url: 'https://test02.png',
                  tag_list: 'test1, test2')
    Image.create!(image_url: 'https://test03.png',
                  tag_list: 'test2')
    get images_path(tag: 'test1')

    assert_response :success
    assert_select 'div.card .card-text' do |elements|
      assert_select elements, 'a[href=?]', images_path(tag: 'test1') do |tags|
        assert tags.size == 2
      end
    end
  end

  test 'searching for nonexistent tag returns no images' do
    Image.create!(image_url: 'https://test01.png',
                  tag_list: 'test1')
    Image.create!(image_url: 'https://test02.png',
                  tag_list: 'test1, test2')
    Image.create!(image_url: 'https://test03.png',
                  tag_list: 'test2')
    get images_path(tag: 'nonexistent tag')

    assert_response :success
    assert_select 'img', count: 0
  end

  test 'delete image link exists' do
    image = Image.create!(image_url: 'https://test01.png')
    get images_path

    assert_response :success
    assert_select 'a[href=?]', image_path(image.id)
  end

  test 'successful delete flashes success message, image no longer displayed' do
    image = Image.create!(image_url: 'https://test01.png')

    delete image_path(image.id)

    follow_redirect!
    assert_select 'div.alert', text: 'Deleted image successfully'
    assert_select 'img', count: 0
  end

  test 'delete nonexistent id flashes error message' do
    delete image_path(1)

    follow_redirect!
    assert_select 'div.alert', text: 'Failed to delete image'
  end

  test 'show nonexistent id flashes error message' do
    get image_path(id: 1)

    follow_redirect!
    assert_select 'div.alert', text: "Couldn't find image with id: 1"
  end
end
