# frozen_string_literal: true

require 'rails_helper'
require './lib/utils'

RSpec.describe CreateCaptionImageJob, type: :job do
  describe "#perform_later" do
    subject(:create_caption_image_job) { described_class.new.perform(caption, image_name) }

    context "with valid caption and url" do
      let(:url) { Faker::LoremFlickr.image(size: "300x300", search_terms: ['beer']) }
      let(:text) { Faker::Beer.brand }
      let(:image_name) { "#{Digest::MD5.hexdigest("#{url}#{text}")}.jpg" }
      let(:caption_url) { "/images/#{image_name}" }
      let(:caption) { Caption.create(url: url, text: text, caption_url: caption_url) }

      it "has downloaded and memefied image when finished" do
        create_caption_image_job

        expect(File.exist?("#{Utils.images_dir}#{image_name}")).to be true
      end
    end
  end
end
