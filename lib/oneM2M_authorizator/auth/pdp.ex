defmodule OneM2MAuthorizator.PDP do
  alias OneM2MAuthorizator.PRP
  alias OneM2MAuthorizator.Model.Request
  alias OneM2MAuthorizator.Model.AccessControlRule
  alias OneM2MAuthorizator.Model.AccessControlPolicy

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

  def match_ops(acr_ops, req_ops) when is_list(acr_ops) and is_list(req_ops) do
    true
  end
  def match_ops(acr_ops, req_ops) when not is_list(acr_ops), do: match_ops(Integer.digits(acr_ops, 2), req_ops)
  def match_ops(acr_ops, req_ops) when not is_list(req_ops), do: match_ops(acr_ops, Integer.digits(req_ops, 2))

  def match_ctxs(%{ctxs: acr_ctxs}, req_ctxs) do
    # logic for check contexts
    true
  end

end
