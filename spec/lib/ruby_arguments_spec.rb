# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license MIT <https://opensource.org/license/mit>
##

RSpec.describe RubyArguments do
  let(:arguments) { described_class.new(*args, **kwargs, &block) }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "attributes" do
    specify { expect(arguments.args).to eq(args) }
    specify { expect(arguments.kwargs).to eq(kwargs) }
    specify { expect(arguments.block).to eq(block) }
  end

  example_group "class methods" do
    describe "#new" do
      context "when `args` are NOT passed" do
        let(:arguments) { described_class.new(**kwargs, &block) }

        it "defaults `args` to empty array" do
          expect(arguments.args).to eq([])
        end
      end

      context "when `kwargs` are NOT passed" do
        let(:arguments) { described_class.new(*args, &block) }

        it "defaults `kwargs` to empty hash" do
          expect(arguments.kwargs).to eq({})
        end
      end

      context "when `block` is NOT passed" do
        let(:arguments) { described_class.new(*args, **kwargs) }

        it "defaults `block` to `nil`" do
          expect(arguments.block).to be_nil
        end
      end
    end

    describe "#null_arguments" do
      it "returns `RubyArguments::NullArguments` instance" do
        expect(RubyArguments.null_arguments).to be_instance_of(RubyArguments::NullArguments)
      end

      it "caches its value" do
        expect(RubyArguments.null_arguments.object_id).to eq(RubyArguments.null_arguments.object_id)
      end
    end
  end

  example_group "instance methods" do
    describe "#null_arguments?" do
      it "returns `false`" do
        expect(arguments.null_arguments?).to eq(false)
      end
    end

    describe "#any?" do
      context "when arguments have at least one arg" do
        let(:arguments) { described_class.new(*args) }

        it "returns `true`" do
          expect(arguments.any?).to eq(true)
        end
      end

      context "when arguments have at least one kwarg" do
        let(:arguments) { described_class.new(**kwargs) }

        it "returns `true`" do
          expect(arguments.any?).to eq(true)
        end
      end

      context "when arguments have block" do
        let(:arguments) { described_class.new(&block) }

        it "returns `true`" do
          expect(arguments.any?).to eq(true)
        end
      end

      context "when arguments do NOT have args, kwargs and block" do
        let(:arguments) { described_class.new }

        it "returns `false`" do
          expect(arguments.any?).to eq(false)
        end
      end
    end

    describe "#none?" do
      context "when arguments have at least one arg" do
        let(:arguments) { described_class.new(*args) }

        it "returns `false`" do
          expect(arguments.none?).to eq(false)
        end
      end

      context "when arguments have at least one kwarg" do
        let(:arguments) { described_class.new(**kwargs) }

        it "returns `false`" do
          expect(arguments.none?).to eq(false)
        end
      end

      context "when arguments have at block" do
        let(:arguments) { described_class.new(&block) }

        it "returns `false`" do
          expect(arguments.none?).to eq(false)
        end
      end

      context "when arguments do NOT have args, kwargs and block" do
        let(:arguments) { described_class.new }

        it "returns `true`" do
          expect(arguments.none?).to eq(true)
        end
      end
    end

    describe "#empty?" do
      context "when arguments have at least one arg" do
        let(:arguments) { described_class.new(*args) }

        it "returns `false`" do
          expect(arguments.empty?).to eq(false)
        end
      end

      context "when arguments have at least one kwarg" do
        let(:arguments) { described_class.new(**kwargs) }

        it "returns `false`" do
          expect(arguments.empty?).to eq(false)
        end
      end

      context "when arguments have at block" do
        let(:arguments) { described_class.new(&block) }

        it "returns `false`" do
          expect(arguments.empty?).to eq(false)
        end
      end

      context "when arguments do NOT have args, kwargs and block" do
        let(:arguments) { described_class.new }

        it "returns `true`" do
          expect(arguments.empty?).to eq(true)
        end
      end
    end

    describe "#present?" do
      context "when arguments have at least one arg" do
        let(:arguments) { described_class.new(*args) }

        it "returns `true`" do
          expect(arguments.present?).to eq(true)
        end
      end

      context "when arguments have at least one kwarg" do
        let(:arguments) { described_class.new(**kwargs) }

        it "returns `true`" do
          expect(arguments.present?).to eq(true)
        end
      end

      context "when arguments have block" do
        let(:arguments) { described_class.new(&block) }

        it "returns `true`" do
          expect(arguments.present?).to eq(true)
        end
      end

      context "when arguments do NOT have args, kwargs and block" do
        let(:arguments) { described_class.new }

        it "returns `false`" do
          expect(arguments.present?).to eq(false)
        end
      end
    end

    describe "#blank?" do
      context "when arguments have at least one arg" do
        let(:arguments) { described_class.new(*args) }

        it "returns `false`" do
          expect(arguments.blank?).to eq(false)
        end
      end

      context "when arguments have at least one kwarg" do
        let(:arguments) { described_class.new(**kwargs) }

        it "returns `false`" do
          expect(arguments.blank?).to eq(false)
        end
      end

      context "when arguments have at block" do
        let(:arguments) { described_class.new(&block) }

        it "returns `false`" do
          expect(arguments.blank?).to eq(false)
        end
      end

      context "when arguments do NOT have args, kwargs and block" do
        let(:arguments) { described_class.new }

        it "returns `true`" do
          expect(arguments.blank?).to eq(true)
        end
      end
    end

    describe "#[]" do
      context "when `key` is NOT valid" do
        let(:key) { "abc" }

        let(:exception_message) do
          <<~TEXT
            `#[]` accepts only `Integer` and `String` keys.

            Key `#{key.inspect}` has `#{key.class}` class.
          TEXT
        end

        it "raises `RubyArguments::Exceptions::InvalidKeyType`" do
          expect { arguments[key] }
            .to raise_error(RubyArguments::Exceptions::InvalidKeyType)
            .with_message(exception_message)
        end
      end

      context "when `key` is valid" do
        context "when `key` is integer" do
          let(:key) { 0 }

          it "returns arg by `key` (index)" do
            expect(arguments[key]).to eq(arguments.args[key])
          end
        end

        context "when `key` is symbol" do
          let(:key) { :foo }

          it "returns kwarg by `key`" do
            expect(arguments[key]).to eq(arguments.kwargs[key])
          end
        end
      end
    end

    example_group "comparison" do
      describe "#==" do
        subject(:arguments) { described_class.new(*args, **kwargs, &block) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `false`" do
            expect(arguments == other).to be_nil
          end
        end

        context "when `other` has different `args`" do
          let(:other) { described_class.new(:bar, **kwargs, &block) }

          it "returns `false`" do
            expect(arguments == other).to eq(false)
          end
        end

        context "when `other` has different `kwargs`" do
          let(:other) { described_class.new(*args, bar: :baz, &block) }

          it "returns `false`" do
            expect(arguments == other).to eq(false)
          end
        end

        context "when `other` has different `block`" do
          let(:other) { described_class.new(*args, **kwargs, &other_block) }
          let(:other_block) { proc { :bar } }

          it "returns `false`" do
            expect(arguments == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(*args, **kwargs, &block) }

          it "returns `true`" do
            expect(arguments == other).to eq(true)
          end
        end
      end

      describe "#eql?" do
        subject(:arguments) { described_class.new(*args, **kwargs, &block) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `false`" do
            expect(arguments.eql?(other)).to be_nil
          end
        end

        context "when `other` has different `args`" do
          let(:other) { described_class.new(:bar, **kwargs, &block) }

          it "returns `false`" do
            expect(arguments.eql?(other)).to eq(false)
          end
        end

        context "when `other` has different `kwargs`" do
          let(:other) { described_class.new(*args, bar: :baz, &block) }

          it "returns `false`" do
            expect(arguments.eql?(other)).to eq(false)
          end
        end

        context "when `other` has different `block`" do
          let(:other) { described_class.new(*args, **kwargs, &other_block) }
          let(:other_block) { proc { :bar } }

          it "returns `false`" do
            expect(arguments.eql?(other)).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(*args, **kwargs, &block) }

          it "returns `true`" do
            expect(arguments.eql?(other)).to eq(true)
          end
        end
      end

      describe "#hash" do
        it "returns hash based on class, `args`, `kwargs`, and `block`" do
          expect(arguments.hash).to eq([described_class, args, kwargs, block].hash)
        end

        context "when `block` in `nil`" do
          let(:block) { nil }

          it "uses `nil` hash for `block`" do
            expect(arguments.hash).to eq([described_class, args, kwargs, nil].hash)
          end
        end
      end
    end

    describe "#deconstruct" do
      let(:arguments) { described_class.new(*args, **kwargs, &block) }

      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      it "returns array with `args`, `kwargs` and `block`" do
        expect(arguments.deconstruct).to eq([args, kwargs, block])
      end
    end

    describe "#deconstruct_keys" do
      let(:arguments) { described_class.new(*args, **kwargs, &block) }

      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      context "when `keys` is NOT `nil`" do
        context "when `keys` is array with one key" do
          context "when `keys` is array with `:args` key" do
            it "returns hash with only `:args` key" do
              expect(arguments.deconstruct_keys([:args])).to eq({args: args})
            end
          end

          context "when `keys` is array with `:kwargs` key" do
            it "returns hash with only `:kwargs` key" do
              expect(arguments.deconstruct_keys([:kwargs])).to eq({kwargs: kwargs})
            end
          end

          context "when `keys` is array with `:block` key" do
            it "returns hash with only `:block` key" do
              expect(arguments.deconstruct_keys([:block])).to eq({block: block})
            end
          end

          context "when `keys` is array with unsupported key" do
            it "returns empty hash" do
              expect(arguments.deconstruct_keys([:unsupported])).to eq({})
            end
          end
        end

        context "when `keys` is array with multiple keys" do
          it "returns hash with only those multiple keys" do
            expect(arguments.deconstruct_keys([:args, :kwargs])).to eq({args: args, kwargs: kwargs})
            expect(arguments.deconstruct_keys([:args, :block])).to eq({args: args, block: block})
            expect(arguments.deconstruct_keys([:kwargs, :block])).to eq({kwargs: kwargs, block: block})
          end
        end
      end

      context "when `keys` is `nil`" do
        it "returns hash with all possible keys" do
          expect(arguments.deconstruct_keys(nil)).to eq({args: args, kwargs: kwargs, block: block})
        end
      end
    end
  end

  example_group "usage" do
    context "when used as hash keys" do
      let(:map) { {} }

      let(:value) { :foo }

      let(:command) do
        map[arguments] = value
        map[other_arguments] = value
      end

      context "when those keys do NOT cause collision (calling `#hash` returns different numbers)" do
        let(:arguments) { described_class.new(:foo) }
        let(:other_arguments) { described_class.new(:bar) }

        specify do
          allow(arguments).to receive(:hash).and_call_original

          command

          expect(arguments).to have_received(:hash)
        end

        specify do
          allow(other_arguments).to receive(:hash).and_call_original

          command

          expect(other_arguments).to have_received(:hash)
        end

        specify do
          allow(arguments).to receive(:eql?).and_call_original

          command

          expect(arguments).not_to have_received(:eql?)
        end

        specify do
          allow(other_arguments).to receive(:eql?).and_call_original

          command

          expect(other_arguments).not_to have_received(:eql?), "Flaky collision found: arguments.object_id - `#{arguments.object_id}`, other_arguments.object_id - `#{other_arguments.object_id}`, arguments.hash - `#{arguments.hash}`, other_arguments.hash - `#{other_arguments.hash}`."
        end
      end

      context "when those keys cause collision (calling `#hash` returns same numbers)" do
        let(:arguments) { described_class.new(:foo) }
        let(:other_arguments) { described_class.new(:foo) }

        specify do
          allow(arguments).to receive(:hash).and_call_original

          command

          expect(arguments).to have_received(:hash)
        end

        specify do
          allow(other_arguments).to receive(:hash).and_call_original

          command

          expect(other_arguments).to have_received(:hash)
        end

        specify do
          allow(arguments).to receive(:eql?).and_call_original

          command

          expect(arguments).not_to have_received(:eql?)
        end

        specify do
          allow(other_arguments).to receive(:eql?).and_call_original

          command

          expect(other_arguments).to have_received(:eql?)
        end

        context "when those keys are NOT equal in `#eql?` terms" do
          let(:collision_hash) { 42 }

          before do
            allow(arguments).to receive(:hash).and_return(collision_hash)
            allow(other_arguments).to receive(:hash).and_return(collision_hash)
          end

          context "when `#eql?` returns `nil`" do
            let(:arguments) { described_class.new(:foo) }
            let(:other_arguments) { Object.new }

            it "considers other key that caused collision as separate key" do
              command

              expect(map.keys.size).to eq(2)
            end
          end

          context "when `#eql?` returns `false`" do
            let(:arguments) { described_class.new(:foo) }
            let(:other_arguments) { described_class.new(:bar) }

            it "considers other key that caused collision as separate key" do
              command

              expect(map.keys.size).to eq(2)
            end
          end
        end

        context "when those keys are equal in `#eql?` terms" do
          context "when `#eql?` returns `true`" do
            let(:arguments) { described_class.new(:foo) }
            let(:other_arguments) { described_class.new(:foo) }

            it "considers other key that caused collision as same key" do
              command

              expect(map.keys.size).to eq(1)
            end
          end
        end
      end
    end
  end
end

RSpec.describe RubyArguments::Exceptions do
  specify { expect(described_class::Base.superclass).to eq(StandardError) }
  specify { expect(described_class::InvalidKeyType.superclass).to eq(described_class::Base) }
end

RSpec.describe RubyArguments::NullArguments do
  let(:null_arguments) { described_class.new }

  example_group "inheritance" do
    specify { expect(described_class.superclass).to eq(RubyArguments) }
  end

  example_group "instance methods" do
    describe "#args" do
      it "returns empty array" do
        expect(null_arguments.args).to eq([])
      end
    end

    describe "#kwargs" do
      it "returns empty hash" do
        expect(null_arguments.kwargs).to eq({})
      end
    end

    describe "#block" do
      it "returns `nil`" do
        expect(null_arguments.block).to be_nil
      end
    end

    describe "#null_arguments?" do
      it "returns `true`" do
        expect(null_arguments.null_arguments?).to eq(true)
      end
    end
  end
end
