defmodule PRPTest do
  use ExUnit.Case

  alias OneM2MAuthorizator.Model.Request

  @sample_rule "{\"origs\": [\"root\",\"admin\"],\"ops\": 63}"
  @array_rule "[{\"origs\": [\"root\",\"admin\"],\"ops\": 63},{\"origs\": [\"c3po\"],\"ops\": 6}]"

  test "can open acps file" do
    file = OneM2MAuthorizator.PRP.read_acps_from_storage
    assert file != ""
  end

  #@tag: skip
  test "shall get appropriate acp, given a request" do
    req = %Request{from: "c3po", to: "port", op: 2, id: 1, acp_ids: ["admin_acp", "port_acp"]}
  end

  test "shall convert a json-encoded acr to an AccessControlRule struct" do
    res = OneM2MAuthorizator.PRP.acr_json_to_struct(@sample_rule)
    assert res.ops == 63
    assert is_list(res.origs)
  end

end
