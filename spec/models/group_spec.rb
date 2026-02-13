require 'rails_helper'

RSpec.describe User, type: :model do
  let(:group) { Group.create!(name: "Testers") }

  it "is valid with a name" do
    user = User.new(name: "Ameen", group: group)
    expect(user).to be_valid
  end

  it "can exist without a group" do
    user = User.new(name: "Ameen")
    expect(user).to be_valid
  end
end
