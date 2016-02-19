defmodule OneM2MAuthorizator.Model.Request do
  defstruct from: "", to: "", op: 0, id: nil
end

defmodule OneM2MAuthorizator.Model.AccessControlPolicy do
  defstruct policy_id: "", rules: [], self_rules: []
end
