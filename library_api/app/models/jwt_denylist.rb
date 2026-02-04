# frozen_string_literal: true

class JwtDenylist < AplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  self.table_name = 'jwt_denylists'
end