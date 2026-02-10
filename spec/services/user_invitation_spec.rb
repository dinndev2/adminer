require 'rails_helper'

RSpec.describe UserInvitation do
  describe '#invite' do
    it 'creates the user, invites them, links management, and assigns tenant' do
      admin = create(:user, :admin)
      new_user = build(:user, tenant: nil)

      expect(new_user).to receive(:invite!).with(admin)

      result = described_class.new(new_user, admin).invite

      expect(result.success?).to be(true)
      expect(new_user).to be_persisted
      expect(new_user.tenant).to eq(admin.tenant)
      expect(Management.exists?(member: new_user, admin: admin)).to be(true)
    end

    it 'returns errors and does not invite when invalid' do
      admin = create(:user, :admin)
      new_user = build(:user, email: nil)

      expect(new_user).not_to receive(:invite!)

      result = described_class.new(new_user, admin).invite

      expect(result.success?).to be(false)
      expect(result.errors).to be_present
      expect(new_user).not_to be_persisted
      expect(Management.exists?(member: new_user, admin: admin)).to be(false)
    end
  end
end
