defmodule OneM2MAuthorizator.Model.Request do
  defstruct from: "", to: "", op: 0, id: nil, acp_ids: []
end
defmodule OneM2MAuthorizator.Model.AccessControlPolicy do
  alias OneM2MAuthorizator.Model.AccessControlRule
  defstruct name: "", rules: [AccessControlRule], self_rules: [AccessControlRule]
end
defmodule OneM2MAuthorizator.Model.AccessControlRule do
  defstruct origs: [], ops: 0, ctxs: [OneM2MAuthorizator.Model.AccessControlContext]
end
defmodule OneM2MAuthorizator.Model.AccessControlContext do
  defstruct time_window: [], location: nil, ip_addr: nil
end

defmodule OneM2MAuthorizator.PRP do
  alias OneM2MAuthorizator.Model.Request
  alias OneM2MAuthorizator.Model.AccessControlPolicy
  alias OneM2MAuthorizator.Model.AccessControlRule
  alias OneM2MAuthorizator.Model.AccessControlContext

  @acps_file "acps.json"

  @doc """
  read Access Control Policies from permanent storage
  """
  def read_acps_from_storage do
    @acps_file |> File.read!
  end

  def get_applicable_acp(request) do
    ""
  end

  def acr_json_to_struct(acr_json) do
    Poison.decode! acr_json, as: AccessControlRule
  end

end
