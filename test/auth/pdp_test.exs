defmodule PDPTest do
  use ExUnit.Case

  alias OneM2MAuthorizator.PDP
  alias OneM2MAuthorizator.Model.Request

  @req %Request{id: "r01",
                 from: "c3po",
                 to: "smartbulb",
                 op: 2}
  @self_req %Request{id: "r02",
                  from: "c3po",
                  to: "authorizator",
                  op: 4}

  test "must authorize correct requests" do
    PDP.authorize @req
  end

  test "can check originator" do
    acr = %{origs: ["c3po"]}
    assert PDP.match_origs acr, @req
  end

  test "can check operations" do
    refute PDP.match_ops(%{ops: 2}, %Request{op: 1})
    assert PDP.match_ops(%{ops: 2}, %Request{op: 2})
    refute PDP.match_ops(%{ops: 2}, %Request{op: 3})
    refute PDP.match_ops(%{ops: 2}, %Request{op: 4})
    refute PDP.match_ops(%{ops: 2}, %Request{op: 5})
    refute PDP.match_ops(%{ops: 2}, %Request{op: 6})

    refute PDP.match_ops(%{ops: 6}, %Request{op: 1})
    assert PDP.match_ops(%{ops: 6}, %Request{op: 2})
    refute PDP.match_ops(%{ops: 6}, %Request{op: 3})
    assert PDP.match_ops(%{ops: 6}, %Request{op: 4})
    refute PDP.match_ops(%{ops: 6}, %Request{op: 5})
    assert PDP.match_ops(%{ops: 6}, %Request{op: 6})
  end

  test "context eval logic should check individual time window" do
    assert PDP.in_range? "*", "1"

    refute PDP.in_range? "1-5", "0"
    assert PDP.in_range? "1-5", "1"
    assert PDP.in_range? "1-5", "3"
    assert PDP.in_range? "1-5", "5"
    refute PDP.in_range? "1-5", "6"

    assert PDP.in_range? "6-22", "7"
  end

  test "context eval logic for time window ranges" do
   assert PDP.match_ranges []
   assert PDP.match_ranges [{"1-5", "1"},
                            {"11-15", "13"},
                            {"0-22", "6"}]
  end

  test "context eval logic for entire time window" do
    refute PDP.match_detailed_time "* * 6-22 * * *", "0 0  5 11 10 2015"
    assert PDP.match_detailed_time "* * 6-22 * * *", "0 0  6 11 10 2015"
    assert PDP.match_detailed_time "* * 6-22 * * *", "0 0 10 11 10 2015"
    assert PDP.match_detailed_time "* * 6-22 * * *", "0 0 22 11 10 2015"
    refute PDP.match_detailed_time "* * 6-22 * * *", "0 0 23 11 10 2015"

    assert PDP.match_ctxs_time_window "* * 6-22 * * *", "0 0 22 11 10 2015"
  end

  test "match context function" do
    ctx = %{ctxs: [
               %{
                 time_window: ["* * 6-22 * * *"]
               }
             ]}
    refute PDP.match_ctxs ctx, %{time: "0 0 5 0 0 0"}
    assert PDP.match_ctxs ctx, %{time: "0 0 7 0 0 0"}
    assert PDP.match_ctxs ctx, %{time: "0 0 22 0 0 0"}
    refute PDP.match_ctxs ctx, %{time: "0 0 23 0 0 0"}
  end

end
