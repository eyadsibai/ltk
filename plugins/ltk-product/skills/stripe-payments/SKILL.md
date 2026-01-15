---
name: stripe-payments
description: Use when implementing payment processing, Stripe integration, subscription billing, checkout flows, webhooks, or asking about "Stripe", "payments", "subscriptions", "checkout", "PCI compliance", "webhooks", "refunds"
version: 1.0.0
---

# Stripe Payment Integration

Production-ready Stripe integration for payments, subscriptions, and webhooks.

## Payment Flows

| Flow | Use Case | PCI Burden |
|------|----------|------------|
| **Checkout Session** | Hosted page, fastest setup | Minimal |
| **Payment Intents** | Custom UI, full control | Requires Stripe.js |
| **Setup Intents** | Save card for later | Minimal |

## Quick Start - Checkout Session

```python
import stripe
stripe.api_key = "sk_test_..."

session = stripe.checkout.Session.create(
    payment_method_types=['card'],
    line_items=[{
        'price_data': {
            'currency': 'usd',
            'product_data': {'name': 'Premium Plan'},
            'unit_amount': 2000,  # $20.00 in cents
            'recurring': {'interval': 'month'},
        },
        'quantity': 1,
    }],
    mode='subscription',
    success_url='https://example.com/success?session_id={CHECKOUT_SESSION_ID}',
    cancel_url='https://example.com/cancel',
)
# Redirect to session.url
```

## Custom Payment Intent Flow

```python
# Backend: Create payment intent
def create_payment_intent(amount, customer_id=None):
    intent = stripe.PaymentIntent.create(
        amount=amount,  # In cents
        currency='usd',
        customer=customer_id,
        automatic_payment_methods={'enabled': True},
    )
    return intent.client_secret
```

```javascript
// Frontend: Confirm payment
const stripe = Stripe('pk_test_...');
const {error, paymentIntent} = await stripe.confirmCardPayment(
    clientSecret,
    {payment_method: {card: cardElement}}
);
```

## Webhook Handling

```python
@app.route('/webhook', methods=['POST'])
def webhook():
    payload = request.data
    sig = request.headers.get('Stripe-Signature')

    try:
        event = stripe.Webhook.construct_event(
            payload, sig, 'whsec_...'
        )
    except stripe.error.SignatureVerificationError:
        return 'Invalid signature', 400

    if event['type'] == 'payment_intent.succeeded':
        handle_payment_success(event['data']['object'])
    elif event['type'] == 'customer.subscription.deleted':
        handle_subscription_canceled(event['data']['object'])

    return 'OK', 200
```

### Critical Webhook Events

| Event | When to Handle |
|-------|----------------|
| `payment_intent.succeeded` | Payment completed |
| `payment_intent.payment_failed` | Payment failed |
| `customer.subscription.updated` | Subscription changed |
| `customer.subscription.deleted` | Subscription canceled |
| `invoice.payment_succeeded` | Subscription payment OK |

## Subscription Management

```python
# Create subscription
subscription = stripe.Subscription.create(
    customer=customer_id,
    items=[{'price': 'price_xxx'}],
    payment_behavior='default_incomplete',
    expand=['latest_invoice.payment_intent'],
)

# Customer portal for self-service
session = stripe.billing_portal.Session.create(
    customer=customer_id,
    return_url='https://example.com/account',
)
# Redirect to session.url
```

## Refunds

```python
# Full refund
stripe.Refund.create(payment_intent='pi_xxx')

# Partial refund
stripe.Refund.create(
    payment_intent='pi_xxx',
    amount=500,  # $5.00
    reason='requested_by_customer'
)
```

## Test Cards

| Card Number | Result |
|-------------|--------|
| `4242424242424242` | Success |
| `4000000000000002` | Declined |
| `4000002500003155` | 3D Secure required |
| `4000000000009995` | Insufficient funds |

## Best Practices

1. **Always use webhooks** - Don't rely on client-side confirmation
2. **Idempotency** - Handle webhook events exactly once
3. **Metadata** - Link Stripe objects to your database
4. **Test mode** - Test all flows before production
5. **PCI compliance** - Never handle raw card data server-side
6. **SCA** - Implement 3D Secure for European payments

## Common Pitfalls

- Not verifying webhook signatures
- Hardcoding amounts (use cents!)
- Missing webhook event handlers
- No retry logic for API calls
- Skipping test card scenarios
