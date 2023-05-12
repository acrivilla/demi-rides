require 'httparty'
require 'pry'

class PaymentClient
  def initialize(operation, options)
    @config = YAML.load(File.read('./app/clients/payment_config.yml'))
    @operation = operation
    @options = options
  end

  def send_message
    retries = 0
    begin
      HTTParty.post(endpoint, headers: headers, body: message.to_json)
    rescue HTTPClient::ConnectTimeoutError => e
      (retries += 1) > 2 ? create_log(e) : retry
    rescue => error
      {messages: error.messages.join(',')}
    end
  end

  def acceptance_token
    response = HTTParty.get(@config['endpoints']['base_url'] +
      @config['endpoints']['acceptance_token'] +
      @config['keys']['public_key'])

    response['data']['presigned_acceptance']['acceptance_token']
  end

  private

  def endpoint
    @config['endpoints']['base_url'] + @config['endpoints'][@operation]
  end

  def headers
    {
      'Content-Type': 'application/json',
      'Authorization': "Bearer #{@config['keys']['private_key']}"
    }
  end

  def message
    case @operation
    when 'payment_method'
      {
        type: @options[:type].to_s.upcase,
        token: @options[:token],
        customer_email: @options[:rider].email,
        acceptance_token: acceptance_token
      }
    when 'transactions'
      {
        amount_in_cents: @options[:total_amount],
        currency: "COP",
        customer_email: @options[:ride].rider.email,
        payment_method: {
          installments: 1
        },
        reference: "charge for ride #{@options[:ride].id}",
        payment_source_id: @options[:ride].rider.payment_methods.first.external_id
      }
    end
  end
end