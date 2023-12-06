# config/initializers/stripe.rb

Rails.configuration.stripe = {
    publishable_key:'pk_test_51NdYCrSCubVH9zDaoxhYdtfsldLD3iairThiMtdK1UNZW1bOw1kiIKYrCf5ksxUAIuj0USIttntFA1dzso7tCfQb00yNIusahA',
    secret_key:'sk_test_51NdYCrSCubVH9zDaWTINrDWXogzHBOxdN9OawkMd6AjPtUvfQbqxukXzx81MHKjadf8LbLfiMf6HXK4HTRNz2l8A000joma9jA'
  }
  
  Stripe.api_key = Rails.configuration.stripe[:secret_key]
  