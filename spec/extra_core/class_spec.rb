require 'spec_helper'
require 'volt/extra_core/array'

class TestClassAttributes
  class_attribute :some_data
  class_attribute :attr2
  class_attribute :dup_test
end

class TestSubClassAttributes < TestClassAttributes
end

class TestSubClassAttributes2 < TestClassAttributes
end

describe 'extra_core class addons' do
  it 'should provide class_attributes that can be inherited' do
    expect(TestClassAttributes.some_data).to eq(nil)

    TestClassAttributes.some_data = 5
    expect(TestClassAttributes.some_data).to eq(5)
    expect(TestSubClassAttributes.some_data).to eq(5)
    expect(TestSubClassAttributes2.some_data).to eq(5)

    TestSubClassAttributes.some_data = 10
    expect(TestClassAttributes.some_data).to eq(5)
    expect(TestSubClassAttributes.some_data).to eq(10)
    expect(TestSubClassAttributes2.some_data).to eq(5)

    TestSubClassAttributes2.some_data = 15
    expect(TestClassAttributes.some_data).to eq(5)
    expect(TestSubClassAttributes.some_data).to eq(10)
    expect(TestSubClassAttributes2.some_data).to eq(15)
  end

  it 'should let you change a class attribute on the child without affecting the parent' do
    TestClassAttributes.attr2 = 1
    expect(TestSubClassAttributes.attr2).to eq(1)

    TestSubClassAttributes.attr2 = 2
    expect(TestClassAttributes.attr2).to eq(1)
    expect(TestSubClassAttributes.attr2).to eq(2)
    expect(TestSubClassAttributes2.attr2).to eq(1)
  end

  it 'should dup the class_attribute when you read it from a child class' do
    TestClassAttributes.dup_test = {one: 1}

    TestSubClassAttributes.dup_test[:two] = 2

    expect(TestClassAttributes.dup_test).to eq({one: 1})
    expect(TestSubClassAttributes.dup_test).to eq({one: 1, two: 2})
  end
end
