require 'test_helper'

class ChefTest < ActiveSupport::TestCase

  def setup
    @chef = Chef.new(chefname: "Julia", email: "julia@example.com")
  end

  test "should be valid" do
    assert @chef.valid?
  end

  test "chefname should be present" do
    @chef.chefname = " "
    assert_not @chef.valid?
  end

  test "chefname should be less than 30 characters" do
    @chef.chefname = "a" * 31
    assert_not @chef.valid?
  end

  test "email should be present" do
    @chef.email = ""
    assert_not @chef.valid?
  end

  test "email should not be too long" do
    @chef.email = "a" * 245 + "example.com"
    assert_not @chef.valid?
  end

  test "email should accept correct format" do
    valid_emails = %w[user@example.com JULIA@example.com J.first@yahoo.ca john+smith@co.uk.org]
    valid_emails.each do |email|
      @chef.email = email
      assert @chef.valid?, "#{email.inspect} should be valid"
    end
  end

  test "should reject invalid email addresses" do
    invalid_emails = %w[julia@example julia@example,com julia.name@gmail. julia@bar+for.com]
    invalid_emails.each do |email|
      @chef.email = email
      assert_not @chef.valid?, "#{email.inspect} should be invalid"
    end
  end

  test "email should be unique and case insentive" do
    duplicate_chef = @chef.dup
    duplicate_chef.email = @chef.email.upcase
    @chef.save
    assert_not duplicate_chef.valid?
  end

  test "email should be lower case before hitting db" do
    mixed_email = "JohN@Example.com"
    @chef.email = mixed_email
    @chef.save
    assert_equal mixed_email.downcase, @chef.reload.email
  end

end
