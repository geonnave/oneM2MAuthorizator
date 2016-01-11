defmodule OneM2MAuthorizator.PDP do
  alias OneM2MAuthorizator.PRP

  def authorize(request) do
    acps = PRP.get_applicable_acp request

    # implement decision logic

    false
  end

end
