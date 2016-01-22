defmodule OneM2MAuthorizator.PDP do
  alias OneM2MAuthorizator.PRP
  alias OneM2MAuthorizator.Model.Request
  alias OneM2MAuthorizator.Model.AccessControlRule
  alias OneM2MAuthorizator.Model.AccessControlPolicy

  use Bitwise

  def authorize(request) do
    acp_rules = PRP.get_applicable_acp request

    Enum.reduce(acp_rules, false, fn(rule, acc) ->
      acc || match(rule, request)
    end)
  end

  def match(rule, %Request{from: from, op: op} = request) do
    match_origs(rule, request) && match_ctxs(rule, nil)
  end

  def match_origs(%{origs: acr_froms}, %Request{from: req_from}) do
    Enum.member? acr_froms, req_from
  end

  def match_ops(%{ops: acr_ops}, %Request{op: req_ops}) do
    do_match_ops(acr_ops, req_ops, 3) == 1
  end

  defp do_match_ops(acr_ops, req_ops, 0), do: match_op_bit(acr_ops, req_ops, 0)
  defp do_match_ops(acr_ops, req_ops, offset) do
    case match_op_bit(acr_ops, req_ops, offset) do
      1 -> do_match_ops(acr_ops, req_ops, offset-1)
      0 -> 0
    end
  end

  defp match_op_bit(acr_op, req_op, offset) do
    match_op_bit(acr_op >>> offset, req_op >>> offset)
  end
  defp match_op_bit(acr_op, req_op) do
    bor(rem(acr_op, 2), bnot_integer(rem(req_op, 2)))
  end

  defp bnot_integer(x), do: if x == 0, do: 1, else: 0

  def match_ctxs(%{ctxs: acr_ctxs}, req_ctxs) do
    # logic for check contexts
    true
  end

end
