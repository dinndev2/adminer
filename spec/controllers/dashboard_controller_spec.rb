require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:tenant) { create(:tenant) }
  let(:admin) { create(:user, :admin, tenant: tenant) }
  let(:member) { create(:user, tenant: nil, invited_by: admin) }
  let(:business) { create(:business, tenant: tenant) }
  let(:other_tenant) { create(:tenant) }
  let(:other_business) { create(:business, tenant: other_tenant) }
  let(:other_user) { create(:user, tenant: tenant) }
  let!(:member_bookings) { create_list(:booking, 2, business: business, assigned_to: member) }
  let!(:other_bookings) { create_list(:booking, 3, business: other_business) }
  let!(:tenant_bookings) { create_list(:booking, 5, business: business, assigned_to: other_user) }

  describe '#home' do
    context 'when not authenticated' do
      it 'redirects to sign in' do
        get :home
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when current user is member' do
      it 'returns only bookings assigned to them' do
        sign_in member
        get :home

        expect(response).to have_http_status(:ok)
        expect(assigns(:bookings)).to match_array(member_bookings)
        expect(assigns(:bookings)).not_to include(*tenant_bookings)
      end
    end

    context 'when current user is admin' do
      it 'returns bookings from the tenant workspace' do
        sign_in admin
        get :home

        expect(response).to have_http_status(:ok)
        expect(assigns(:bookings)).to match_array(member_bookings + tenant_bookings)
        expect(assigns(:bookings)).not_to include(*other_bookings)
      end
    end
  end
end
