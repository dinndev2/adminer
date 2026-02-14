require 'stripe'


class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_accessible

  def new
    render layout: false
  end

  def checkout
    pro_price_id = ENV.fetch("PRO_ADMINER_PRICE_ID")
    session = Stripe::Checkout::Session.create(
      mode: "subscription",
      customer: @tenant.stripe_customer_id.presence, # reuse if exists
      line_items: [{ price: pro_price_id, quantity: 1 }],
      success_url: payments_success_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: payments_cancel_url,
      client_reference_id: @tenant.id,
      metadata: { tenant_id: @tenant.id }
    )

    redirect_to session.url, allow_other_host: true
  end

  def success; end
  def cancel; end

  private

end
