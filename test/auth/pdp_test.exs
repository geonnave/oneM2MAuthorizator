defmodule PDPTest do
  use ExUnit.Case

  alias OneM2MAuthorizator.PDP
  alias OneM2MAuthorizator.Model.Request
  alias OneM2MAuthorizator.Model.AccessControlRule

  @sample_rule "{\"origs\": [\"root\",\"admin\"],\"ops\": 63}"
  @array_rule "[{\"origs\": [\"root\",\"admin\"],\"ops\": 63},{\"origs\": [\"c3po\"],\"ops\": 6}]"

  @req %Request{acp_ids: ["admin_acp", "port_acp"],
                 to: "smartbulb",
                 from: "c3po",
                 op: 2}
  @self_req %Request{acp_ids: ["admin_acp"],
                  to: "authorizator",
                  from: "c3po",
                  op: 4}

  test "must authorize correct requests" do
    _res = PDP.authorize @req
  end

  test "can check originator" do
    acr = %AccessControlRule{origs: ["c3po"]}
    assert PDP.match_origs acr, @req
  end

  test "can check operations" do
    refute PDP.match_ops(%AccessControlRule{ops: 2}, %Request{op: 1})
    assert PDP.match_ops(%AccessControlRule{ops: 2}, %Request{op: 2})
    refute PDP.match_ops(%AccessControlRule{ops: 2}, %Request{op: 3})
    refute PDP.match_ops(%AccessControlRule{ops: 2}, %Request{op: 4})
    refute PDP.match_ops(%AccessControlRule{ops: 2}, %Request{op: 5})
    refute PDP.match_ops(%AccessControlRule{ops: 2}, %Request{op: 6})

    refute PDP.match_ops(%AccessControlRule{ops: 6}, %Request{op: 1})
    assert PDP.match_ops(%AccessControlRule{ops: 6}, %Request{op: 2})
    refute PDP.match_ops(%AccessControlRule{ops: 6}, %Request{op: 3})
    assert PDP.match_ops(%AccessControlRule{ops: 6}, %Request{op: 4})
    refute PDP.match_ops(%AccessControlRule{ops: 6}, %Request{op: 5})
    assert PDP.match_ops(%AccessControlRule{ops: 6}, %Request{op: 6})
  end

end
