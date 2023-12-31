class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :purchase]

  def index
    @products = Product.all
  end

  def show
  end

  def purchase
    begin
      # Create a customer in Stripe
      customer = Stripe::Customer.create(
        email: params[:stripeEmail],
        source: params[:stripeToken] 
      )

      stripe_customer_id = customer.id

      payment_method = Stripe::PaymentMethod.create({
        type: 'card',
        card: { token: 'tok_visa' }
      })

      payment_method = Stripe::PaymentMethod.attach(payment_method.id, { customer: stripe_customer_id })

      # Create a PaymentIntent
      payment_intent = Stripe::PaymentIntent.create(
        amount: @product.price,  
        currency: 'inr',
        description: @product.name,
        payment_method: payment_method.id,
        customer: customer['id'],
        automatic_payment_methods: { enabled: true, allow_redirects: 'never' }
      )
  
      payment_intent = Stripe::PaymentIntent.confirm(
        payment_intent.id,
        {
          payment_method: payment_method
        },
      )

      if payment_intent.status == 'requires_action' && payment_intent.next_action['type'] == 'use_stripe_sdk' && payment_intent.next_action['use_stripe_sdk']['type'] == 'three_d_secure_redirect'
        redirect_to(payment_intent.next_action['use_stripe_sdk']['stripe_js'], allow_other_host: true)
      
      elsif payment_intent.status == 'succeeded'
        # Payment succeeded, you can proceed with further processing.
        # For example, update order status, send confirmation email, etc.
        flash[:success] = "Payment Successfully Completed"
      else
        flash[:error] = "Payment failed: #{payment_intent.last_payment_error.message}"
        redirect_to @product
      end
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to @product
    rescue Stripe::StripeError => e
      flash[:error] = e.message
      redirect_to @product
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
end
