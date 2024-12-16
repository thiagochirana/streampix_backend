require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end

  test "should not allow password with spaces" do
    user = User.new(nickname: "TestUser", email: "test@example.com", password: "password with space", password_confirmation: "password with space")
    assert_not user.valid?
    assert_includes user.errors[:password], "não pode conter espaços"
  end

  test "should not allow password with accents or special characters" do
    user = User.new(nickname: "TestUser", email: "test@example.com", password: "pásswórdÇ", password_confirmation: "pásswórdÇ")
    assert_not user.valid?
    assert_includes user.errors[:password], "não pode conter acentos ou caracteres especiais como Ç"
  end

  test "should authenticate user with correct password" do
    user = User.authenticating({ login: @user.email, password: "password123" })
    assert user.is_a?(User)
    assert_empty user.errors
  end

  test "should not authenticate user with incorrect password" do
    user = User.authenticating({ login: @user.email, password: "wrongpassword" })
    assert_not user.is_a?(User)
    assert_includes user.errors[:base], "Senha e Confirmação de Senha estão diferentes"
  end
end
