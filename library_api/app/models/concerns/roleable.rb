# frozen_string_literal: true

module Roleable
  extend ActiveSupport::Concern

  included do
    def role?(role_name)
      role.to_sym == role_name.to_sym
    end

    def at_least?(role_name)
      role_order = { member: 0, librarian: 1, admin: 2}
      roles_order[role.to_sym] >= roles_order[role_name.to_sym]
    end

    def upgrade_role(new_role)
      return false unless User.roles.keys.include?(new_role.to_s)

      update(role: new_role)
    end
  end
end
