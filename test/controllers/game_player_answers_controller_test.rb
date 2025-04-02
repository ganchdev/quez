# frozen_string_literal: true

require "test_helper"

class GamePlayerAnswersControllerTest < ActionDispatch::IntegrationTest

  # Helper controller for testing private method
  class TestableGamePlayerAnswersController < GamePlayerAnswersController

    public :calculate_speed_bonus

  end

  def setup
    @controller = TestableGamePlayerAnswersController.new
  end

  # High-point questions (points > 10) – exponential-like scaling

  test "high-point fast answer (0s)" do
    bonus = @controller.calculate_speed_bonus(40, 0)
    assert_equal 12, bonus # 40 * 0.3 = 12, scale = 1 (max possible cuz quick) -> bonus = 12
  end

  test "high-point exact 2s" do
    bonus = @controller.calculate_speed_bonus(40, 2)
    # scale = (8 - 2) / 6 = 1.0 → 12 bonus
    assert_equal 12, bonus
  end

  test "high-point exact 4s" do
    bonus = @controller.calculate_speed_bonus(40, 4)
    assert_equal 8, bonus
  end

  test "high-point exact 6s" do
    bonus = @controller.calculate_speed_bonus(40, 6)
    assert_equal 4, bonus
  end

  test "high-point exact 8s" do
    bonus = @controller.calculate_speed_bonus(40, 8)
    assert_equal 0, bonus
  end

  test "high-point just under 8s" do
    bonus = @controller.calculate_speed_bonus(40, 7.9)
    assert_equal 0, bonus
  end

  test "high-point borderline (10 points) should behave like low-point" do
    bonus = @controller.calculate_speed_bonus(10, 1)
    assert_equal 3, bonus
  end

  test "very high-point question fast answer" do
    bonus = @controller.calculate_speed_bonus(1000, 0)
    # max_bonus = 300, scale = 8 / 6 = 1..., bonus = 300
    assert_equal 300, bonus
  end

  test "high-point negative time (should scale up)" do
    bonus = @controller.calculate_speed_bonus(50, -2)
    assert_equal 15, bonus
  end

  # Low-point questions (<= 10) – fixed tiers

  test "low-point exact 2s" do
    bonus = @controller.calculate_speed_bonus(6, 2)
    assert_equal 3, bonus
  end

  test "low-point exact 4s" do
    bonus = @controller.calculate_speed_bonus(6, 4)
    assert_equal 2, bonus # falls into 2..4 range (.. is inclusive)
  end

  test "low-point edge 6s" do
    bonus = @controller.calculate_speed_bonus(6, 6)
    assert_equal 1, bonus
  end

  test "low-point above 6s" do
    bonus = @controller.calculate_speed_bonus(6, 6.1)
    assert_equal 0, bonus
  end

  test "low-point just under 2s" do
    bonus = @controller.calculate_speed_bonus(10, 1.9)
    assert_equal 3, bonus
  end

  test "low-point negative time (should still max tier)" do
    bonus = @controller.calculate_speed_bonus(8, -1)
    assert_equal 0, bonus
  end

  test "zero-point question" do
    bonus = @controller.calculate_speed_bonus(0, 1)
    assert_equal 3, bonus # falls under low-point logic
  end

  test "negative-point question" do
    bonus = @controller.calculate_speed_bonus(-5, 1)
    assert_equal 3, bonus # still low-point logic
  end

  test "bonus never negative even with high time" do
    bonus = @controller.calculate_speed_bonus(100, 100)
    assert_equal 0, bonus
  end

end
