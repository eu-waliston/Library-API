# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes  :id, :email, :first_name, :last_name, :full_name, :role, :phone, :created_at, :active_loans_count

  def active_loans_count
    object.active_loans.count
  end

  def attributes(*args)
    hash = super

    # Remove informações sensveis para não-admins
    unless scope&.admin?
      hash.delete(:email)
      hash.delete(:phone)
    end

    hash
  end
end

