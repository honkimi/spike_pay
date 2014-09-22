class SpikePay
  class Entity
    # Remove nil values and stringify keys
    def normalize_hash(hash)
      hash.each_with_object({}) { |kv, obj| k,v = kv; obj[k.to_s] = v unless v == nil }
    end

    # Convert attributes and its children to pure-Ruby hash
    # @return [Hash] pure ruby hash including no user objects
    def to_h
      @attributes.each_with_object({}) do |kv, obj|
        k, v = kv
        next if v == nil
        obj[k] = v.is_a?(Entity) ? v.to_h : v
      end
    end

    alias_method :to_hash, :to_h

    # Pretty print object's data
    def to_s
      rendered = "#<#{self.class}\n"
      self.class.fields.each do |k|
        rendered << "  #{k}: " << @attributes[k].inspect.gsub(/(\r?\n)/, '\1  ') << "\n"
      end
      rendered << ">"
    end

    alias_method :inspect, :to_s
  end


  class ChargeRequestCreate < Entity
    attr_reader :attributes

    def self.fields
      ['amount', 'currency', 'card', 'products']
    end


    def self.create(params)
      return params if params.is_a?(self)
      hash = case params
        when Hash; params
        else
          raise SpikePay::InvalidRequestError.new("#{self} does not accept the given value", params)
        end
      self.new(hash)
    end

    def initialize(hash = {})
      hash = normalize_hash(hash)
      @attributes = hash
    end

    # attributes accessors
    def amount
      attributes['amount']
    end

    def amount=(value)
      attributes['amount'] = value
    end

    def currency
      attributes['currency']
    end

    def currency=(value)
      attributes['currency'] = value
    end

    def card
      attributes['card']
    end


    def card=(value)
      attributes['card'] = value
    end

    def products
      attributes['products']
    end

    def procuts=
      value = value['products'][0].is_a?(Hash) ? SpikePay::ProductsRequest.new(['products'][0]) : value
      attributes['products'] = value
    end
  end

  class ChargeRequestWithAmount < Entity
    attr_reader :attributes
    def self.fields
      ['id']
    end
    def self.create(params)
      return params if params.is_a?(self)
      hash = case params
        when Hash; params
        else
          raise SpikePay::InvalidRequestError.new("#{self} does not accept the given value", params)
        end
      self.new(hash)
    end

    def initialize(hash = {})
      hash = normalize_hash(hash)
      @attributes = hash
    end

    # attributes accessors
    def id
      attributes['id']
    end
  end

  class ProductsRequest < Entity
    attr_reader :attributes

    def self.fields
      ['id', 'title', 'description', 'language', 'price', 'currency', 'count', 'stock']
    end


    def self.create(params)
      return params if params.is_a?(self)
      hash = case params
        when Hash; params
        else
          raise SpikePay::InvalidRequestError.new("#{self} does not accept the given value", params)
        end
      self.new(hash)
    end

    def initialize(hash = {})
      hash = normalize_hash(hash)
      @attributes = hash
    end

    # attributes accessors
    def id
      attributes['id']
    end

    def title
      attributes['title']
    end

    def description
      attributes['description']
    end

    def language
      attributes['language']
    end

    def price
      attributes['price']
    end

    def currency
      attributes['currency']
    end

    def count
      attributes['count']
    end

    def stock
      attributes['stock']
    end
  end

  class ChargeResponse < Entity
    attr_reader :attributes

    def self.fields
      ['id', 'object', 'livemode', 'amount', 'created', 'currency', 'paid', 'captured', 'refunded', 'amount_refunded', 'refunds']
    end


    def initialize(hash = {})
      hash = normalize_hash(hash)
      @attributes = hash
    end

    # attributes accessors
    def id
      attributes['id']
    end

    def object
      attributes['object']
    end

    def livemode
      attributes['livemode']
    end

    def amount
      attributes['amount']
    end

    def created
      attributes['created']
    end

    def currency
      attributes['currency']
    end

    def paid
      attributes['paid']
    end

    def captured
      attributes['captured']
    end

    def refunded
      attributes['refunded']
    end

    def amount_refunded
      attributes['amount_refunded']
    end

    def refunds
      attributes['refunds']
    end

  end
  class ChargeListRequest < Entity
    attr_reader :attributes

    def self.fields
      ['limit']
    end


    def self.create(params)
      return params if params.is_a?(self)
      hash = case params
        when Hash; params
        else
          raise WebPay::InvalidRequestError.new("#{self} does not accept the given value", params)
        end
      self.new(hash)
    end

    def initialize(hash = {})
      hash = normalize_hash(hash)
      @attributes = hash
    end

    # attributes accessors
    def limit
      attributes['limit']
    end
  end
  class ChargeResponseList < Entity
    attr_reader :attributes

    def self.fields
      ['object', 'url', 'has_more', 'data']
    end


    def initialize(hash = {})
      hash = normalize_hash(hash)
      hash['data'] = hash['data'].is_a?(Array) ? hash['data'].map { |x| SpikePay::ChargeResponse.new(x) if x.is_a?(Hash) }  : hash['data']
      @attributes = hash
    end

    # attributes accessors
    def object
      attributes['object']
    end

    def url
      attributes['url']
    end

    def has_more
      attributes['has_more']
    end

    def data
      attributes['data']
    end

  end
  class ChargeIdRequest < Entity
    attr_reader :attributes

    def self.fields
      ['id']
    end


    def self.create(params)
      return params if params.is_a?(self)
      hash = case params
        when Hash; params
        when SpikePay::ChargeResponse; {'id' => params.id}
        when String; {'id' => params}
        else
          raise SpikePay::InvalidRequestError.new("#{self} does not accept the given value", params)
        end
      self.new(hash)
    end

    def initialize(hash = {})
      hash = normalize_hash(hash)
      @attributes = hash
    end

    # attributes accessors
    def id
      attributes['id']
    end


    def id=(value)
      attributes['id'] = value
    end

  end
  class DeletedResponse < Entity
    attr_reader :attributes

    def self.fields
      ['deleted']
    end


    def initialize(hash = {})
      hash = normalize_hash(hash)
      @attributes = hash
    end

    # attributes accessors
    def deleted
      attributes['deleted']
    end

  end
  class ErrorBody < Entity
    attr_reader :attributes

    def self.fields
      ['message', 'type', 'code', 'param']
    end


    def initialize(hash = {})
      hash = normalize_hash(hash)
      @attributes = hash
    end

    # attributes accessors
    def message
      attributes['message']
    end

    def type
      attributes['type']
    end

    def code
      attributes['code']
    end

    def param
      attributes['param']
    end

  end
  class ErrorData < Entity
    attr_reader :attributes

    def self.fields
      ['error']
    end


    def initialize(hash = {})
      hash = normalize_hash(hash)
      hash['error'] = SpikePay::ErrorBody.new(hash['error']) if hash['error'].is_a?(Hash)
      @attributes = hash
    end

    # attributes accessors
    def error
      attributes['error']
    end

  end
end
