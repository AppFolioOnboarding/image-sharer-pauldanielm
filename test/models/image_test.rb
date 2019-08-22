require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  test 'image can not be created without url' do
    image = Image.new

    refute_predicate image, :valid?
    assert_equal "can't be blank", image.errors.messages[:image_url].first
  end

  test 'image url is not valid URI' do
    image = Image.new image_url: 'invalid_uri'

    refute_predicate image, :valid?
    assert_equal 'Input must be a valid URI', image.errors.messages[:image_url].first
  end

  test 'image is valid' do
    image = Image.new image_url: 'http://valid-url.com/img.jpg'

    assert_predicate image, :valid?
  end
end
