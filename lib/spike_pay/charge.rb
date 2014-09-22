class SpikePay
  class Charge < SpikePay::ApiResource
    # Create a charge object with given parameters.
    # In live mode, this issues a transaction.
    #
    # @param params [ChargeRequestCreate|Hash] Parameters to API call
    # @return [ChargeResponse]
    def create(params = {})
      req = SpikePay::ChargeRequestCreate.create(params)
      raw_response = @client.request(:post, 'charges', req)
      SpikePay::ChargeResponse.new(raw_response)
    end

    # Retrieve a existing charge object by charge id
    #
    # @param params [ChargeIdRequest|Hash] Parameters to API call
    # @return [ChargeResponse]
    def retrieve(params = {})
      req = SpikePay::ChargeIdRequest.create(params)
      raw_response = @client.request(:get, 'charges/:id', req)
      SpikePay::ChargeResponse.new(raw_response)
    end

    # Refund a paid charge specified by charge id.
    # Optional argument amount is to refund partially.
    #
    # @param params [ChargeRequestWithAmount|Hash] Parameters to API call
    # @return [ChargeResponse]
    def refund(params = {})
      req = SpikePay::ChargeRequestWithAmount.create(params)
      raw_response = @client.request(:post, 'charges/:id/refund', req)
      SpikePay::ChargeResponse.new(raw_response)
    end

    # List charges filtered by params
    #
    # @param params [ChargeListRequest|Hash] Parameters to API call
    # @return [ChargeResponseList]
    def all(params = {})
      req = SpikePay::ChargeListRequest.create(params)
      raw_response = @client.request(:get, 'charges', req)
      SpikePay::ChargeResponseList.new(raw_response)
    end
  end
end
