# frozen_string_literal: true

# This module adds helper functions for positions in a scope
#
# Usage:
#
# class Question < ApplicationRecord
#   include HasPosition
#   ...
#   position_scope :quiz
#   ...
# end
#

module HasPosition

  extend ActiveSupport::Concern

  included do
    before_save :set_to_last_position, if: -> { position.blank? }
  end

  class_methods do
    def position_scope(model_scope)
      cattr_accessor :model_scope

      self.model_scope ||= model_scope
    end

    def reorder_positions(order_ids = [])
      order_ids.each_with_index do |id, index|
        where(id: id).update_all(position: index + 1)
      end
    end
  end

  private

  def set_to_last_position
    return unless defined?(model_scope)

    scope = send(model_scope)
    last = scope.send(self.class.table_name).maximum(:position).to_i
    self.position = last + 1
  end

end
