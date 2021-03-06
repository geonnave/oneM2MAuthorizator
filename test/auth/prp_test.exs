defmodule PRPTest do
  use ExUnit.Case

  alias OneM2MAuthorizator.Model.Request

  @req %Request{acp_ids: ["admin_acp", "port_acp"],
                 to: "smartbulb",
                 from: "c3po",
                 op: 4}
  @self_req %Request{acp_ids: ["admin_acp"],
                  to: "authorizator",
                  from: "c3po",
                  op: 4}

  test "can open acps file" do
    file = OneM2MAuthorizator.PRP.read_acps_from_storage
    assert file != ""
  end

  test "shall read acps" do
    _acps = OneM2MAuthorizator.PRP.read_acps
  end

  test "shall get appropriate acp, given a request" do
    acp_rules = OneM2MAuthorizator.PRP.get_applicable_acp @req
    assert Enum.count(acp_rules) == 2
  end

end
