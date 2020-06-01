require 'spec_helper'

RSpec.describe 'Trivial case' do
  let(:tf11) { TF11::Plan.new(fixture('trivial/plan-0.11')) }

  let(:tf12) { TF12::Plan.new(fixture('trivial/plan-0.12')) }

  describe TF11 do
    subject { tf11 }

    its(:resources) { should have(1).item }

    describe '#resources[0]' do
      subject { tf11.resources[0] }

      it { should be_a TF11::Resource }

      its(:path) { should eq 'aws_instance.example' }

      its(:name) { should eq 'example' }

      its(:type) { should eq 'aws_instance' }

      its(:action) { should eq :created }

      its :changed_attributes do
        should include(
          ami: 'ami-abc123',
          get_password_data: false,
          instance_type: 't2.micro',
          source_dest_check: true,
        )
      end
    end
  end

  describe TF12 do
    subject { tf12 }

    its(:resources) { should have(1).item }

    describe '#resources[0]' do
      subject { tf12.resources[0] }

      it { should be_a TF12::Resource }

      its(:path) { should eq 'aws_instance.example' }

      its(:name) { should eq 'example' }

      its(:type) { should eq 'aws_instance' }

      its(:action) { should eq :created }

      its :changed_attributes do
        should include(
          ami: 'ami-abc123',
          get_password_data: false,
          instance_type: 't2.micro',
          source_dest_check: true,
        )
      end
    end
  end

  specify do
    r = tf12.resources[0].sub_resources
    # ap Hashdiff.diff(
    #   tf12.resources[0].changed_attributes,
    #   tf11.resources[0].changed_attributes
    # )
    # expect(tf12).to eq tf11
  end
end
