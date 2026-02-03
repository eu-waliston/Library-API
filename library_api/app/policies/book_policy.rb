# frozen_string_literal: true

class BookPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scole.all
      elsif user.librarian?
        scope.all
      else
        scope.where(status: :published)
      end
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.librarian? || user.admin?
  end

  def update?
    user.librarian? || user.admin?
  end

  def destroy?
    user.admin?
  end

  def borrow?
    user.present? && user.can_borrow?
  end

  def recommendations?
    user.present?
  end
end