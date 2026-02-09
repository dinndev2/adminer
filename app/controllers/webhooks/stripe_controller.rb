# app/controllers/webhooks/stripe_controller.rb
class Webhooks::StripeController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    payload = request.raw_post
    sig = request.env["HTTP_STRIPE_SIGNATURE"]
    event = Stripe::Webhook.construct_event(
      payload, sig, ENV.fetch("STRIPE_WEBHOOK_SECRET")
    )

    case event.type
    when "checkout.session.completed"
      
      
      session = event.data.object
      tenant = Tenant.find(session.metadata.tenant_id)

      tenant.update!(
        stripe_customer_id: session.customer,
        stripe_subscription_id: session.subscription,
        tier: "supercharged"
      )

      # Fetch subscription for status + period end
      sub = Stripe::Subscription.retrieve(session.subscription)      
      tenant.update!(
        stripe_subscription_status: sub.status,
        stripe_current_period_end: Time.at(sub.current_period_end)
      )

    when "customer.subscription.updated", "customer.subscription.deleted"
      sub = event.data.object
      tenant = Tenant.find_by(stripe_subscription_id: sub.id)
      if tenant
        tenant.update!(
          stripe_subscription_status: sub.status,
          stripe_current_period_end: Time.at(sub.current_period_end)
        )
      end
    end

    head :ok
  rescue Stripe::SignatureVerificationError, JSON::ParserError
    head :bad_request
  end
end
