defmodule OneM2MAuthorizator.PRP do
  alias OneM2MAuthorizator.Model.Request
  alias OneM2MAuthorizator.Model.AccessControlPolicy
  alias OneM2MAuthorizator.Model.AccessControlRule
  alias OneM2MAuthorizator.Model.AccessControlContext

  @acps_file "acps.json"

  def get_applicable_acp(request) do
    use_self_rules = String.match?(request.to, ~r/authorizator.*/)

    acrs = read_acps
      |> Enum.filter(fn acp -> Enum.member?(request.acp_ids, acp.policy_id) end)
      |> Enum.map(fn acp -> if use_self_rules, do: acp.self_rules, else: acp.rules end)
      |> List.flatten
      |> Enum.filter(fn acr -> Enum.member?(acr.origs, request.from) end)

    %AccessControlPolicy{rules: acrs}
  end

  def read_acps do
    read_acps_from_storage |> Poison.decode! |> parse_acps
  end

  @doc """
  read Access Control Policies from permanent storage
  """
  def read_acps_from_storage do
    @acps_file |> File.read!
  end

  def parse_acps(acps_map) do
    for acp <- acps_map, do: parse_acp(acp)
  end

  def parse_acp(acp_map) do
    values = [policy_id: acp_map["policy_id"],
              rules: parse_acrs(acp_map["rules"]),
              self_rules: parse_acrs(acp_map["self_rules"])]
    struct(AccessControlPolicy, values)
  end

  def parse_acrs(acrs_map) do
    acrs_map
    |> Enum.map(&acr_map_to_kw/1)
    |> Enum.map(fn acr_kw -> struct(AccessControlRule, acr_kw) end)
  end

  def acr_map_to_kw(acr) do
    Enum.map(acr, fn({k, v}) ->
      case k do
        "ctxs" ->
          {String.to_atom(k), (for ctx <- Enum.map(v, &acr_map_to_kw/1), do: struct(AccessControlContext, ctx))}
        _ ->
          {String.to_atom(k), v}
      end
    end)
  end

end
