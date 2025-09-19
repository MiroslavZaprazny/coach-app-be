defmodule AppWeb.Layouts do
  @moduledoc """
  This module contains different layouts used by your application.

  See the `layouts` directory for all templates.
  """

  use AppWeb, :html

  embed_templates "layouts/*"

  # Helper functions that can be used in layout templates
  def page_title(assigns) do
    assigns[:title] || "MyApp"
  end
  
  def company_name(assigns) do
    assigns[:company_name] || "MyApp"
  end
  
  def current_year do
    Date.utc_today().year
  end
  
  def company_address(assigns) do
    assigns[:company_address] || "123 Innovation Drive, Tech City, TC 12345"
  end

  # Email-specific layout helpers
  def email_header_color(assigns) do
    assigns[:header_color] || "#667eea"
  end
  
  def email_button_color(assigns) do
    assigns[:button_color] || "#667eea"
  end
end
