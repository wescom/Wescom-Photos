class User < ApplicationRecord
  include Adauth::Rails::ModelBridge

  AdauthMappings = {
      :login => :login,
      :group_strings => :cn_groups,
      :ou_strings => :dn_ous,
      :name => :name
  }

  AdauthSearchField = [:login, :login]

end
