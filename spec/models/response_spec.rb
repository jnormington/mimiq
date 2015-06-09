require 'rails_helper'

describe Response, type: :model do
  it { expect(subject).to validate_presence_of :request_type }
  it { expect(subject).to validate_presence_of :response_type }
  it { expect(subject).to validate_presence_of :content }

  it { expect(subject).to validate_uniqueness_of(:request_by).scoped_to(:request_type) }

  it { expect(subject).to ensure_length_of(:request_type).is_at_most(50) }
  it { expect(subject).to ensure_length_of(:response_type).is_at_most(50) }
  it { expect(subject).to ensure_length_of(:request_by).is_at_most(50) }

  it { expect(Response::TYPES).to eq ['XML', 'JSON', '500', '404'] }
  it { expect(subject).to validate_inclusion_of(:response_type).in_array(Response::TYPES)}

  it { expect(Response::REQUEST_TYPES).to eq ['GET', 'POST'] }
  it { expect(subject).to validate_inclusion_of(:request_type).in_array(Response::REQUEST_TYPES)}
end
