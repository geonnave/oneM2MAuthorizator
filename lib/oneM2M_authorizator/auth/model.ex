defmodule OneM2MAuthorizator.Model.Request do
  defstruct from: "", to: "", op: 0, id: nil, acp_ids: []
end

defmodule OneM2MAuthorizator.Model.AccessControlPolicy do
  alias OneM2MAuthorizator.Model.AccessControlRule
  defstruct policy_id: "", rules: [AccessControlRule], self_rules: [AccessControlRule]
end
defmodule OneM2MAuthorizator.Model.AccessControlRule do
  defstruct origs: [], ops: 0, ctxs: nil 
end
defmodule OneM2MAuthorizator.Model.AccessControlContext do
  defstruct time_window: [], location: nil, ip_addr: nil
end
