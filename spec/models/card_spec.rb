require 'rails_helper'

describe Card, type: :model do
  it { expect(subject).to validate_presence_of :title }
  it { expect(subject).to validate_presence_of :caption }
  it { expect(subject).to validate_presence_of :description }
  it { expect(subject).to validate_presence_of :link }

  it { expect(subject).to validate_uniqueness_of :title }

  it { expect(subject).to ensure_length_of(:title).is_at_most(50) }
  it { expect(subject).to ensure_length_of(:caption).is_at_most(50) }
  it { expect(subject).to ensure_length_of(:link).is_at_most(255) }
end
