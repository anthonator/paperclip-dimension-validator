require 'spec_helper'
require 'paperclip/matchers'

describe Paperclip::Shoulda::Matchers::ValidateAttachmentDimensionsMatcher do
  extend Paperclip::Shoulda::Matchers
  context "russial locale set" do
    before { I18n.locale = :ru }
    let(:width) { 100 }
    let(:height) { 100 }

    context 'less height', :focus do
      let(:height) { 10 }

      it { expect(matcher).to_not be_matches Dummy }
    end

    context 'equals height' do
      it { expect(matcher).to be_matches Dummy }
    end
  end

  context "en locale set" do
    before { I18n.locale = :en }
    let(:width) { 100 }
    let(:height) { 100 }

    context 'less height', :focus do
      let(:height) { 10 }

      it { expect(matcher).to_not be_matches Dummy }
    end

    context 'equals height' do
      it { expect(matcher).to be_matches Dummy }
    end
  end
  private

  def matcher
    self.class.validate_attachment_dimensions(:avatar).width(width).height(height)
  end
end
