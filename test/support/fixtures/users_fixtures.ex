defmodule Mimdb.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mimdb.Users` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def unique_user_name, do: "John#{System.unique_integer()} Doe"
  def valid_user_password, do: "hello world!"

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        name: unique_user_name(),
        password: valid_user_password()
      })
      |> Mimdb.Users.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token, _] = String.split(captured.body, "[TOKEN]")
    token
  end
end
