defmodule OneM2MAuthorizator.PDP do
  alias OneM2MAuthorizator.PRP
  alias OneM2MAuthorizator.PIP
  alias OneM2MAuthorizator.Model.Request

  use Bitwise

  @max_operations_number 5

  def authorize(request) do
    acp_rules = PRP.get_applicable_acp request

    Enum.reduce(acp_rules, false, fn(rule, acc) ->
      acc || match(rule, request)
    end)
  end

  def match(rule, %Request{} = request) do
    match_origs(rule, request) && match_ops(rule, request) && match_ctxs(rule, nil)
  end

  def match_origs(%{origs: acr_froms}, %Request{from: req_from}) do
    Enum.member? acr_froms, req_from
  end

  def match_ops(%{ops: acr_ops}, %Request{op: req_ops}) do
    match_ops(acr_ops, req_ops, 0)
  end

  defp match_ops(acr_ops, req_ops, @max_operations_number), do: match_op_bit(acr_ops, req_ops, 0)
  defp match_ops(acr_ops, req_ops, offset) do
    if match_op_bit(acr_ops, req_ops, offset) do
      match_ops(acr_ops, req_ops, offset+1)
    else
      false
    end
  end

  defp match_op_bit(acr_op, req_op, offset) do
    match_op_bit(acr_op >>> offset, req_op >>> offset) == 1
  end
  defp match_op_bit(acr_op, req_op) do
    rem(acr_op, 2) ||| bnot_integer(rem(req_op, 2))
  end

  defp bnot_integer(x), do: if x == 0, do: 1, else: 0

  def match_ctxs(%{ctxs: acr_ctxs}, req_ctxs) do
    IO.inspect req_ctxs
    # logic for check contexts
    true
  end

end
