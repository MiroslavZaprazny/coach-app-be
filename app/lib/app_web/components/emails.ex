# lib/myapp_web/components/emails.ex
defmodule AppWeb.Emails do
  @moduledoc """
  Email templates and components.
  
  This module contains all email-specific templates and reusable email components.
  """

  use AppWeb, :html

  embed_templates "emails/*"

  # Email helper functions
  def format_date(date) when is_struct(date, DateTime) do
    Calendar.strftime(date, "%B %d, %Y")
  end
  
  def format_date(date) when is_struct(date, Date) do
    Calendar.strftime(date, "%B %d, %Y")
  end
  
  def format_date(_), do: ""
  
  def greeting_by_time do
    hour = DateTime.utc_now().hour
    
    cond do
      hour < 12 -> "Good morning"
      hour < 17 -> "Good afternoon"
      true -> "Good evening"
    end
  end
  
  def personalized_greeting(%{first_name: first_name}) when not is_nil(first_name) and first_name != "" do
    first_name
  end
  
  def personalized_greeting(%{email: email}) do
    email
  end
  
  def personalized_greeting(_), do: "there"

  # Reusable email components
  
  @doc """
  Renders an email button with consistent styling.
  
  ## Examples
  
      <.email_button url={@dashboard_url} text="Get Started" />
      <.email_button url={@reset_url} text="Reset Password" color="secondary" />
  """
  attr :url, :string, required: true
  attr :text, :string, required: true
  attr :color, :string, default: "primary"
  attr :class, :string, default: ""
  
  def email_button(assigns) do
    ~H"""
    <div style="text-align: center; margin: 32px 0;">
      <a 
        href={@url} 
        class={["btn", @color == "secondary" && "btn-secondary", @class]}
        style={[
          "display: inline-block;",
          "padding: 14px 28px;",
          "margin: 20px 0;",
          "color: #ffffff;",
          "text-decoration: none;",
          "border-radius: 6px;",
          "font-weight: 600;",
          "text-align: center;",
          if(@color == "secondary", do: "background-color: #6c757d;", else: "background-color: #667eea;")
        ] |> Enum.join(" ")}
      >
        <%= @text %>
      </a>
    </div>
    """
  end

  @doc """
  Renders a highlighted information box.
  
  ## Examples
  
      <.info_box>
        <h3>Important Information</h3>
        <p>This is some important content.</p>
      </.info_box>
  """
  attr :class, :string, default: ""
  slot :inner_block, required: true
  
  def info_box(assigns) do
    ~H"""
    <div style="background-color: #f8f9fa; padding: 24px; border-radius: 8px; margin: 24px 0; border-left: 4px solid #667eea;" class={@class}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a list of features or steps with consistent styling.
  
  ## Examples
  
      <.feature_list items={["Complete profile", "Explore features", "Connect with users"]} />
  """
  attr :items, :list, required: true
  attr :title, :string, default: nil
  
  def feature_list(assigns) do
    ~H"""
    <div style="background-color: #f8f9fa; padding: 24px; border-radius: 8px; margin: 24px 0;">
      <h3 :if={@title} style="margin-top: 0; color: #495057;"><%= @title %></h3>
      <ul style="margin-bottom: 0; padding-left: 20px;">
        <li :for={item <- @items} style="margin-bottom: 8px;">
          <%= item %>
        </li>
      </ul>
    </div>
    """
  end

  @doc """
  Renders a user profile section for emails.
  """
  attr :user, :map, required: true
  attr :show_avatar, :boolean, default: false
  
  def user_profile(assigns) do
    ~H"""
    <div style="border: 1px solid #e9ecef; border-radius: 8px; padding: 20px; margin: 20px 0; background-color: #ffffff;">
      <div style="display: flex; align-items: center;">
        <div :if={@show_avatar} style="margin-right: 15px;">
          <div style="width: 48px; height: 48px; border-radius: 50%; background-color: #667eea; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; font-size: 18px;">
            <%= String.first(@user.first_name || @user.email || "U") |> String.upcase() %>
          </div>
        </div>
        <div>
          <h4 style="margin: 0 0 5px 0; color: #333;">
            <%= personalized_greeting(@user) %>
          </h4>
          <p style="margin: 0; color: #6c757d; font-size: 14px;">
            <%= @user.email %>
          </p>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders a metrics/stats section for emails.
  """
  attr :metrics, :list, required: true
  
  def metrics_section(assigns) do
    ~H"""
    <div style="background-color: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0;">
      <div style="display: flex; justify-content: space-around; text-align: center;">
        <div :for={metric <- @metrics} style="flex: 1;">
          <div style="font-size: 24px; font-weight: bold; color: #667eea; margin-bottom: 5px;">
            <%= metric.value %>
          </div>
          <div style="font-size: 14px; color: #6c757d;">
            <%= metric.label %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders a social media links section.
  """
  attr :links, :list, default: []
  
  def social_links(assigns) do
    assigns = assign(assigns, :default_links, [
      %{name: "Twitter", url: "https://twitter.com/myapp", icon: "🐦"},
      %{name: "Facebook", url: "https://facebook.com/myapp", icon: "📘"},
      %{name: "LinkedIn", url: "https://linkedin.com/company/myapp", icon: "💼"}
    ])
    
    ~H"""
    <div style="text-align: center; margin: 30px 0;">
      <p style="color: #6c757d; margin-bottom: 15px;">Follow us on social media:</p>
      <div>
        <a 
          :for={link <- if(@links != [], do: @links, else: @default_links)}
          href={link.url} 
          style="margin: 0 10px; text-decoration: none; color: #667eea; font-size: 18px;"
          title={link.name}
        >
          <%= link.icon %>
        </a>
      </div>
    </div>
    """
  end

  @doc """
  Renders a quote or testimonial section.
  """
  attr :quote, :string, required: true
  attr :author, :string, required: true
  attr :title, :string, default: nil
  
  def quote_section(assigns) do
    ~H"""
    <div style="border-left: 4px solid #667eea; padding: 20px; margin: 30px 20px; background-color: #f8f9fa; font-style: italic;">
      <p style="font-size: 16px; line-height: 1.6; margin-bottom: 15px; color: #495057;">
        "<%= @quote %>"
      </p>
      <div style="text-align: right; font-style: normal;">
        <strong><%= @author %></strong>
        <span :if={@title} style="color: #6c757d;"><br><%= @title %></span>
      </div>
    </div>
    """
  end
end
