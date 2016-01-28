defmodule OneM2MAuthorizator.PIP do
  alias OneM2MAuthorizator.Model.Request

  def fetch_context(%Request{}) do
    %{time: fetch_time,
      location: nil,
      ip_addr: nil}
  end

  def fetch_time do
    :os.timestamp |> :calendar.now_to_datetime |> format_date_time
  end

  def format_date_time({{year, month, day}, {hour, min, sec}}) do
    "#{sec} #{min} #{hour} #{day} #{month} #{year}"
  end

end
