class Webhooks::StripeController < ActionController::Base
  skip_forgery_protection

  def create
    event = Stripe::Webhook.construct_event(
      request.raw_post,
      request.headers["Stripe-Signature"],
      ENV.fetch("STRIPE_WEBHOOK_SECRET")
    )

    case event.type
    when "checkout.session.completed"
      handle_checkout_completed(event.data.object)
    when "customer.subscription.updated", "customer.subscription.deleted"
      handle_subscription_change(event.data.object)
    else
      Rails.logger.info("Unhandled Stripe webhook event: #{event.type}")
    end

    head :ok
  rescue Stripe::SignatureVerificationError, JSON::ParserError => e
    Rails.logger.warn("Invalid Stripe webhook payload: #{e.class} #{e.message}")
    head :bad_request
  rescue KeyError => e
    Rails.logger.error("Missing Stripe webhook configuration: #{e.message}")
    head :internal_server_error
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("Stripe webhook record lookup failed: #{e.message}")
    head :unprocessable_entity
  rescue Stripe::StripeError => e
    Rails.logger.error("Stripe API error while processing webhook: #{e.class} #{e.message}")
    head :internal_server_error
  rescue StandardError => e
    Rails.logger.error("Unhandled Stripe webhook error: #{e.class} #{e.message}")
    head :internal_server_error
  end

  private

  def handle_checkout_completed(session)
    tenant_id = session.metadata&.tenant_id.presence || session.client_reference_id.presence
    tenant = Tenant.find(tenant_id)

    tenant.update!(
      stripe_customer_id: session.customer,
      stripe_subscription_id: session.subscription,
      tier: "supercharged"
    )

    return if session.subscription.blank?

    sub = Stripe::Subscription.retrieve(session.subscription)
    tenant.update!(
      stripe_subscription_status: sub.status,
      stripe_current_period_end: Time.at(sub.current_period_end)
    )
  end

  def handle_subscription_change(subscription)
    tenant = Tenant.find_by(stripe_subscription_id: subscription.id)
    return unless tenant

    tenant.update!(
      stripe_subscription_status: subscription.status,
      stripe_current_period_end: Time.at(subscription.current_period_end)
    )
  end
end
