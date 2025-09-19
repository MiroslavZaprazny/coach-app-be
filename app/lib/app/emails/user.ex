defmodule App.Emails.User do
  use Phoenix.Swoosh, view: AppWeb.Emails, layout: {AppWeb.Layouts, :email}

  import Swoosh.Email

  @from_email "noreply@myapp.com"
  @from_name "MyApp Team"

  def registration_confirmation_email(user) do
    new()
    |> to(user.email)
    |> from({@from_name, @from_email})
    |> subject("Confirmaion code")
    |> render_body("registration_confirmation.html", %{
      user: user,
      company_name: "MyApp",
      dashboard_url: "",
      unsubscribe_url: "",
      preferences_url: "",
      support_url: "",
      company_address: "123 Innovation Drive, Tech City, TC 12345"
    })
  end
end
