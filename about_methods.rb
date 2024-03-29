# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/neo')
# rubocop:disable Naming/UncommunicativeMethodParamName
def my_global_method(a, b)
  # rubocop:enable Naming/UncommunicativeMethodParamName
  a + b
end
#:reek:all:
#:nodoc:
class AboutMethods < Neo::Koan
  def test_calling_global_methods
    assert_equal 5, my_global_method(2, 3)
  end

  def test_calling_global_methods_without_parentheses
    result = my_global_method 2, 3
    assert_equal 5, result
  end

  # (NOTE: We are Using eval below because the example code is
  # considered to be syntactically invalid).
  def test_sometimes_missing_parentheses_are_ambiguous
    assert_equal 5, my_global_method(2, 3) # ENABLE CHECK
    #
    # Ruby doesn't know if you mean:
    #
    #   assert_equal(5, my_global_method(2), 3)
    # or
    #   assert_equal(5, my_global_method(2, 3))
    #
    # Rewrite the eval string to continue.
    #
  end

  # NOTE: wrong number of arguments is not a SYNTAX error, but a
  # runtime error.
  def test_calling_global_methods_with_wrong_number_of_arguments
    exception = assert_raise(ArgumentError) do
      my_global_method
    end
    assert_match(/wrong number of arguments/, exception.message)

    exception = assert_raise(ArgumentError) do
      my_global_method(1, 2, 3)
    end
    assert_match(/wrong number of arguments/, exception.message)
  end

  # ------------------------------------------------------------------
  # rubocop:disable Naming/UncommunicativeMethodParamName
  def method_with_defaults(a, b = :default_value)
    # rubocop:enable Naming/UncommunicativeMethodParamName
    [a, b]
  end

  def test_calling_with_default_values
    assert_equal [1, :default_value], method_with_defaults(1)
    assert_equal [1, 2], method_with_defaults(1, 2)
  end

  # ------------------------------------------------------------------

  def method_with_var_args(*args)
    args
  end

  def test_calling_with_variable_arguments
    assert_equal Array, method_with_var_args.class
    assert_equal [], method_with_var_args
    assert_equal [:one], method_with_var_args(:one)
    assert_equal %i[one two], method_with_var_args(:one, :two)
  end

  # ------------------------------------------------------------------

  def method_with_explicit_return
    # rubocop:disable Lint/Void
    :a_non_return_value
    # rubocop:enable Lint/Void
    return :return_value
    # rubocop:disable Lint/UnreachableCode
    :another_non_return_value
    # rubocop:enable Lint/UnreachableCode
  end

  def test_method_with_explicit_return
    assert_equal :return_value, method_with_explicit_return
  end

  # ------------------------------------------------------------------

  def method_without_explicit_return
    # rubocop:disable Lint/Void
    :a_non_return_value
    # rubocop:enable Lint/Void
    :return_value
  end

  def test_method_without_explicit_return
    assert_equal :return_value, method_without_explicit_return
  end

  # ------------------------------------------------------------------
  # rubocop:disable Naming/UncommunicativeMethodParamName
  def my_method_in_the_same_class(a, b)
    # rubocop:enable Naming/UncommunicativeMethodParamName
    a * b
  end

  def test_calling_methods_in_same_class
    assert_equal 12, my_method_in_the_same_class(3, 4)
  end

  #:nodoc:
  def test_calling_methods_in_same_class_with_explicit_receiver
    assert_equal 12, my_method_in_the_same_class(3, 4)
  end

  # ------------------------------------------------------------------

  def my_private_method
    'a secret'
  end

  private :my_private_method

  def test_calling_private_methods_without_receiver
    assert_equal 'a secret', my_private_method
  end

  def test_calling_private_methods_with_an_explicit_receiver
    exception = assert_raise(NoMethodError) do
      # rubocop:disable Style/RedundantSelf
      self.my_private_method
      # rubocop:enable Style/RedundantSelf
    end
    # rubocop:disable Lint/AmbiguousRegexpLiteral
    assert_match /private method/, exception.message
    # rubocop:enable Lint/AmbiguousRegexpLiteral
  end

  # ------------------------------------------------------------------
  #:nodoc:
  class Dog
    def name
      'Fido'
    end

    private

    def tail
      'tail'
    end
  end

  def test_calling_methods_in_other_objects_require_explicit_receiver
    rover = Dog.new
    assert_equal 'Fido', rover.name
  end

  def test_calling_private_methods_in_other_objects
    rover = Dog.new
    assert_raise(NoMethodError) do
      rover.tail
    end
  end
end
