defmodule OneM2MAuthorizator.PRP do
  alias OneM2MAuthorizator.Model.Request
  alias OneM2MAuthorizator.Model.AccessControlPolicy

  @acps_file "acps.json"

  def get_applicable_acp(request) do
    use_self_rules = String.match?(request.to, ~r/authorizator.*/)

    acrs = read_acps
      #|> Enum.filter(fn acp -> Enum.member?(request.acp_ids, acp.policy_id) end)
      |> Enum.map(fn acp -> if use_self_rules, do: acp.self_rules, else: acp.rules end)
      |> List.flatten
      |> Enum.filter(fn acr -> Enum.member?(acr.origs, request.from) end)

      acrs
  end

  def read_acps do
    read_acps_from_storage
    |> Poison.decode!(as: [%AccessControlPolicy{}], keys: :atoms )
  end

  @doc """
  read Access Control Policies from permanent storage
  """
  def read_acps_from_storage do
    @acps_file |> File.read!
  end

end
