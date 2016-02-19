defmodule PIPTest do
  use ExUnit.Case

  alias OneM2MAuthorizator.Model.Request
  alias OneM2MAuthorizator.PIP

  @req %Request{id: "r01",
                to: "smartbulb",
                from: "c3po",
                op: 4}

  test "fetch request context time" do
    %{time: time} = PIP.fetch_context @req
    assert Regex.match?(~r/[0-9]+ [0-9]+ [0-9]+ [0-9]+ [0-9]+ [0-9]{4}/, time)
  end

end
