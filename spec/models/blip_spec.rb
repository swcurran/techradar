require "rails_helper"

describe Blip do
  include ActiveSupport::Testing::TimeHelpers

  it { should belong_to(:radar) }
  it { should belong_to(:topic) }

  it { should validate_presence_of(:topic_id) }
  it { should validate_presence_of(:quadrant) }
  it { should validate_inclusion_of(:quadrant).in_array(Blip::QUADRANTS) }
  it { should validate_presence_of(:ring) }
  it { should validate_inclusion_of(:ring).in_array(Blip::RINGS) }
  it { should validate_presence_of(:radar) }

  context "duplicate topics" do
    let(:user) { create(:user) }
    let(:radar) { create(:radar, owner: user) }
    let(:topic) { create(:topic) }
    before { create(:blip, topic: topic, radar: radar) }

    specify "cannot have two with same topic in the same radar" do
      duplicate_blip = build(:blip, topic: topic, radar: radar)
      expect(duplicate_blip).not_to be_valid
      errors = duplicate_blip.errors[:topic_id]
      expect(errors).to eq(["already exists in this radar"])
    end

    specify "can have two with same name in a different radar" do
      another_radar = create(:radar, owner: user)
      duplicate_blip = build(:blip, topic: topic, radar: another_radar)
      expect(duplicate_blip).to be_valid
    end
  end

  it "touches its parent radar when saved" do
    radar = nil
    blip = nil
    radar = create(:radar)
    travel(1.day) do
      blip = create(:blip, radar: radar)
    end

    blip.save!

    expect(radar.updated_at.to_s).to eq(blip.updated_at.to_s)
  end

  it "touches its parent when a new blip is added" do
    radar = nil
    travel(1.day) do
      radar = create(:radar)
    end
    blip = create(:blip, radar: radar)

    blip.save!

    expect(radar.updated_at.to_s).to eq(blip.updated_at.to_s)
  end
end
