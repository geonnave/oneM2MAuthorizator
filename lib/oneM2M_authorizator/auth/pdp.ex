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
    match_origs(rule, request) && match_ops(rule, request) && match_ctxs(rule, PIP.fetch_context(request))
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

  def match_ctxs(%{ctxs: nil}, _req_ctxs), do: true
  def match_ctxs(%{ctxs: []}, _req_ctxs), do: true
  def match_ctxs(%{ctxs: acr_ctxs}, req_ctxs) do
    # logic for check contexts
    true
  end

  def match_ctxs_time_window(time_window, req_time) do
    if Regex.match?(~r/[0-6]([,-][0-6])*/, time_window) do
      true # TODO: implement match_week_day
    else
      match_detailed_time(time_window, req_time)
    end
  end

  def match_detailed_time(time_window, req_time) do
    match_detailed_time(String.split(time_window, ~r/\s+/), String.split(time_window, ~r/\s+/))
  end
  def match_detailed_time(time_window, req_time) when is_list(time_window) and is_list(req_time) do
    [time_window, req_time]
    |> List.zip
    #|> Enum.reduce(false, fn({tw_unit, rt_unit}, acc) -> acc || match_unit_of_time(tw_unit, rt_unit))
  end

end
