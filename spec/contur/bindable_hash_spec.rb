# frozen_string_literal: true

require 'contur/bindable_hash'

describe Contur::BindableHash do
  let(:test_hash) { { firstvalue: 1, secondvalue: 'two' } }
  subject { Contur::BindableHash.new(test_hash) }

  it '#define_method' do
    expect(subject.firstvalue).to be 1
    expect(subject.secondvalue).to eq 'two'
  end

  it '#get_binding' do
    bind = subject.get_binding
    expect(eval('firstvalue', bind, __FILE__, __LINE__)).to be 1
    expect(eval('secondvalue', bind, __FILE__, __LINE__)).to eq 'two'
  end
end
