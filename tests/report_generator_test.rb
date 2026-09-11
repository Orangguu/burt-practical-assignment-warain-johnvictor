require "minitest/autorun"
require_relative "../lib/report_generator"

class ReportGeneratorTest < Minitest::Test
  STORES = [
    { "shop_id" => "S900", "name" => "UPTC", "city" => "Manila" }
  ].freeze

  def test_generate_detail_cleans_transaction_values_and_resolves_store
    transactions = [
      {
        "shop_id" => " S900 ",
        "date" => "2026-09-11",
        "country" => " Philippines ",
        "channel" => "online",
        "category" => "coffee",
        "units_sold" => "1,250",
        "revenue" => "$1,234.50",
        "transactions" => "80"
      }
    ]

    row = ReportGenerator.generate_detail(transactions, STORES).first

    assert_equal "S900", row["shop_id"]
    assert_equal "UPTC", row["shop_name"]
    assert_equal "Manila", row["shop_city"]
    assert_equal 1_250, row["units_sold"]
    assert_equal 1_234.50, row["revenue"]
    assert_equal 80, row["transactions"]
  end

  def test_generate_detail_keeps_unknown_shop_id_without_store_details
    transactions = [{ "shop_id" => "S999", "units_sold" => "2" }]

    row = ReportGenerator.generate_detail(transactions, STORES).first

    assert_equal "S999", row["shop_id"]
    assert_nil row["shop_name"]
    assert_nil row["shop_city"]
  end

  def test_generate_store_summary_groups_by_shop_id_and_sums_cleaned_values
    detail_rows = [
      {
        "shop_id" => "S900",
        "shop_name" => "UPTC",
        "shop_city" => "Manila",
        "units_sold" => 10,
        "revenue" => 100.50,
        "transactions" => 2
      },
      {
        "shop_id" => "S900",
        "shop_name" => "UPTC",
        "shop_city" => "Manila",
        "units_sold" => 5,
        "revenue" => 49.50,
        "transactions" => 1
      },
      {
        "shop_id" => "S998",
        "shop_name" => nil,
        "shop_city" => nil,
        "units_sold" => 3,
        "revenue" => 20.00,
        "transactions" => 1
      },
      {
        "shop_id" => "S999",
        "shop_name" => nil,
        "shop_city" => nil,
        "units_sold" => 4,
        "revenue" => 30.00,
        "transactions" => 1
      }
    ]

    summaries = ReportGenerator.generate_store_summary(detail_rows)
    main_shop = summaries.find { |row| row["shop_name"] == "UPTC" }
    unknown_summaries = summaries.select { |row| row["shop_name"].nil? }

    assert_equal 15, main_shop["total_units_sold"]
    assert_in_delta 150.0, main_shop["total_revenue"]
    assert_equal 3, main_shop["total_transactions"]
    assert_equal 2, unknown_summaries.length
  end

  def test_generate_store_summary_returns_nil_when_all_numeric_values_are_missing
    detail_rows = [{
      "shop_id" => "S900",
      "shop_name" => "UPTC",
      "shop_city" => "Manila",
      "units_sold" => nil,
      "revenue" => nil,
      "transactions" => nil
    }]

    summary = ReportGenerator.generate_store_summary(detail_rows).first

    assert_nil summary["total_units_sold"]
    assert_nil summary["total_revenue"]
    assert_nil summary["total_transactions"]
  end

  def test_generate_store_summary_includes_registered_shops_without_transactions
    stores = [
      { "shop_id" => "S900", "name" => "UPTC", "city" => "Manila" },
      { "shop_id" => "S901", "name" => "Quiet Shop", "city" => "Cebu" }
    ]

    summaries = ReportGenerator.generate_store_summary([], stores)
    summary = summaries.find { |row| row["shop_name"] == "Quiet Shop" }

    assert_equal "Cebu", summary["shop_city"]
    assert_equal 0, summary["total_units_sold"]
    assert_equal 0, summary["total_revenue"]
    assert_equal 0, summary["total_transactions"]
  end

  def test_generate_detail_returns_nil_for_missing_values
    transactions = [
      {
        "shop_id" => "S900",
        "units_sold" => nil,
        "revenue" => nil,
        "transactions" => nil
      }
    ]

    row = ReportGenerator.generate_detail(transactions, STORES).first

    assert_nil row["units_sold"]
    assert_nil row["revenue"]
    assert_nil row["transactions"]
  end
end
