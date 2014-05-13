require 'spec_helper'

describe Topic do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  it { should validate_presence_of(:slug) }
  it { should validate_uniqueness_of(:slug) }

  it { should have_many(:blips) }
end