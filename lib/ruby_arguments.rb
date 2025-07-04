# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license MIT <https://opensource.org/license/mit>
##

require_relative "ruby_arguments/version"

##
# @api public
# @since 1.0.0
#
class RubyArguments
  module Exceptions
    ##
    # @api public
    # @since 1.0.0
    #
    class Base < ::StandardError
    end

    ##
    # @api public
    # @since 1.0.0
    #
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

  ##
  # @api public
  # @since 1.0.0
  #
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
    # @since 1.0.0
    # @return [Boolean]
    #
    def null_arguments?
      true
    end
  end

  ##
  # @api public
  # @since 1.0.0
  # @!attribute [r] args
  #   @return [Array<Object>]
  #
  attr_reader :args

  ##
  # @api public
  # @since 1.0.0
  # @!attribute [r] kwargs
  #   @return [Hash{Symbol => Object}]
  #
  attr_reader :kwargs

  ##
  # @api public
  # @since 1.0.0
  # @!attribute [r] block
  #   @return [Proc, nil]
  #
  attr_reader :block

  ##
  # @api public
  # @since 1.0.0
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
    # @since 1.0.0
    # @return [RubyArguments::NullArguments]
    #
    def null_arguments
      @null_arguments ||= ::RubyArguments::NullArguments.new
    end
  end

  ##
  # @api public
  # @since 1.0.0
  # @return [Boolean]
  #
  def null_arguments?
    false
  end

  ##
  # @api public
  # @since 1.0.0
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
  # @since 1.0.0
  # @return [Booleam]
  #
  def none?
    !any?
  end

  ##
  # @api public
  # @since 1.0.0
  # @return [Booleam]
  #
  def empty?
    none?
  end

  ##
  # @api public
  # @since 1.0.0
  # @return [Booleam]
  #
  def present?
    any?
  end

  ##
  # @api public
  # @since 1.0.0
  # @return [Booleam]
  #
  def blank?
    none?
  end

  ##
  # @api public
  # @since 1.0.0
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
  # @since 1.0.0
  # @param other [Object] Can be any type.
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
  # @since 1.0.0
  # @param other [Object] Can be any type.
  # @return [Boolean, nil]
  #
  def eql?(other)
    return unless other.instance_of?(self.class)

    return false if args != other.args
    return false if kwargs != other.kwargs
    return false if block != other.block

    true
  end

  ##
  # @api public
  # @since 1.0.0
  # @return [Integer]
  #
  def hash
    [self.class, args, kwargs, block].hash
  end

  ##
  # @api public
  # @since 1.0.0
  # @return [Array]
  #
  def deconstruct
    [args, kwargs, block]
  end

  ##
  # @api public
  # @since 1.0.0
  # @param keys [Array<Symbol>, nil]
  # @return [Hash]
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
