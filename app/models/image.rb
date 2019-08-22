class Image < ApplicationRecord
  validates :image_url, presence: true
  validates :image_url, format: {
    with: URI::DEFAULT_PARSER.make_regexp, message: 'Input must be a valid URI'
  }
end
