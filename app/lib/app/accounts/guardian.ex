defmodule App.Accounts.Guardian do
  use Guardian, otp_app: :auth_me
  alias App.Accounts
  alias Ecto.NoResultsError

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    user = Accounts.get_user!(id)
    {:ok, to_string(user)}
    rescue
      NoResultsError -> {:error, :resource_not_found}
  end
end
