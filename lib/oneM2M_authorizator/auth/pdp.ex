defmodule OneM2MAuthorizator.PDP do
  alias OneM2MAuthorizator.PRP
  alias OneM2MAuthorizator.Model.Request
  alias OneM2MAuthorizator.Model.AccessControlRule
  alias OneM2MAuthorizator.Model.AccessControlPolicy

  def authorize(request) do
    %AccessControlPolicy{rules: acp_rules} = PRP.get_applicable_acp request

    Enum.reduce(acp_rules, false, fn(rule, acc) ->
      acc || match(rule, request)
    end)
  end

  def match(rule, %Request{from: from, op: op} = request) do
    match_origs(rule, request) && match_ops(rule, request) && match_ctxs(rule, nil)
  end

  def match_origs(%AccessControlRule{origs: acr_froms}, %Request{from: req_from}) do
    Enum.member? acr_froms, req_from
  end

  def match_ops(
        %AccessControlRule{
              ops: acr_ops =
                << create :: size(1), retrieve :: size(1), update :: size(1),
                  delete :: size(1), discover :: size(1), notify :: size(1), _rest :: binary >>
        }, %Request{
              op: req_op =
                << r_create :: size(1), r_retrieve :: size(1), r_update :: size(1),
                r_delete :: size(1), r_discover :: size(1), r_notify :: size(1), _rest :: binary >>
        }
    ) do
    # logic for check op
    true
  end

  def match_ctxs(%AccessControlRule{ctxs: acr_ctxs}, req_ctxs) do
    # logic for check contexts
    true
  end

end
