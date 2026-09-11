require "minitest/autorun"
require_relative "../lib/data_cleaner"

class DataCleanerTest < Minitest::Test
    
  def test_parse_string_strips_whitespace_and_returns_nil_for_blank_values
    assert_equal "whitespace", DataCleaner.parse_string("  whitespace ")
    assert_nil DataCleaner.parse_string("   ")
    assert_nil DataCleaner.parse_string(nil)
  end

  def test_parse_int_accepts_comma_formatted_values
    assert_equal 1_250, DataCleaner.parse_int("1,250")
    assert_nil DataCleaner.parse_int("abc")
  end

  def test_parse_int_accepts_whole_number_values
    assert_equal 50, DataCleaner.parse_int(50.0)
    assert_nil DataCleaner.parse_int(50.01)
  end

  def test_parse_float_accepts_supported_currency_symbols
    assert_equal 1_234.50, DataCleaner.parse_float("$1,234.50")
    assert_equal 1_234.50, DataCleaner.parse_float("₱1,234.50")
    assert_equal 1_234.50, DataCleaner.parse_float("¥1,234.50")
  end

  def test_parse_float_returns_nil_for_invalid_values
    assert_nil DataCleaner.parse_float("one hundred")
    assert_nil DataCleaner.parse_float("a10000")
    assert_equal 0.01, DataCleaner.parse_float(".01")
    assert_nil DataCleaner.parse_float(nil)
  end

  def test_format_date_returns_iso_date_or_nil
    assert_equal "2024-03-02", DataCleaner.format_date("2/3/2024")
    assert_equal "2026-09-11", DataCleaner.format_date("  11/09/2026  ")
    assert_nil DataCleaner.format_date("invalid date")
  end
end