defmodule PRPTest do
  use ExUnit.Case

  alias OneM2MAuthorizator.Model.Request
  alias OneM2MAuthorizator.Model.AccessControlPolicy

  @sample_rule "{\"origs\": [\"root\",\"admin\"],\"ops\": 63}"
  @array_rule "[{\"origs\": [\"root\",\"admin\"],\"ops\": 63},{\"origs\": [\"c3po\"],\"ops\": 6}]"

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

  test "shall get appropriate acp, given a request" do
    acp = %AccessControlPolicy{rules: [first | rest]} = OneM2MAuthorizator.PRP.get_applicable_acp @req
    assert Enum.count(acp.rules) == 2
  end

  test "shall convert a acr map to keyword list" do
    res = OneM2MAuthorizator.PRP.acr_map_to_kw(Poison.decode! @sample_rule)
    assert res[:ops] == 63
    assert is_list(res[:origs])
  end

  test "shall convert json-encoded acrs to AccessControlRule structs" do
    res = OneM2MAuthorizator.PRP.parse_acrs(Poison.decode! @array_rule)
    assert %OneM2MAuthorizator.Model.AccessControlRule{} = Enum.at(res, 0)
  end

end
