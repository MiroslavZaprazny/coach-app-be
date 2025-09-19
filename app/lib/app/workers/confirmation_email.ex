defmodule App.Workers.ConfirmationEmail do
  use Oban.Worker, queue: :accounts

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"user" => user} = _args}) do
    # We make sure that the user exists just in case
    case App.Accounts.get(user.id) do
      nil ->
        {:error, :user_not_found}

      user ->
        App.Emails.User.registration_confirmation_email(user)
        |> App.Mailer.deliver()
    end

    :ok
  end
end
