# frozen_string_literal: true

class RubyArguments
  module Exceptions
    class Base < ::StandardError
    end

    class InvalidKeyType < Base
      class << self
        ##
        # @api private
        # @param key [Object] Can be any type.
        # @return [RubyArguments::Exceptions::InvalidKeyType]
        #
        def create(key:)
          message = <<~TEXT
            `#[]` accepts only `Integer` and `String` keys.

            Key `#{key.inspect}` has `#{key.class}` class.
          TEXT

          new(message)
        end
      end
    end
  end

  class NullArguments < ::RubyArguments
    ##
    # @api private
    # @return [void]
    #
    def initialize
      @args = []
      @kwargs = {}
      @block = nil
    end

    ##
    # @api public
    # @return [Boolean]
    #
    def null_arguments?
      true
    end
  end

  ##
  # @api public
  # @!attribute [r] args
  #   @return [Array<Object>]
  #
  attr_reader :args

  ##
  # @api public
  # @!attribute [r] kwargs
  #   @return [Hash{Symbol => Object}]
  #
  attr_reader :kwargs

  ##
  # @api public
  # @!attribute [r] block
  #   @return [Proc, nil]
  #
  attr_reader :block

  ##
  # @api public
  # @param args [Array<Object>]
  # @param kwargs [Hash{Symbol => Object}]
  # @param block [Proc, nil]
  # @return [void]
  #
  def initialize(*args, **kwargs, &block)
    @args = args
    @kwargs = kwargs
    @block = block
  end

  class << self
    ##
    # @api public
    # @return [RubyArguments::NullArguments]
    #
    def null_arguments
      @null_arguments ||= ::RubyArguments::NullArguments.new
    end
  end

  ##
  # @api public
  # @return [Boolean]
  #
  def null_arguments?
    false
  end

  ##
  # @api public
  # @return [Booleam]
  #
  def any?
    return true if args.any?
    return true if kwargs.any?
    return true if block

    false
  end

  ##
  # @api public
  # @return [Booleam]
  #
  def none?
    !any?
  end

  ##
  # @api public
  # @return [Booleam]
  #
  def empty?
    none?
  end

  ##
  # @api public
  # @return [Booleam]
  #
  def present?
    any?
  end

  ##
  # @api public
  # @return [Booleam]
  #
  def blank?
    none?
  end

  ##
  # @api public
  # @param key [Integer, Symbol]
  # @return [Object] Can be any type.
  # @raise [RubyArguments::Exceptions::InvalidKeyType]
  #
  def [](key)
    case key
    when ::Integer then args[key]
    when ::Symbol then kwargs[key]
    else raise Exceptions::InvalidKeyType.create(key: key)
    end
  end

  ##
  # @api public
  # @param other [Object]
  # @return [Boolean, nil]
  #
  def ==(other)
    return unless other.instance_of?(self.class)

    return false if args != other.args
    return false if kwargs != other.kwargs
    return false if block != other.block

    true
  end

  ##
  # @api public
  # @return [Array]
  # @note https://zverok.space/blog/2022-12-20-pattern-matching.html
  # @note https://ruby-doc.org/core-2.7.2/doc/syntax/pattern_matching_rdoc.html
  # @note Expected to be called only from pattern matching. Avoid direct usage of this method.
  #
  def deconstruct
    [args, kwargs, block]
  end

  ##
  # @api public
  # @param keys [Array<Symbol>, nil]
  # @return [Hash]
  # @note https://zverok.space/blog/2022-12-20-pattern-matching.html
  # @note https://ruby-doc.org/core-2.7.2/doc/syntax/pattern_matching_rdoc.html
  # @note Expected to be called only from pattern matching. Avoid direct usage of this method.
  #
  def deconstruct_keys(keys)
    keys ||= [:args, :kwargs, :block]

    keys.each_with_object({}) do |key, hash|
      case key
      when :args
        hash[key] = args
      when :kwargs
        hash[key] = kwargs
      when :block
        hash[key] = block
      end
    end
  end
end
